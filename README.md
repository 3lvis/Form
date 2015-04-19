![Form logo](https://raw.githubusercontent.com/hyperoslo/Form/master/Images/logo-v6.png)

[![Version](https://img.shields.io/cocoapods/v/Form.svg?style=flat)](http://cocoadocs.org/docsets/Form)
[![License](https://img.shields.io/cocoapods/l/Form.svg?style=flat)](http://cocoadocs.org/docsets/Form)
[![Platform](https://img.shields.io/cocoapods/p/Form.svg?style=flat)](http://cocoadocs.org/docsets/Form)
[![Join the chat at https://gitter.im/hyperoslo/Form](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/hyperoslo/Form?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The most flexible and powerful way to build a form on iOS.

Form came out from our need to have a form that could share logic between our iOS apps and our web clients. We found that JSON was the best way to achieve this.

Form includes the following features:

- Multiple groups: For example, you can have a group for personal details and another one for shipping information
- [Field validations](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L19): We support `required`, `max_length`, `min_length` and `format` (regex). We also support many field types, like `text`, `number`, `phone_number`, `email`, `date`, `name` and more
- [Custom sizes](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L15): Total `width` is handled as 100% while `height` is handled in chunks of [85 px](https://github.com/hyperoslo/Form/blob/b1a542d042a45a9a3056fb8969b5704e51fda1f4/Source/Cells/Base/FORMBaseFieldCell.h#L15)
- [Custom fields](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L78): You can register your custom fields, and it's pretty simple (our basic example includes how to make an `image` field)
- [Formulas or computed values](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L47): We support fields that contain generated values from other fields
- [Targets](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L127): `hide`, `show`, `update`, `enable`, `disable` or `clear` a field using a target. It's pretty powerful, and you can even set a condition for your target to run
- [Dropdowns](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L122): Generating dropdowns is as easy as adding values to your field, values support `default` flags, targets (in case you want to trigger hiding a field based on a selection), string and numeric values or showing additional info (in case you want to hint the consequences of your selection).

Form works both on the iPhone and the iPad.

You can try one of our [demos](/Demos) by running this command in your Terminal:

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

#### In your iPad app

##### AppDelegate

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Don't forget to set your style, or use the default one if you want
    [FORMDefaultStyle applyStyle];

    //...
}
```

##### UICollectionViewController
```objc
- (FORMDataSource *)dataSource {
    if (_dataSource) return _dataSource;

    _dataSource = [[FORMDataSource alloc] initWithJSON:self.JSON
                                        collectionView:self.collectionView
                                                layout:self.layout
                                                values:@{@"first_name" : @"Ola"}
                                              disabled:NO];

    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.dataSource = self.dataSource;
}


#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource sizeForFieldAtIndexPath:indexPath];
}
```

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

## Installation

**Form** is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'Form'
```

## Contributing

Please check our [playbook](https://github.com/hyperoslo/playbook/blob/master/GIT_AND_GITHUB.md) for guidelines on contributing.

## Credits

[Hyper](http://hyper.no) made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to [hire you](http://www.hyper.no/jobs/ios-developer).

## License

Form is available under the MIT license. See the [LICENSE](https://github.com/hyperoslo/Form/blob/master/LICENSE.md).
