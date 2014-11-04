//
//  HYPNameInputValidator.m
//
//  Created by Christoffer Winterkvist on 10/1/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPNameInputValidator.h"

@implementation HYPNameInputValidator

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text withRange:(NSRange)range
{
    BOOL valid = [super validateReplacementString:string withText:text withRange:range];

    if (!valid) return valid;

    if (!string) {
        return (text.length > 0);
    }

    NSCharacterSet *letterCharacterSet = [NSCharacterSet letterCharacterSet];
    NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];

    BOOL allowsWordsAndWhitespaces = ([letterCharacterSet isSupersetOfSet:stringSet] ||
                                      [whitespaceCharacterSet isSupersetOfSet:stringSet]);
    if (allowsWordsAndWhitespaces) {
        return YES;
    }

    return NO;
}

@end
