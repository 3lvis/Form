//
//  HYPFormatter.m
//
//  Created by Christoffer Winterkvist on 9/23/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFormatter.h"
#import "NSString+ZENInflections.h"

static NSString * const HYPFormatterClass = @"HYP%@Formatter";
static NSString * const HYPFormatterSelector = @"formatString:reverse:";

@implementation HYPFormatter

+ (Class)formatterClass:(NSString *)string
{
    NSString *classString = [NSString stringWithFormat:HYPFormatterClass, [string zen_upperCamelCase]];

    return NSClassFromString(classString);
}

- (NSString *)formatString:(NSString *)string reverse:(BOOL)reverse
{
    if (!string) {
        return @"";
    }

    return string;
}

@end
