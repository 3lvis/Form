#import "UIColor+HYPFormsColors.h"

#import "UIColor+ANDYHex.h"

@implementation UIColor (HYPFormsColors)

#pragma mark - Color scheme

+ (UIColor *)HYPFormsCoreBlue
{
    return [UIColor colorFromHex:@"28649C"];
}

+ (UIColor *)HYPFormsDarkBlue
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)HYPFormsCallToAction
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)HYPFormsCallToActionPressed
{
    return [UIColor colorFromHex:@"008ED9"];
}

+ (UIColor *)HYPFormsBackground
{
    return [UIColor colorFromHex:@"DAE2EA"];
}

+ (UIColor *)HYPFormsLightGray
{
    return [UIColor colorFromHex:@"F5F5F8"];
}

+ (UIColor *)HYPFormsDarkGray
{
    return [UIColor colorFromHex:@"979797"];
}

+ (UIColor *)HYPFormsFieldForeground
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)HYPFormsFieldForegroundActive
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)HYPFormsFieldForegroundInvalid
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)HYPFormsFieldForegroundDisabled
{
    return [UIColor colorFromHex:@"C6C6C6"];
}

+ (UIColor *)HYPFormsFieldBackground
{
    return [UIColor colorFromHex:@"E1F5FF"];
}

+ (UIColor *)HYPFormsFieldBackgroundActive
{
    return [UIColor colorFromHex:@"C0EAFF"];
}

+ (UIColor *)HYPFormsFieldBackgroundInvalid
{
    return [UIColor colorFromHex:@"FFD7D7"];
}

+ (UIColor *)HYPFormsFieldBackgroundDisabled
{
    return [UIColor colorFromHex:@"FFFFFF"];
}

+ (UIColor *)HYPFormsFieldBorder
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)HYPFormsFieldBorderActive
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)HYPFormsFieldBorderInvalid
{
    return [UIColor colorFromHex:@"EC3031"];
}

+ (UIColor *)HYPFormsFieldBorderDisabled
{
    return [UIColor colorFromHex:@"C6C6C6"];
}

+ (UIColor *)HYPFormsBlue
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)HYPFormsGreen
{
    return [UIColor colorFromHex:@"69C204"];
}

+ (UIColor *)HYPFormsYellow
{
    return [UIColor colorFromHex:@"FEC22E"];
}

+ (UIColor *)HYPFormsRed
{
    return [UIColor colorFromHex:@"EC3031"];
}

#pragma mark - Interface

+ (UIColor *)tableCellBackground
{
    return [UIColor windowBackgroundColor];
}

+ (UIColor *)tableCellBorder
{
    return [UIColor HYPFormsDarkBlue];
}

+ (UIColor *)borderColor
{
    return [UIColor HYPFormsBlue];
}

+ (UIColor *)windowBackgroundColor
{
    return [UIColor HYPFormsBackground];
}

+ (UIColor *)navigationForgroundColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)navigationBackgroundColor
{
    return [UIColor HYPFormsCoreBlue];
}

+ (UIColor *)messageViewForeground
{
    return [UIColor whiteColor];
}

+ (UIColor *)messageViewBackground
{
    return [UIColor HYPFormsRed];
}

+ (UIColor *)HYPFormsShadowColor
{
    return [UIColor colorWithRed: 0.271 green: 0.361 blue: 0.451 alpha: 0.46];
}

@end
