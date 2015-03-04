![Form](https://github.com/hyperoslo/Form/blob/master/Images/logo-v2.png)

Form came out from our need to a form that could share logic between our iOS apps and our web clients, we found that JSON was one way to achieve this.

Form includes the following features:

- Multiple groups: For example you can have a group for personal details and another one for shipping information
- [Field validations](https://github.com/hyperoslo/Form/blob/master/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L18): We support `required`, `maximum length`, `minimum length` and `format` (regex). We also support many field types, for example: `text`, `number`, `phone_number`, `email`, `date`, `name` and more
- [Custom sizes](https://github.com/hyperoslo/Form/blob/master/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L14): Total `width` is handled as 100% while `height` is handled in chunks of [85 px](https://github.com/hyperoslo/Form/blob/b1a542d042a45a9a3056fb8969b5704e51fda1f4/Source/Cells/Base/FORMBaseFieldCell.h#L15)
- [Custom fields](https://github.com/hyperoslo/Form/blob/master/Demos/Basic-ObjC/Basic-ObjC/Controllers/HYPSampleCollectionViewController.m#L63): You can register your custom fields, it's pretty simple (our basic example includes how to make an `image` field)
- [Formulas or computed values](https://github.com/hyperoslo/Form/blob/master/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L62): We support fields that contain generated values from other fields
- [Targets](https://github.com/hyperoslo/Form/blob/master/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L22): `Hide`, `show`, `update`, `enable`, `disable` or `clear` a field using a target. It's pretty powerful, you can even set a [condition](https://github.com/hyperoslo/Form/blob/master/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L27) for your target to run
- [Dropdowns](https://github.com/hyperoslo/Form/blob/master/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L100): Generating dropdowns is as easy as adding values to your field, values support `default` flags, targets (in case you want to trigger hiding a field based on a selection), string values or numeric values and subtitles (in case you want to hint the consecuences of your selection)

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

## Contributing

Please check our [playbook](https://github.com/hyperoslo/playbook/blob/master/GIT_AND_GITHUB.md) for guidelines on contributing.

## Credits

[Hyper](http://hyper.no) made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.

## License

Forms is available under the MIT license. See the [LICENSE](https://github.com/hyperoslo/Form/raw/master/LICENSE.md) file for more info.
