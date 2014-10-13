//
//  HYPValidator.m
//
//  Created by Christoffer Winterkvist on 9/24/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPValidator.h"

@interface HYPValidator ()

@property (nonatomic, strong) NSDictionary *validations;

@end

@implementation HYPValidator

- (instancetype)initWithValidations:(NSDictionary *)validations
{
    self = [super init];
    if (!self) return nil;

    self.validations = validations;

    return self;
}

- (BOOL)validateFieldValue:(id)fieldValue
{
    if (!self.validations) return YES;

    BOOL valid = (self.validations[@"required"] != nil);

    if ([fieldValue isKindOfClass:[NSString class]]) {
        if (valid && self.validations[@"min_length"]) {
            valid = ([fieldValue length] >= (NSUInteger)[self.validations[@"min_length"] unsignedIntegerValue]);
        }

        if (valid && self.validations[@"max_length"]) {
            valid = ([fieldValue length] <= [self.validations[@"max_length"] unsignedIntegerValue]);
        }

        if (valid && self.validations[@"format"]) {
            valid = [self validateString:fieldValue ? : @""
                              withFormat:self.validations[@"format"]];
        }
    }

    if (valid && self.validations[@"required"]) {
        if ([fieldValue isKindOfClass:[NSString class]]) {
            valid = ([fieldValue length] > 0);
        } else if (!fieldValue) {
            valid = NO;
        }
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
