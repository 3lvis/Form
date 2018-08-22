![Form logo](https://raw.githubusercontent.com/3lvis/Form/master/Images/logo-v6.png)

[![Version](https://img.shields.io/cocoapods/v/Form.svg?style=flat)](http://cocoadocs.org/docsets/Form)
[![License](https://img.shields.io/cocoapods/l/Form.svg?style=flat)](http://cocoadocs.org/docsets/Form)
[![Platform](https://img.shields.io/cocoapods/p/Form.svg?style=flat)](http://cocoadocs.org/docsets/Form)
[![Gitter](https://img.shields.io/gitter/room/nwjs/nw.js.svg)](https://gitter.im/3lvis/Form)

The most flexible and powerful way to build a form on iOS.

Form came out from our need to have a form that could share logic between our iOS apps and our web clients. We found that JSON was the best way to achieve this.

Form includes the following features:

- Multiple groups: For example, you can have a group for personal details and another one for shipping information
- [Field validations](https://github.com/3lvis/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L19): We support `required`, `max_length`, `min_length`, `min_value`, `max_value` and `format` (regex). We also support many field types, like `text`, `number`, `phone_number`, `email`, `date`, `name`, `count`, `segment`, `switch`, and more
- [Custom sizes](https://github.com/3lvis/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L15): Total `width` is handled as 100% while `height` is handled in chunks of [85 px](https://github.com/3lvis/Form/blob/b1a542d042a45a9a3056fb8969b5704e51fda1f4/Source/Cells/Base/FORMBaseFieldCell.h#L15)
- [Custom fields](https://github.com/3lvis/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L78): You can register your custom fields, and it's pretty simple (our basic example includes how to make an `image` field)
- [Formulas or computed values](https://github.com/3lvis/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L47): We support fields that contain generated values from other fields
- [Targets](https://github.com/3lvis/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L127): `hide`, `show`, `update`, `enable`, `disable` or `clear` a field using a target. It's pretty powerful, and you can even set a condition for your target to run
- [Dropdowns](https://github.com/3lvis/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L122): Generating dropdowns is as easy as adding values to your field, values support `default` flags, targets (in case you want to trigger hiding a field based on a selection), string and numeric values or showing additional info (in case you want to hint the consequences of your selection).

Form works both on the iPhone and the iPad.

You can try one of our demos by running this command in your Terminal:

```ruby
pod try Form
```

## Usage

### Basic Form

This are the required steps to create a basic form with a first name field.

![Form](https://github.com/3lvis/Form/blob/master/Images/basic-form.png)

#### JSON
```json
[
  {
    "id":"group-id",
    "title":"Group title",
    "sections":[
      {
        "id":"section-0",
        "fields":[
          {
            "id":"first_name",
            "title":"First name",
            "type":"name",
            "size":{
              "width":30,
              "height":1
            }
          }
        ]
      }
    ]
  }
]
```


#### In your iOS app

**AppDelegate**

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Don't forget to set your style, or use the default one if you want
    [FORMDefaultStyle applyStyle];

    //...
}
```

**Subclass**

Make sure that your `UICollectionViewController` is a subclass of `FORMViewController`.

---------------------------

### Targets

Targets are one of the most powerful features of form, and we support to `hide`, `show`, `update`, `enable`, `disable` or `clear` a field using a target. You can even set a condition for your target to run!

In the following example we show how to hide or show a field based on a dropdown selection.

![Targets](https://github.com/3lvis/Form/blob/master/Images/target.gif)

#### JSON

```json
[
  {
    "id":"group-id",
    "title":"Group title",
    "sections":[
      {
        "id":"section-0",
        "fields":[
          {
            "id":"employment_type",
            "title":"Employment type",
            "type":"select",
            "size":{
              "width":30,
              "height":1
            },
            "values":[
              {
                "id":0,
                "title":"Part time",
                "default":true,
                "targets":[
                  {
                    "id":"bonus",
                    "type":"field",
                    "action":"hide"
                  }
                ]
              },
              {
                "id":1,
                "title":"Full time",
                "targets":[
                  {
                    "id":"bonus",
                    "type":"field",
                    "action":"show"
                  }
                ]
              }
            ]
          },
          {
            "id":"bonus",
            "title":"Bonus",
            "type":"number",
            "size":{
              "width":30,
              "height":1
            }
          }
        ]
      }
    ]
  }
]
```

### Group Collapsibility

Groups have two JSON based collapsibility options: `collapsed` and `collapsible`

The `collapsed` option accepts `true` or `false` and defines the default state for the group it is added to. The default is `false`.

The `collapsible` option also accepts `true` or `false` but defines whether or not a group can be collapsed at all. Defining this option as `false`, prevents a group from being collapsed on click or with `collapseAllGroupsForCollectionView`. The default is `true`.

In your application code, you can also call `collapseAllGroupsForCollectionView` on the data source to collapse all groups in a collection view.

### Counter Fields

To make quick and easy integer adjustments without popping up a keyboard, you can use the  `count` field. It works just like a `number` field but provides a minus button in the UITextField's leftView and a plus button in the rightView. A tap on either will decrease or increase, respectively, the number by a value of one.

#### Example JSON
```json
{
  "groups":[
    {
      "id":"counter",
      "title":"Counter Example",
      "sections":[
        {
          "id":"counter-example",
          "fields":[
            {
              "id":"guests",
              "title":"Present Guests",
              "info":"Press minus to decrease, plus to increase",
              "type":"count",
              "value":0,
              "size":{
                "width":25,
                "height":1
              },
              "validations":{
                "required":true,
                "min_value":0,
                "max_value":100
              }
            }
          ]
        }
      ]
    }
  ]
}
```

### Segment Fields

Segment fields can be used in place of text or select fields where the options are known and limited. Since segment fields do not require multiple taps or keyboard entry, data can be recorded quickly and easily with a single click. The `segment` field type allows for multiple values like the `select` field type and supports many of the same attributes.

#### Example JSON
```json
{
  "groups":[
    {
      "id":"group1",
      "title":"Segment Example",
      "sections":[
        {
          "id":"section1",
          "fields":[
            {
              "id":"location",
              "title":"Work Location",
              "type":"segment",
              "styles":{
                "font":"AvenirNext-DemiBold",
                "font_size":"16.0",
                "tint_color":"#CBEDBF"
              },
              "values":[
                {
                  "id":"in_house",
                  "title":"In-house",
                  "info":"In-house employee",
                  "default":true,
                },
                {
                  "id":"remote",
                  "title":"Remote",
                }
              ],
              "size":{
                "width":50,
                "height":1
              }
            }
          ]
        }
      ]
    }
  ]
}
```

### Switch Fields

Switch fields can be used where a true or false response is desired. The `switch` field type allows for a single value of `0`, `false`, `1`, or `true`. Background and tint color styles are also available for this field.

#### Example JSON
```json
{
  "groups":[
    {
      "id":"group1",
      "title":"Switch Example",
      "sections":[
        {
          "id":"section1",
          "fields":[
            {
              "id":"budget_approved",
              "title":"Budget Approved",
              "type":"switch",
              "styles":{
                "tint_color":"#CBEDBF"
              },
              "value":false,
              "size":{
                "width":50,
                "height":1
              }
            }
          ]
        }
      ]
    }
  ]
}
```

### Accessibility Labels

Accessibility labels are used by VoiceOver on iOS to provide feedback to users with visual impairments. According to Apple, the accessibility label attribute is "a short, localized word or phrase that succinctly describes the control or view, but does not identify the element's type. Examples are 'Add' or 'Play.'"

Field values are automatically mapped to Accessibility Value attributes to provide accurate feedback to users.

In addition to providing assistive feedback to users with impairments, accessibility labels can be useful for UI testing. Libraries such as [KIF](https://github.com/kif-framework/KIF), [EarlGrey](https://github.com/google/EarlGrey), and [Calabash](http://calaba.sh/) can use accessibility labels to access and control fields.

#### Example JSON
```json
{
  "groups":[
    {
      "id":"group1",
      "title":"Accessibility Example",
      "sections":[
        {
          "id":"section1",
          "fields":[
            {
              "id":"first_name",
              "title":"First Name",
              "info":"Enter your first name",
              "accessibility_label":"First Name Accessibility Label",
              "type":"name",
              "size":{
                "width":25,
                "height":1
              }
            }
          ]
        }
      ]
    }
  ]
}
```

## FAQ

### How do I get the contents of a field?

```objc
FORMField *targetField = [dataSource fieldWithID:@"display_name" includingHiddenFields:YES];
id value = targetField.value;
// Do something with value
```

### How do I get all the values of the Form?

```objc
NSDictionary *initialValues = @{@"email" : @"hi@there.com",
                                @"companies[0].name" : @"Facebook",
                                @"companies[0].phone_number" : @"1222333"};

FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                   collectionView:nil
                                                           layout:nil
                                                           values:initialValues
                                                         disabled:NO];
NSDictionary *values = dataSource.values;
// Do something with values
```

### How do I make a universal Form?

You have to specify and iPhone specific JSON file. Something [like this](https://github.com/3lvis/Form/blob/master/iPhone-Storyboard/Form.json), check the iPhone-Storyboard demo for more information.

We went for this approach since it gives the developers more control over the UI. You have to add a check for device and present the JSON file that matches the device.

### How do I dynamically update a field's values?

The method below takes two arguments: `fieldID` and `options`. The `fieldID` argument is simply an NSString with the ID of the field to update. The `options` argument is an NSArray of NSDictionaries with `valueID`, `valueName`, and `defaultValue` keys. A similar approach could be used to take data from another method or web-service and update your field with it. This approach can be used with `select` and `segment` fields.

```objc
- (void)updateSelectField:(NSString *)fieldID withOptions:(NSArray *)options {
    __weak typeof(self)weakSelf = self;

    [self.dataSource fieldWithID:fieldID includingHiddenFields:YES completion:^(FORMField *field, NSIndexPath *indexPath) {
        NSMutableArray *values = @[].mutableCopy;

        for (NSDictionary *option in options) {
            FORMFieldValue *fieldValue = [FORMFieldValue new];
            fieldValue.valueID = [option valueForKey:@"valueID"];
            fieldValue.title = [option valueForKey:@"valueName"];
            fieldValue.default = [option valueForKey:@"defaultValue"];
            fieldValue.field = field;

            [values addObject:fieldValue];
        }

        field.values = [values copy];

        if (!field.hidden) {
          [weakSelf.dataSource reloadFieldsAtIndexPaths:@[indexPath]];
        }
    }];
}
```

## Installation

**Form** is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
use_frameworks!

pod 'Form'
```

## Credits

This library was originally done at [Hyper](http://hyper.no). A digital communications agency with a passion for good code and delightful user experiences. They were kind enough to transfer it to me for further development.

## License

Form is available under the MIT license. See the [LICENSE](https://github.com/3lvis/Form/blob/master/LICENSE.md).
