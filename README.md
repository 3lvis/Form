![Form logo](https://raw.githubusercontent.com/hyperoslo/Form/master/Images/logo-v6.png)

[![Version](https://img.shields.io/cocoapods/v/Form.svg?style=flat)](http://cocoadocs.org/docsets/Form)
[![License](https://img.shields.io/cocoapods/l/Form.svg?style=flat)](http://cocoadocs.org/docsets/Form)
[![Platform](https://img.shields.io/cocoapods/p/Form.svg?style=flat)](http://cocoadocs.org/docsets/Form)
[![Join the chat at https://gitter.im/hyperoslo/Form](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/hyperoslo/Form?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The most flexible and powerful way to build a form on iOS.

Form came out from our need to have a form that could share logic between our iOS apps and our web clients. We found that JSON was the best way to achieve this.

Form includes the following features:

- Multiple groups: For example, you can have a group for personal details and another one for shipping information
- [Field validations](https://github.com/hyperoslo/Form/blob/d426e7b090fee7a630d1208b87c63a85b6aaf5df/Demos/Basic-ObjC/Basic-ObjC/Assets/forms.json#L19): We support `required`, `max_length`, `min_length`, `min_value`, `max_value` and `format` (regex). We also support many field types, like `text`, `number`, `phone_number`, `email`, `date`, `name` and more
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

### Styled Form

Form allows global and per-field styling. The table below shows the per-field styling options.

| Target           | Description                   | JSON Key                       | Value Type | Example (Default)                          |
| :--------------- | :---------------------------- | :----------------------------- | :--------- | :----------------------------------------- |
| **Groups**       | Background Color              | `background_color`             | `Hex`      | `"background_color":"#FFFFFF"`             |
|                  | Header Text Color             | `text_color`                   | `Hex`      | `"text_color":"#455C73"`                   |
|                  | Font                          | `font`                         | `String`   | `"font":"AvenirNext-Medium"`               |
|                  | Font Size                     | `font_size`                    | `Float`    | `"font_size":"17.0"`                       |
| ---              |                               |                                |            |                                            |
| **Sections**     | Separator Color               | `separator_color`              | `Hex`      | `"separator_color":"#C6C6C6"`              |
| ---              |                               |                                |            |                                            |
| **Buttons**      | Background Color              | `background_color`             | `Hex`      | `"background_color":"#3DAFEB"`             |
|                  | Highlighted Background Color  | `highlighted_background_color` | `Hex`      | `"highlighted_background_color":"#FFFFFF"` |
|                  | Title Color                   | `title_color`                  | `Hex`      | `"title_color":"#FFFFFF"`                  |
|                  | Highlighted Title Color       | `highlighted_title_color`      | `Hex`      | `"highlighted_title_color":"#3DAFEB"`      |
|                  | Border Color                  | `border_color`                 | `Hex`      | `"border_color":"#3DAFEB"`                 |
|                  | Corner Radius                 | `corner_radius`                | `Float`    | `"corner_radius":"5.0"`                    |
|                  | Border Width                  | `border_width`                 | `Float`    | `"border_width":"1.0"`                     |
|                  | Font                          | `font`                         | `String`   | `"font":"AvenirNext-DemiBold"`             |
|                  | Font Size                     | `font_size`                    | `Float`    | `"font_size":"16.0"`                       |
| ---              |                               |                                |            |                                            |
| **Text Fields**  | Font                          | `font`                         | `String`   | `"font":"AvenirNext-Regular"`              |
|                  | Font Size                     | `font_size`                    | `Float`    | `"font_size":"15.0"`                       |
|                  | Corner Radius                 | `corner_radius`                | `Float`    | `"corner_radius":"5.0"`                    |
|                  | Border Width                  | `border_width`                 | `Float`    | `"border_width":"1.0"`                     |
|                  | Active Background Color       | `active_background_color`      | `Hex`      | `"active_background_color":"#C0EAFF"`      |
|                  | Active Border Color           | `active_border_color`          | `Hex`      | `"active_border_color":"#3DAFEB"`          |
|                  | Inactive Background Color     | `inactive_background_color`    | `Hex`      | `"inactive_background_color":"#E1F5FF"`    |
|                  | Inactive Border Color         | `inactive_border_color`        | `Hex`      | `"inactive_border_color":"#3DAFEB"`        |
|                  | Enabled Background Color      | `enabled_background_color`     | `Hex`      | `"enabled_background_color":"#E1F5FF"`     |
|                  | Enabled Border Color          | `enabled_border_color`         | `Hex`      | `"enabled_border_color":"#3DAFEB"`         |
|                  | Enabled Text Color            | `enabled_text_color`           | `Hex`      | `"enabled_text_color":"#455C73"`           |
|                  | Disabled Background Color     | `disabled_background_color`    | `Hex`      | `"disabled_background_color":"#F5F5F8"`    |
|                  | Disabled Border Color         | `disabled_border_color`        | `Hex`      | `"disabled_border_color":"#DEDEDE"`        |
|                  | Disabled Text Color           | `disabled_text_color`          | `Hex`      | `"disabled_text_color":"#808080"`          |
|                  | Valid Background Color        | `valid_background_color`       | `Hex`      | `"valid_background_color":"#E1F5FF"`       |
|                  | Valid Border Color            | `valid_border_color`           | `Hex`      | `"valid_border_color":"#3DAFEB"`           |
|                  | Invalid Background Color      | `invalid_background_color`     | `Hex`      | `"invalid_background_color":"#FFD7D7"`     |
|                  | Invalid Border Color          | `invalid_border_color`         | `Hex`      | `"invalid_border_color":"#EC3031"`         |
|                  | Tooltip Font                  | `tooltip_font`                 | `String`   | `"tooltip_font":"AvenirNext-Medium"`       |
|                  | Tooltip Font Size             | `tooltip_font_size`            | `Float`    | `"tooltip_font_size":"14.0"`               |
|                  | Tooltip Label Text Color      | `tooltip_label_text_color`     | `Hex`      | `"tooltip_label_text_color":"#97591D"`     |
| (not functional) | Tooltip Background Color      | `tooltip_background_color`     | `Hex`      | `"tooltip_background_color":"#FDFD54"`     |
|                  | Clear Button Color            | `clear_button_color`           | `Hex`      | `"clear_button_color":"#3DAFEB"`           |
|                  | Minus Button Color            | `minus_button_color`           | `Hex`      | `"minus_button_color":"#3DAFEB"`           |
|                  | Plus Button Color             | `plus_button_color`            | `Hex`      | `"plus_button_color":"#3DAFEB"`            |
| **Field Labels** | Heading Label Font            | `heading_label_font`           | `String`   | `"heading_label_font":"AvenirNext-Medium"` |
|                  | Heading Label Font Size       | `heading_label_font_size`      | `Float`    | `"heading_label_font_size":"17.0"`         |
|                  | Heading Label Text Color      | `heading_label_text_color`     | `Hex`      | `"heading_label_text_color":"#455C73"`     |

#### Style JSON
```json
[
  {
    "id":"group-id",
    "title":"Group title",
    "styles":{
      "background_color":"#FFFFFF",
      "text_color":"#455C73",
      "font":"AvenirNext-Medium",
      "font_size":"17.0"
    },
    "sections":[
      {
        "id":"section-0",
        "styles":{
          "separator_color":"#60B044"
        },
        "fields":[
          {
            "id":"first_name",
            "title":"First name",
            "info":"This field is optional",
            "type":"name",
            "styles":{
              "font":"AvenirNext-Regular",
              "font_size":"15.0",
              "corner_radius":"5.0",
              "border_width":"1.0",
              "border_color":"#FF0000",
              "active_background_color":"#60B044",
              "active_border_color":"#418F26",
              "inactive_background_color":"#E1F5FF",
              "inactive_border_color":"#3DAFEB",
              "enabled_background_color":"#CBEDBF",
              "enabled_border_color":"#418F26",
              "enabled_text_color":"#163F07",
              "disabled_background_color":"#EEEEEE",
              "disabled_border_color":"#CCCCCC",
              "disabled_text_color":"#777777",
              "valid_background_color":"#E1F5FF",
              "valid_border_color":"#418F26",
              "invalid_background_color":"#FFD7D7",
              "invalid_border_color":"#EC3031",
              "tooltip_font":"AvenirNext",
              "tooltip_font_size":"14.0",
              "tooltip_label_text_color":"#163F07",
              "clear_button_color":"#163F07",
              "heading_label_font":"AvenirNext-DemiBold",
              "heading_label_font_size":"18.0",
              "heading_label_text_color":"#60B044",
            },
            "size":{
              "width":50,
              "height":1
            }
          },
          {
            "id":"last_name",
            "title":"Last name",
            "info":"This field is required",
            "type":"name",
            "styles":{
              "font":"AvenirNext-Regular",
              "font_size":"15.0",
              "corner_radius":"5.0f",
              "border_width":"1.0f",
              "active_background_color":"#FF0000",
              "active_border_color":"#3DAFEB",
              "inactive_background_color":"#E1F5FF",
              "inactive_border_color":"#3DAFEB",
              "enabled_background_color":"#E1F5FF",
              "enabled_border_color":"#3DAFEB",
              "enabled_text_color":"#455C73",
              "disabled_background_color":"#F5F5F8",
              "disabled_border_color":"#DEDEDE",
              "disabled_text_color":"#808080",
              "valid_background_color":"#E1F5FF",
              "valid_border_color":"#3DAFEB",
              "invalid_background_color":"#FFD7D7",
              "invalid_border_color":"#EC3031",
              "tooltip_font":"AvenirNext-Medium",
              "tooltip_font_size":"14.0",
              "tooltip_label_text_color":"#000000",
              "clear_button_color":"#3DAFEB",
              "heading_label_font":"AvenirNext-DemiBold",
              "heading_label_font_size":"18.0",
              "heading_label_text_color":"#FF0000",
            },
            "size":{
              "width":50,
              "height":1
            },
            "validations":{
              "required":true,
              "min_length":2
            }
          }
        ]
      },
      {
        "id":"section-1",
        "fields":[
          {
            "id":"button",
            "title":"Submit",
            "type":"button",
            "styles":{
              "background_color":"#60B044",
              "highlighted_background_color":"#CBEDBF",
              "title_color":"#FFFFFF",
              "highlighted_title_color":"#60B044",
              "border_color":"#418F26",
              "corner_radius":"10.0",
              "border_width":"2.0",
              "font":"AvenirNext-Heavy",
              "font_size":"18.0"
            },
            "size":{
              "width":100,
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
