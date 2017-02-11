import UIKit

extension UIColor {
    /**
     Base initializer, it creates an instance of `UIColor` using an HEX string.
     - parameter hex: The base HEX string to create the color.
     */
    public convenience init(hex: String) {
        let noHashString = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: noHashString)
        scanner.charactersToBeSkipped = CharacterSet.symbols
        
        var alpha:CGFloat = 1.0
        if noHashString.characters.count > 6 {
            let startIndex = noHashString.characters.index(noHashString.endIndex, offsetBy: -2)
            let alphaString = noHashString.substring(from: startIndex)
            if let value = NumberFormatter().number(from: alphaString) {
                alpha = CGFloat(Float(value) * 0.01)
            }
        }

        var hexInt: UInt32 = 0
        if (scanner.scanHexInt32(&hexInt)) {
            let red = (hexInt >> 16) & 0xFF
            let green = (hexInt >> 8) & 0xFF
            let blue = (hexInt) & 0xFF

            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }

    func convertToRGBSpace() -> UIColor {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()

        if  self.cgColor.colorSpace?.model == CGColorSpaceModel.monochrome {
            let oldComponents = self.cgColor.components
            let colorRef = CGColor(colorSpace: colorSpaceRGB, components: [(oldComponents?[0])!, (oldComponents?[0])!, (oldComponents?[0])!, (oldComponents?[1])!])!
            let color = UIColor(cgColor: colorRef)

            return color
        }

        return self
    }

    // --> Not working for a few cases because of iOS 10's new color handling.
    /**
     Checks if two colors are equal.
     - parameter color: The color to compare.
     - returns: `true` if the colors are equal.
     */
//    public func isEqualTo(_ color: UIColor) -> Bool {
//        let selfColor = self.convertToRGBSpace()
//        let otherColor = color.convertToRGBSpace()
//
//        return selfColor.isEqual(otherColor)
//    }
}
