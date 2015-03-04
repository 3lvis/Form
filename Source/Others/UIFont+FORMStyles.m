#import "UIFont+FORMStyles.h"

@implementation UIFont (FORMStyles)

+ (UIFont *)FORMLargeSize
{
    return [UIFont fontWithName:@"DIN-Medium" size:20.0];
}

+ (UIFont *)FORMLargeSizeBold
{
    return [UIFont fontWithName:@"DIN-Bold" size:20.0];
}

+ (UIFont *)FORMLargeSizeRegular
{
    return [UIFont fontWithName:@"DIN-Regular" size:20.0];
}

+ (UIFont *)FORMMediumSize
{
    return [UIFont fontWithName:@"DIN-Medium" size:17.0];
}

+ (UIFont *)FORMMediumSizeBolder
{
    return [UIFont fontWithName:@"DIN-Bold" size:17.0];
}

+ (UIFont *)FORMMediumSizeBold
{
    return [UIFont fontWithName:@"DIN-Medium" size:17.0];
}

+ (UIFont *)FORMMediumSizeLight
{
    return [UIFont fontWithName:@"DIN-Light" size:17.0];
}

+ (UIFont *)FORMSmallSizeBold
{
    return [UIFont fontWithName:@"DIN-Bold" size:14.0];
}

+ (UIFont *)FORMSmallSize
{
    return [UIFont fontWithName:@"DIN-Regular" size:14.0];
}

+ (UIFont *)FORMSmallSizeLight
{
    return [UIFont fontWithName:@"DIN-Light" size:14.0];
}

+ (UIFont *)FORMSmallSizeMedium
{
    return [UIFont fontWithName:@"DIN-Medium" size:14.0];
}

+ (UIFont *)FORMLabelFont
{
    return [UIFont fontWithName:@"DIN-Light" size:13.0];
}

+ (UIFont *)FORMTextFieldFont
{
    return [UIFont fontWithName:@"DIN-Regular" size:15.0];
}

+ (UIFont *)FORMActionButtonFont
{
    return [UIFont fontWithName:@"DIN-Bold" size:16.0];
}

@end
