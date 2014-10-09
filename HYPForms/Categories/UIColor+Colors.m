//
//  UIColor+Colors.m

//
//  Created by Christoffer Winterkvist on 05/05/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "UIColor+Colors.h"

#import "UIColor+ANDYHex.h"

@implementation UIColor (Colors)

#pragma mark - Color scheme

+ (UIColor *)HYPCoreBlue
{
    return [UIColor colorFromHex:@"28649C"];
}

+ (UIColor *)HYPDarkBlue
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)HYPCallToAction
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)HYPCallToActionPressed
{
    return [UIColor colorFromHex:@"008ED9"];
}

+ (UIColor *)HYPBackground
{
    return [UIColor colorFromHex:@"DAE2EA"];
}

+ (UIColor *)HYPLightGray
{
    return [UIColor colorFromHex:@"F5F5F8"];
}

+ (UIColor *)HYPDarkGray
{
    return [UIColor colorFromHex:@"979797"];
}

+ (UIColor *)HYPFieldForeground
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)HYPFieldForegroundActive
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)HYPFieldForegroundInvalid
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)HYPFieldForegroundDisabled
{
    return [UIColor colorFromHex:@"C6C6C6"];
}

+ (UIColor *)HYPFieldBackground
{
    return [UIColor colorFromHex:@"E1F5FF"];
}

+ (UIColor *)HYPFieldBackgroundActive
{
    return [UIColor colorFromHex:@"C0EAFF"];
}

+ (UIColor *)HYPFieldBackgroundInvalid
{
    return [UIColor colorFromHex:@"FFD7D7"];
}

+ (UIColor *)HYPFieldBackgroundDisabled
{
    return [UIColor colorFromHex:@"FFFFFF"];
}

+ (UIColor *)HYPFieldBorder
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)HYPFieldBorderActive
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)HYPFieldBorderInvalid
{
    return [UIColor colorFromHex:@"EC3031"];
}

+ (UIColor *)HYPFieldBorderDisabled
{
    return [UIColor colorFromHex:@"C6C6C6"];
}

+ (UIColor *)HYPBlue
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)HYPGreen
{
    return [UIColor colorFromHex:@"69C204"];
}

+ (UIColor *)HYPYellow
{
    return [UIColor colorFromHex:@"FEC22E"];
}

+ (UIColor *)HYPRed
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
    return [UIColor HYPDarkBlue];
}

+ (UIColor *)borderColor
{
    return [UIColor HYPBlue];
}

+ (UIColor *)windowBackgroundColor
{
    return [UIColor HYPBackground];
}

+ (UIColor *)navigationForgroundColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)navigationBackgroundColor
{
    return [UIColor HYPCoreBlue];
}

+ (UIColor *)messageViewForeground
{
    return [UIColor whiteColor];
}

+ (UIColor *)messageViewBackground
{
    return [UIColor HYPRed];
}

+ (UIColor *)HYPShadowColor
{
    return [UIColor colorWithRed: 0.271 green: 0.361 blue: 0.451 alpha: 0.46];
}

@end
