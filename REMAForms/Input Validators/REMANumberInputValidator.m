//
//  REMANumberInputValidator.m
//  Mine Ansatte
//
//  Created by Christoffer Winterkvist on 9/23/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMANumberInputValidator.h"

@implementation REMANumberInputValidator

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text
{
    BOOL valid = [super validateReplacementString:string withText:text];

    if (!valid) return valid;

    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    valid = [alphaNums isSupersetOfSet:stringSet];

    return valid;
}

@end
