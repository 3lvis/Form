![Form logo](https://raw.githubusercontent.com/hyperoslo/Form/master/Images/logo-v6.png)

[![Version](https://img.shields.io/cocoapods/v/Form.svg?style=flat)](http://cocoadocs.org/docsets/Form)
[![License](https://img.shields.io/cocoapods/l/Form.svg?style=flat)](http://cocoadocs.org/docsets/Form)
[![Platform](https://img.shields.io/cocoapods/p/Form.svg?style=flat)](http://cocoadocs.org/docsets/Form)

The most flexible and powerful way to build a form on iOS.

Form came out from our need to have a form that could share logic between our iOS apps and our web clients. We found that JSON was the best way to achieve this.

Form includes the following features:

- Multiple groups: For example, you can have a group for personal details and another one for shipping information
- [Field validations](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L19): We support `required`, `max_length`, `min_length`, `min_value`, `max_value` and `format` (regex). We also support many field types, like `text`, `number`, `phone_number`, `email`, `date`, `name`, `count` and more
- [Custom sizes](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L15): Total `width` is handled as 100% while `height` is handled in chunks of [85 px](https://github.com/hyperoslo/Form/blob/b1a542d042a45a9a3056fb8969b5704e51fda1f4/Source/Cells/Base/FORMBaseFieldCell.h#L15)
- [Custom fields](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L78): You can register your custom fields, and it's pretty simple (our basic example includes how to make an `image` field)
- [Formulas or computed values](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L47): We support fields that contain generated values from other fields
- [Targets](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L127): `hide`, `show`, `update`, `enable`, `disable` or `clear` a field using a target. It's pretty powerful, and you can even set a condition for your target to run
- [Dropdowns](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L122): Generating dropdowns is as easy as adding values to your field, values support `default` flags, targets (in case you want to trigger hiding a field based on a selection), string and numeric values or showing additional info (in case you want to hint the consequences of your selection).

Form works both on the iPhone and the iPad.

You can try one of our demos by running this command in your Terminal:

```ruby
pod try Form
```

## Usage

### Basic Form

This are the required steps to create a basic form with a first name field.

![Form](https://github.com/hyperoslo/Form/blob/master/Images/basic-form.png)

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

![Targets](https://github.com/hyperoslo/Form/blob/master/Images/target.gif)

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

You have to specify and iPhone specific JSON file. Something [like this](https://github.com/hyperoslo/Form/blob/master/iPhone-Storyboard/Form.json), check the iPhone-Storyboard demo for more information.

We went for this approach since it gives the developers more control over the UI. You have to add a check for device and present the JSON file that matches the device.

## Installation

**Form** is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
use_frameworks!

pod 'Form'
```

## Contributing

Please check our [playbook](https://github.com/hyperoslo/playbook/blob/master/GIT_AND_GITHUB.md) for guidelines on contributing.

## Credits

[Hyper](http://hyper.no) made this. We’re a digital communications agency with a passion for good code and delightful user experiences. If you’re using this library we probably want to [hire you](https://github.com/hyperoslo/iOS-playbook/blob/master/HYPER_RECIPES.md) (we consider remote employees too, the only requirement is that you’re awesome).

## License

Form is available under the MIT license. See the [LICENSE](https://github.com/hyperoslo/Form/blob/master/LICENSE.md).
