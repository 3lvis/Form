//
//  UIFont+REMAStyles.m

//
//  Created by Christoffer Winterkvist on 5/12/14.
//  Copyright (c) 2014 REMAer. All rights reserved.
//

#import "UIFont+REMAStyles.h"

@implementation UIFont (REMAStyles)

+ (UIFont *)REMALargeSize
{
    return [UIFont fontWithName:@"DIN-Medium" size:20.0];
}

+ (UIFont *)REMALargeSizeBold
{
    return [UIFont fontWithName:@"DIN-Bold" size:20.0];
}

+ (UIFont *)REMALargeSizeRegular
{
    return [UIFont fontWithName:@"DIN-Regular" size:20.0];
}

+ (UIFont *)REMAMediumSize
{
    return [UIFont fontWithName:@"DIN-Medium" size:17.0];
}

+ (UIFont *)REMAMediumSizeBolder
{
    return [UIFont fontWithName:@"DIN-Bold" size:17.0];
}

+ (UIFont *)REMAMediumSizeBold
{
    return [UIFont fontWithName:@"DIN-Medium" size:17.0];
}

+ (UIFont *)REMAMediumSizeLight
{
    return [UIFont fontWithName:@"DIN-Light" size:17.0];
}

+ (UIFont *)REMASmallSizeBold
{
    return [UIFont fontWithName:@"DIN-Bold" size:14.0];
}

+ (UIFont *)REMASmallSize
{
    return [UIFont fontWithName:@"DIN-Regular" size:14.0];
}

+ (UIFont *)REMASmallSizeLight
{
    return [UIFont fontWithName:@"DIN-Light" size:14.0];
}

+ (UIFont *)REMASmallSizeMedium
{
    return [UIFont fontWithName:@"DIN-Medium" size:14.0];
}

+ (UIFont *)REMALabelFont
{
    return [UIFont fontWithName:@"DIN-Light" size:13.0];
}

+ (UIFont *)REMATextFieldFont
{
    return [UIFont fontWithName:@"DIN-Regular" size:15.0];
}

@end
