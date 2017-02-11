![Hex](https://raw.githubusercontent.com/3lvis/Hex/master/Images/hex.png)


>A hex triplet is a six-digit, three-byte hexadecimal number used in HTML, CSS, SVG, and other computing applications to represent colors. The bytes represent the red, green and blue components of the color. One byte represents a number in the range 00 to FF (in hexadecimal notation), or 0 to 255 in decimal notation. This represents the least (0) to the most (255) intensity of each of the color components. Thus web colors specify colors in the True Color (24-bit RGB) color scheme.

Dealing with HEX colors in iOS is problematic and can become quite repetitive, we've long waited for Apple to do something about this but nothing has really happened.

This is why I created `Hex`, a simple tiny extension to UIColor that helps you in this case. It works nicely with both Objective-C and Swift.

## Installation

```ruby
pod 'Hex'
```

## Create color

### Swift
``` swift
import Hex

let redColor = UIColor(hex: "FF0000")
```

### Objective-C

```objc
@import Hex;

UIColor *color = [[UIColor alloc] initWithHex:@"FF0000"];
```

## Translucency

`HEX` doesn't support translucency, since it's only RGB, but we thought why it shouldn't? That's why you can append the translucency percentage at the end of your HEX string. 

Some examples:

```swift
UIColor(hex: "#ff0000")   => UIColor.redColor()
UIColor(hex: "#ff000075") => UIColor.redColor().colorWithAlphaComponent(0.75)
UIColor(hex: "#ff000050") => UIColor.redColor().colorWithAlphaComponent(0.50)
```


## Check for equal colors

Using `isEqual` on UIColor doesn't work when you create the color from an `HEX` string, this is because how UIKit handles colors. That's why before comparing a color you have to convert the colors to RGBSpace. Luckly `Hex` contains a helper method that helps you  checking for equal colors, internally this method normalizes the color space of colors.

```swift
let blackHex = UIColor(hex: "000000")
let black = UIColor.blackColor()

if blackHex.isEqualTo(black) {
    // Do something
}
```

```objc
UIColor *blackHex = [[UIColor alloc] initWithHex: @"000000"];
UIColor *black = [UIColor blackColor];

if ([blackHex isEqualTo:black]) {
    // Do something
}
```

## Be Awesome

If something looks stupid, please create a friendly and constructive issue, getting your feedback would be awesome.

Have a great day.

## Author

Elvis Nuñez, [@3lvis](https://twitter.com/3lvis)

## License

**Hex** is available under the MIT license. See the [LICENSE](/LICENSE.md) file for more info.
