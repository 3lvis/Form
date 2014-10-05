//
//  REMAFormatter.m
//
//  Created by Christoffer Winterkvist on 9/23/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFormatter.h"
#import "NSString+ZENInflections.h"

static NSString * const REMAFormatterClass = @"REMA%@Formatter";
static NSString * const REMAFormatterSelector = @"formatString:reverse:";

@implementation REMAFormatter

+ (Class)formatterClass:(NSString *)string
{
    NSString *classString = [NSString stringWithFormat:REMAFormatterClass, [string zen_upperCamelCase]];

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
