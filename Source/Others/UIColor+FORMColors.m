#import "UIColor+FORMColors.h"

#import "UIColor+Hex.h"

@implementation UIColor (FORMColors)

#pragma mark - Color scheme

+ (UIColor *)FORMCoreBlue
{
    return [UIColor colorFromHex:@"28649C"];
}

+ (UIColor *)FORMDarkBlue
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)FORMCallToAction
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)FORMCallToActionPressed
{
    return [UIColor colorFromHex:@"008ED9"];
}

+ (UIColor *)FORMBackground
{
    return [UIColor colorFromHex:@"DAE2EA"];
}

+ (UIColor *)FORMLightGray
{
    return [UIColor colorFromHex:@"F5F5F8"];
}

+ (UIColor *)FORMDarkGray
{
    return [UIColor colorFromHex:@"979797"];
}

+ (UIColor *)FORMControlsBlue
{
    return [UIColor colorFromHex:@"5182AF"];
}

+ (UIColor *)FORMFieldForeground
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)FORMFieldForegroundActive
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)FORMFieldForegroundInvalid
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)FORMFieldForegroundDisabled
{
    return [UIColor colorFromHex:@"C6C6C6"];
}

+ (UIColor *)FORMFieldBackground
{
    return [UIColor colorFromHex:@"E1F5FF"];
}

+ (UIColor *)FORMFieldBackgroundActive
{
    return [UIColor colorFromHex:@"C0EAFF"];
}

+ (UIColor *)FORMFieldBackgroundInvalid
{
    return [UIColor colorFromHex:@"FFD7D7"];
}

+ (UIColor *)FORMFieldBackgroundDisabled
{
    return [UIColor colorFromHex:@"FFFFFF"];
}

+ (UIColor *)FORMFieldDisabledText
{
    return [UIColor colorFromHex:@"DEDEDE"];
}

+ (UIColor *)FORMFieldBorder
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)FORMFieldBorderActive
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)FORMFieldBorderInvalid
{
    return [UIColor colorFromHex:@"EC3031"];
}

+ (UIColor *)FORMFieldBorderDisabled
{
    return [UIColor colorFromHex:@"C6C6C6"];
}

+ (UIColor *)FORMBlue
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)FORMGreen
{
    return [UIColor colorFromHex:@"69C204"];
}

+ (UIColor *)FORMYellow
{
    return [UIColor colorFromHex:@"FEC22E"];
}

+ (UIColor *)FORMRed
{
    return [UIColor colorFromHex:@"EC3031"];
}

+ (UIColor *)FORMBrown
{
    return [UIColor colorFromHex:@"97591D"];
}

#pragma mark - Interface

+ (UIColor *)tableCellBackground
{
    return [UIColor windowBackgroundColor];
}

+ (UIColor *)tableCellBorder
{
    return [UIColor FORMDarkBlue];
}

+ (UIColor *)borderColor
{
    return [UIColor FORMBlue];
}

+ (UIColor *)windowBackgroundColor
{
    return [UIColor FORMBackground];
}

+ (UIColor *)navigationForgroundColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)navigationBackgroundColor
{
    return [UIColor FORMCoreBlue];
}

+ (UIColor *)messageViewForeground
{
    return [UIColor whiteColor];
}

+ (UIColor *)messageViewBackground
{
    return [UIColor FORMRed];
}

+ (UIColor *)FORMShadowColor
{
    return [UIColor colorWithRed: 0.271 green: 0.361 blue: 0.451 alpha: 0.46];
}

@end
