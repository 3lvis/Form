//
//  UIColor+Colors.m

//
//  Created by Christoffer Winterkvist on 05/05/14.
//  Copyright (c) 2014 REMAer. All rights reserved.
//

#import "UIColor+REMAColors.h"

#import "UIColor+ANDYHex.h"

@implementation UIColor (REMAColors)

#pragma mark - Color scheme

+ (UIColor *)REMACoreBlue
{
    return [UIColor colorFromHex:@"28649C"];
}

+ (UIColor *)REMADarkBlue
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)REMACallToAction
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)REMACallToActionPressed
{
    return [UIColor colorFromHex:@"008ED9"];
}

+ (UIColor *)REMABackground
{
    return [UIColor colorFromHex:@"DAE2EA"];
}

+ (UIColor *)REMALightGray
{
    return [UIColor colorFromHex:@"F5F5F8"];
}

+ (UIColor *)REMADarkGray
{
    return [UIColor colorFromHex:@"979797"];
}

+ (UIColor *)REMAFieldForeground
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)REMAFieldForegroundActive
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)REMAFieldForegroundInvalid
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)REMAFieldForegroundDisabled
{
    return [UIColor colorFromHex:@"C6C6C6"];
}

+ (UIColor *)REMAFieldBackground
{
    return [UIColor colorFromHex:@"E1F5FF"];
}

+ (UIColor *)REMAFieldBackgroundActive
{
    return [UIColor colorFromHex:@"C0EAFF"];
}

+ (UIColor *)REMAFieldBackgroundInvalid
{
    return [UIColor colorFromHex:@"FFD7D7"];
}

+ (UIColor *)REMAFieldBackgroundDisabled
{
    return [UIColor colorFromHex:@"FFFFFF"];
}

+ (UIColor *)REMAFieldBorder
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)REMAFieldBorderActive
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)REMAFieldBorderInvalid
{
    return [UIColor colorFromHex:@"EC3031"];
}

+ (UIColor *)REMAFieldBorderDisabled
{
    return [UIColor colorFromHex:@"C6C6C6"];
}

+ (UIColor *)REMABlue
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)REMAGreen
{
    return [UIColor colorFromHex:@"69C204"];
}

+ (UIColor *)REMAYellow
{
    return [UIColor colorFromHex:@"FEC22E"];
}

+ (UIColor *)REMARed
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
    return [UIColor REMADarkBlue];
}

+ (UIColor *)borderColor
{
    return [UIColor REMABlue];
}

+ (UIColor *)windowBackgroundColor
{
    return [UIColor REMABackground];
}

+ (UIColor *)navigationForgroundColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)navigationBackgroundColor
{
    return [UIColor REMACoreBlue];
}

+ (UIColor *)messageViewForeground
{
    return [UIColor whiteColor];
}

+ (UIColor *)messageViewBackground
{
    return [UIColor REMARed];
}

+ (UIColor *)REMAShadowColor
{
    return [UIColor colorWithRed: 0.271 green: 0.361 blue: 0.451 alpha: 0.46];
}

@end
