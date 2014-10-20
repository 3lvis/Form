//
//  HYPFloatFormatter.m
//  HYPForms
//
//  Created by Christoffer Winterkvist on 10/20/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFloatFormatter.h"

@implementation HYPFloatFormatter

- (NSString *)formatString:(NSString *)string reverse:(BOOL)reverse
{
    string = [super formatString:string reverse:reverse];
    if (!string) return nil;

    if (reverse) {
        return [string stringByReplacingOccurrencesOfString:@"," withString:@"."];
    } else {
        return [string stringByReplacingOccurrencesOfString:@"." withString:@","];
    }
}

@end
