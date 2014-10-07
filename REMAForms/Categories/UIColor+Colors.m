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

+ (UIColor *)remaCoreBlue
{
    return [UIColor colorFromHex:@"28649C"];
}

+ (UIColor *)remaDarkBlue
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)remaCallToAction
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)remaCallToActionPressed
{
    return [UIColor colorFromHex:@"008ED9"];
}

+ (UIColor *)remaBackground
{
    return [UIColor colorFromHex:@"DAE2EA"];
}

+ (UIColor *)remaLightGray
{
    return [UIColor colorFromHex:@"F5F5F8"];
}

+ (UIColor *)remaDarkGray
{
    return [UIColor colorFromHex:@"979797"];
}

+ (UIColor *)remaFieldForeground
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)remaFieldForegroundActive
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)remaFieldForegroundInvalid
{
    return [UIColor colorFromHex:@"455C73"];
}

+ (UIColor *)remaFieldForegroundDisabled
{
    return [UIColor colorFromHex:@"C6C6C6"];
}

+ (UIColor *)remaFieldBackground
{
    return [UIColor colorFromHex:@"E1F5FF"];
}

+ (UIColor *)remaFieldBackgroundActive
{
    return [UIColor colorFromHex:@"C0EAFF"];
}

+ (UIColor *)remaFieldBackgroundInvalid
{
    return [UIColor colorFromHex:@"FFD7D7"];
}

+ (UIColor *)remaFieldBackgroundDisabled
{
    return [UIColor colorFromHex:@"FFFFFF"];
}

+ (UIColor *)remaFieldBorder
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)remaFieldBorderActive
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)remaFieldBorderInvalid
{
    return [UIColor colorFromHex:@"EC3031"];
}

+ (UIColor *)remaFieldBorderDisabled
{
    return [UIColor colorFromHex:@"C6C6C6"];
}

+ (UIColor *)remaBlue
{
    return [UIColor colorFromHex:@"3DAFEB"];
}

+ (UIColor *)remaGreen
{
    return [UIColor colorFromHex:@"69C204"];
}

+ (UIColor *)remaYellow
{
    return [UIColor colorFromHex:@"FEC22E"];
}

+ (UIColor *)remaRed
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
    return [UIColor remaDarkBlue];
}

+ (UIColor *)borderColor
{
    return [UIColor remaBlue];
}

+ (UIColor *)windowBackgroundColor
{
    return [UIColor remaBackground];
}

+ (UIColor *)navigationForgroundColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)navigationBackgroundColor
{
    return [UIColor remaCoreBlue];
}

+ (UIColor *)messageViewForeground
{
    return [UIColor whiteColor];
}

+ (UIColor *)messageViewBackground
{
    return [UIColor remaRed];
}

+ (UIColor *)remaShadowColor
{
    return [UIColor colorWithRed: 0.271 green: 0.361 blue: 0.451 alpha: 0.46];
}

@end
