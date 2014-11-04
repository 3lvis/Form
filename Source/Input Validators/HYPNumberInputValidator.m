//
//  HYPNumberInputValidator.m
//
//  Created by Christoffer Winterkvist on 9/23/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPNumberInputValidator.h"

@implementation HYPNumberInputValidator

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text withRange:(NSRange)range
{
    BOOL valid = [super validateReplacementString:string withText:text withRange:range];

    if (!valid) return valid;

    if (!string) {
        return (text.length > 0);
    }

    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    valid = [alphaNums isSupersetOfSet:stringSet];

    return valid;
}

@end
