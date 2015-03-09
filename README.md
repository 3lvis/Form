![Form](https://github.com/hyperoslo/Form/blob/master/Images/logo-v2.png)

The most flexible and powerful way to build a form on iOS.

Form came out from our need to have a form that could share logic between our iOS apps and our web clients, we found that JSON was the best way to achieve this.

Form includes the following features:

- Multiple groups: For example you can have a group for personal details and another one for shipping information
- [Field validations](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L19): We support `required`, `maximum length`, `minimum length` and `format` (regex). We also support many field types, for example: `text`, `number`, `phone_number`, `email`, `date`, `name` and more
- [Custom sizes](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L15): Total `width` is handled as 100% while `height` is handled in chunks of [85 px](https://github.com/hyperoslo/Form/blob/b1a542d042a45a9a3056fb8969b5704e51fda1f4/Source/Cells/Base/FORMBaseFieldCell.h#L15)
- [Custom fields](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L78): You can register your custom fields, it's pretty simple (our basic example includes how to make an `image` field)
- [Formulas or computed values](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L47): We support fields that contain generated values from other fields
- [Targets](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L127): `Hide`, `show`, `update`, `enable`, `disable` or `clear` a field using a target. It's pretty powerful, you can even set a condition for your target to run
- [Dropdowns](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L122): Generating dropdowns is as easy as adding values to your field, values support `default` flags, targets (in case you want to trigger hiding a field based on a selection), string values or numeric values and subtitles (in case you want to hint the consequences of your selection)

Don't forget to check our [Basic Demo](https://github.com/hyperoslo/Form/tree/master/Demos/Basic-ObjC) for a basic example on how to use Form.

At the moment Form only supports the iPad, support for the iPhone will come soon.

## Usage

### Basic Form

This is the required form to create a basic form with a first name field.

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
```objc
// AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Don't forget to set your style, or use the default one if you want
    [FORMDefaultStyle applyStyle];

    //...
}

// UICollectionViewController subclass
- (FORMDataSource *)dataSource
{
    if (_dataSource) return _dataSource;

    _dataSource = [[FORMDataSource alloc] initWithJSON:self.JSON
                                        collectionView:self.collectionView
                                                layout:self.layout
                                                values:nil
                                              disabled:NO];

    return _dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.dataSource = self.dataSource;
}

```
<hr>

### Targets

Targets are one of the most powerful features of form, we support: `hide`, `show`, `update`, `enable`, `disable` or `clear` a field using a target. You can even set a condition for your target to run!

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
                "title": "Part time",
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
#### Example

![Targets](https://github.com/hyperoslo/Form/blob/master/Images/target.gif)

## Contributing

Please check our [playbook](https://github.com/hyperoslo/playbook/blob/master/GIT_AND_GITHUB.md) for guidelines on contributing.

## Credits

[Hyper](http://hyper.no) made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.

## License

Forms is available under the MIT license. See the [LICENSE](https://github.com/hyperoslo/Form/raw/master/LICENSE.md) file for more info.
