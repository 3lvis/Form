# Form
[![Build Status](https://img.shields.io/travis/hyperoslo/Form.svg?style=flat)](https://travis-ci.org/hyperoslo/Form)

JSON driven forms, check our [Demo](https://github.com/hyperoslo/Form/tree/master/Demos/Basic-ObjC) for an example on how to use Form.

# Usage

## Basic Form

This is the required form to create a basic form with a first name field.

```json
[
  {
    "id":"form-id",
    "title":"Form title",
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

## Contributing

Please check our [playbook](https://github.com/hyperoslo/playbook/blob/master/GIT_AND_GITHUB.md) for guidelines on contributing.

## Credits

[Hyper](http://hyper.no) made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.

## License

HYPForms is available under the MIT license. See the [LICENSE](https://github.com/hyperoslo/Form/raw/master/LICENSE.md) file for more info.
