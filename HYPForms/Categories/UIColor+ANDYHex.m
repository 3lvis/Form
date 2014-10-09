//
//  UIColor+ANDYHex.m
//
//  Copyright (c) 2014 Elvis Nuñez. All rights reserved.
//

#import "UIColor+ANDYHex.h"

@implementation UIColor (ANDYHex)

+ (UIColor *)colorFromHex:(NSString *)hexString
{
    NSString *noHashString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]];

    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;

    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

@end
