//
//  UIFont+Styles.m

//
//  Created by Christoffer Winterkvist on 5/12/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "UIFont+Styles.h"

@implementation UIFont (Styles)

+ (UIFont *)HYPLargeSize
{
    return [UIFont fontWithName:@"DIN-Medium" size:20.0];
}

+ (UIFont *)HYPLargeSizeBold
{
    return [UIFont fontWithName:@"DIN-Bold" size:20.0];
}

+ (UIFont *)HYPLargeSizeRegular
{
    return [UIFont fontWithName:@"DIN-Regular" size:20.0];
}

+ (UIFont *)HYPMediumSize
{
    return [UIFont fontWithName:@"DIN-Medium" size:17.0];
}

+ (UIFont *)HYPMediumSizeBolder
{
    return [UIFont fontWithName:@"DIN-Bold" size:17.0];
}

+ (UIFont *)HYPMediumSizeBold
{
    return [UIFont fontWithName:@"DIN-Medium" size:17.0];
}

+ (UIFont *)HYPMediumSizeLight
{
    return [UIFont fontWithName:@"DIN-Light" size:17.0];
}

+ (UIFont *)HYPSmallSizeBold
{
    return [UIFont fontWithName:@"DIN-Bold" size:14.0];
}

+ (UIFont *)HYPSmallSize
{
    return [UIFont fontWithName:@"DIN-Regular" size:14.0];
}

+ (UIFont *)HYPSmallSizeLight
{
    return [UIFont fontWithName:@"DIN-Light" size:14.0];
}

+ (UIFont *)HYPSmallSizeMedium
{
    return [UIFont fontWithName:@"DIN-Medium" size:14.0];
}

+ (UIFont *)HYPLabelFont
{
    return [UIFont fontWithName:@"DIN-Light" size:13.0];
}

+ (UIFont *)HYPTextFieldFont
{
    return [UIFont fontWithName:@"DIN-Regular" size:15.0];
}

@end
