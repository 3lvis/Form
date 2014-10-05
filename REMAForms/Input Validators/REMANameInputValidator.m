//
//  REMANameInputValidator.m
//
//  Created by Christoffer Winterkvist on 10/1/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMANameInputValidator.h"

@implementation REMANameInputValidator

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text
{
    BOOL valid = [super validateReplacementString:string withText:text];

    if (!valid) return valid;

    NSCharacterSet *letterCharacterSet = [NSCharacterSet letterCharacterSet];
    NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    
    if ([letterCharacterSet isSupersetOfSet:stringSet] || [whitespaceCharacterSet isSupersetOfSet:stringSet]) {
        return YES;
    }

    return NO;
}

@end
