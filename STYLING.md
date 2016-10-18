# Styling

Form allows global and per-field styling. The table below shows the per-field styling options.

| Target             | Description                   | JSON Key                       | Value Type | Example (Default)                          |
| :----------------- | :---------------------------- | :----------------------------- | :--------- | :----------------------------------------- |
| **Groups**         | Background Color              | `background_color`             | `Hex`      | `"background_color":"#FFFFFF"`             |
|                    | Header Text Color             | `text_color`                   | `Hex`      | `"text_color":"#455C73"`                   |
|                    | Font                          | `font`                         | `String`   | `"font":"AvenirNext-Medium"`               |
|                    | Font Size                     | `font_size`                    | `Float`    | `"font_size":"17.0"`                       |
| ---                |                               |                                |            |                                            |
| **Sections**       | Separator Color               | `separator_color`              | `Hex`      | `"separator_color":"#C6C6C6"`              |
| ---                |                               |                                |            |                                            |
| **Buttons**        | Background Color              | `background_color`             | `Hex`      | `"background_color":"#3DAFEB"`             |
|                    | Highlighted Background Color  | `highlighted_background_color` | `Hex`      | `"highlighted_background_color":"#FFFFFF"` |
|                    | Title Color                   | `title_color`                  | `Hex`      | `"title_color":"#FFFFFF"`                  |
|                    | Highlighted Title Color       | `highlighted_title_color`      | `Hex`      | `"highlighted_title_color":"#3DAFEB"`      |
|                    | Border Color                  | `border_color`                 | `Hex`      | `"border_color":"#3DAFEB"`                 |
|                    | Corner Radius                 | `corner_radius`                | `Float`    | `"corner_radius":"5.0"`                    |
|                    | Border Width                  | `border_width`                 | `Float`    | `"border_width":"1.0"`                     |
|                    | Font                          | `font`                         | `String`   | `"font":"AvenirNext-DemiBold"`             |
|                    | Font Size                     | `font_size`                    | `Float`    | `"font_size":"16.0"`                       |
| ---                |                               |                                |            |                                            |
| **Text Fields**    | Font                          | `font`                         | `String`   | `"font":"AvenirNext-Regular"`              |
|                    | Font Size                     | `font_size`                    | `Float`    | `"font_size":"15.0"`                       |
|                    | Corner Radius                 | `corner_radius`                | `Float`    | `"corner_radius":"5.0"`                    |
|                    | Border Width                  | `border_width`                 | `Float`    | `"border_width":"1.0"`                     |
|                    | Active Background Color       | `active_background_color`      | `Hex`      | `"active_background_color":"#C0EAFF"`      |
|                    | Active Border Color           | `active_border_color`          | `Hex`      | `"active_border_color":"#3DAFEB"`          |
|                    | Inactive Background Color     | `inactive_background_color`    | `Hex`      | `"inactive_background_color":"#E1F5FF"`    |
|                    | Inactive Border Color         | `inactive_border_color`        | `Hex`      | `"inactive_border_color":"#3DAFEB"`        |
|                    | Enabled Background Color      | `enabled_background_color`     | `Hex`      | `"enabled_background_color":"#E1F5FF"`     |
|                    | Enabled Border Color          | `enabled_border_color`         | `Hex`      | `"enabled_border_color":"#3DAFEB"`         |
|                    | Enabled Text Color            | `enabled_text_color`           | `Hex`      | `"enabled_text_color":"#455C73"`           |
|                    | Disabled Background Color     | `disabled_background_color`    | `Hex`      | `"disabled_background_color":"#F5F5F8"`    |
|                    | Disabled Border Color         | `disabled_border_color`        | `Hex`      | `"disabled_border_color":"#DEDEDE"`        |
|                    | Disabled Text Color           | `disabled_text_color`          | `Hex`      | `"disabled_text_color":"#808080"`          |
|                    | Valid Background Color        | `valid_background_color`       | `Hex`      | `"valid_background_color":"#E1F5FF"`       |
|                    | Valid Border Color            | `valid_border_color`           | `Hex`      | `"valid_border_color":"#3DAFEB"`           |
|                    | Invalid Background Color      | `invalid_background_color`     | `Hex`      | `"invalid_background_color":"#FFD7D7"`     |
|                    | Invalid Border Color          | `invalid_border_color`         | `Hex`      | `"invalid_border_color":"#EC3031"`         |
|                    | Tooltip Font                  | `tooltip_font`                 | `String`   | `"tooltip_font":"AvenirNext-Medium"`       |
|                    | Tooltip Font Size             | `tooltip_font_size`            | `Float`    | `"tooltip_font_size":"14.0"`               |
|                    | Tooltip Label Text Color      | `tooltip_label_text_color`     | `Hex`      | `"tooltip_label_text_color":"#97591D"`     |
| (not functional)   | Tooltip Background Color      | `tooltip_background_color`     | `Hex`      | `"tooltip_background_color":"#FDFD54"`     |
|                    | Clear Button Color            | `clear_button_color`           | `Hex`      | `"clear_button_color":"#3DAFEB"`           |
|                    | Minus Button Color            | `minus_button_color`           | `Hex`      | `"minus_button_color":"#3DAFEB"`           |
|                    | Plus Button Color             | `plus_button_color`            | `Hex`      | `"plus_button_color":"#3DAFEB"`            |
| **Field Labels**   | Heading Label Font            | `heading_label_font`           | `String`   | `"heading_label_font":"AvenirNext-Medium"` |
|                    | Heading Label Font Size       | `heading_label_font_size`      | `Float`    | `"heading_label_font_size":"17.0"`         |
|                    | Heading Label Text Color      | `heading_label_text_color`     | `Hex`      | `"heading_label_text_color":"#455C73"`     |
| ---                |                               |                                |            |                                            |
| **Segment Fields** | Font                          | `font`                         | `String`   | `"font":"AvenirNext-DemiBold"`             |
|                    | Font Size                     | `font_size`                    | `Float`    | `"font_size":"15.0"`                       |
|                    | Tint Color                    | `tint_color`                   | `Hex`      | `"tint_color":"#E1F5FF"`                   |

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
              "border_width":"2.0",
              "active_background_color":"#60B044",
              "active_border_color":"#418F26",
              "inactive_background_color":"#B2B2E0",
              "inactive_border_color":"#000099",
              "enabled_background_color":"#CBEDBF",
              "enabled_border_color":"#418F26",
              "enabled_text_color":"#163F07",
              "disabled_background_color":"#EEEEEE",
              "disabled_border_color":"#CCCCCC",
              "disabled_text_color":"#777777",
              "valid_background_color":"#FFC2FF",
              "valid_border_color":"#662966",
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
              "corner_radius":"5.0",
              "border_width":"2.0",
              "active_background_color":"#FF0000",
              "active_border_color":"#660000",
              "inactive_background_color":"#FFFFC2",
              "inactive_border_color":"#E6E65C",
              "enabled_background_color":"#D1B2D1",
              "enabled_border_color":"#660066",
              "enabled_text_color":"#455C73",
              "disabled_background_color":"#F5F5F8",
              "disabled_border_color":"#DEDEDE",
              "disabled_text_color":"#808080",
              "valid_background_color":"#CCE0CC",
              "valid_border_color":"#003D00",
              "invalid_background_color":"#D1C2B2",
              "invalid_border_color":"#3D1F00",
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
          },
          {
            "id":"location",
            "title":"Work Location",
            "type":"segment",
            "styles":{
              "font":"AvenirNext-DemiBold",
              "font_size":"15.0",
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
          },
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
