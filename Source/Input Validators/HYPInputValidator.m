//
//  HYPInputValidator.m
//
//  Created by Christoffer Winterkvist on 22/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPInputValidator.h"
#import "HYPNumberInputValidator.h"

@implementation HYPInputValidator

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text withRange:(NSRange)range
{
    BOOL shouldSkipValidations = (text.length == 0 || string.length == 0 || !self.validations);
    if (shouldSkipValidations) return YES;

    NSUInteger textLength = [text length];

    if (string.length > 0) {
        textLength++;
    }

    BOOL valid = YES;

    if (self.validations[@"max_length"]) {
        valid = (textLength <= [self.validations[@"max_length"] unsignedIntegerValue]);
    }

    if (self.validations[@"max_value"]) {
        NSMutableString *newString = [[NSMutableString alloc] initWithString:text];
        [newString insertString:string atIndex:range.location];
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        NSNumber *newValue = [formatter numberFromString:newString];
        NSNumber *maxValue = self.validations[@"max_value"];

        BOOL eligibleForCompare = (newValue && maxValue);
        if (eligibleForCompare) valid = ([newValue floatValue] <= [maxValue floatValue]);
    }

    return valid;
}

- (BOOL)validateString:(NSString *)fieldValue withFormat:(NSString *)format
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.validations[@"format"] options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:fieldValue options:NSMatchingReportProgress range:NSMakeRange(0, fieldValue.length)];
    return (numberOfMatches > 0);
}

@end
