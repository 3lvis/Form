//
//  REMAFloatInputValidator.m
//
//  Created by Christoffer Winterkvist on 10/1/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFloatInputValidator.h"

@implementation REMAFloatInputValidator

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text
{
    BOOL valid = [super validateReplacementString:string withText:text];

    if (!valid) return valid;

    BOOL hasComa = ([text rangeOfString:@","].location != NSNotFound);
    BOOL stringIsNilOrComma = (!string || [string isEqualToString:@","]);

    if (hasComa && stringIsNilOrComma) return NO;

    NSCharacterSet *floatSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890,"];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];

    return [floatSet isSupersetOfSet:stringSet];
}

@end
