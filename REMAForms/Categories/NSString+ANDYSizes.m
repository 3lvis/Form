//
//  NSString+ANDYSizes.m
//
//  Created by Elvis Nunez on 4/24/14.
//  Copyright (c) 2014 Elvis Nunez. All rights reserved.
//

#import "NSString+ANDYSizes.h"

@implementation NSString (ANDYSizes)

+ (CGFloat)heightForString:(NSString *)string width:(CGFloat)width font:(UIFont *)font
{
    NSDictionary *attributes = @{ NSFontAttributeName : font };
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];
    return CGRectGetHeight(rect);
}

+ (CGFloat)heightForString:(NSString *)string font:(UIFont *)font
{
    NSDictionary *attributes = @{ NSFontAttributeName : font };
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];
    return CGRectGetHeight(rect);
}

+ (CGFloat)widthForString:(NSString *)string font:(UIFont *)font
{
    NSDictionary *attributes = @{ NSFontAttributeName : font };
    CGSize size = [string sizeWithAttributes:attributes];
    return size.width;
}

@end
