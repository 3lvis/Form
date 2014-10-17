//
//  HYPInputValidator.m
//
//  Created by Christoffer Winterkvist on 22/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPInputValidator.h"
#import "HYPNumberInputValidator.h"

@implementation HYPInputValidator

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text
{
    if (!self.validations) return YES;

    NSUInteger textLength = [text length];

    if (string.length > 0) {
        textLength++;
    }

    BOOL valid = YES;

    if (self.validations[@"max_length"]) {
        valid = (textLength <= [self.validations[@"max_length"] unsignedIntegerValue]);
    }

    return valid;
}

- (BOOL)validateText:(NSString *)text
{
    return [self validateReplacementString:nil withText:text];
}

- (BOOL)validateString:(NSString *)fieldValue withFormat:(NSString *)format
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.validations[@"format"] options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:fieldValue options:NSMatchingReportProgress range:NSMakeRange(0, fieldValue.length)];
    return (numberOfMatches > 0);
}

@end
