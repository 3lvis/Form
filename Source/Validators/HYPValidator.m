//
//  HYPValidator.m
//
//  Created by Christoffer Winterkvist on 9/24/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPValidator.h"
#import "HYPFieldValue.h"

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

    BOOL valid = YES;
    BOOL required = (self.validations[@"required"] != nil);
    NSUInteger minimumLength = 0;

    if (!fieldValue && !required) return YES;

    if ([fieldValue isKindOfClass:[HYPFieldValue class]]) {
        return YES;
    }

    minimumLength = [self.validations[@"min_length"] integerValue];

    if (minimumLength == 0 && required) {
        minimumLength = 1;
    }

    if (minimumLength > 0) {
        if ([fieldValue respondsToSelector:@selector(stringValue)]) {
            valid = ([[fieldValue stringValue] length] >= minimumLength);
        } else {
            valid = ([fieldValue length] >= minimumLength);
        }
    }

    if (valid && self.validations[@"max_length"]) {
        valid = ([fieldValue length] <= [self.validations[@"max_length"] unsignedIntegerValue]);
    }

    if (valid && self.validations[@"format"]) {
        valid = [self validateString:fieldValue
                          withFormat:self.validations[@"format"]];
    }

    return valid;
}

- (BOOL)validateString:(NSString *)fieldValue withFormat:(NSString *)format
{
    if (!fieldValue) return YES;

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.validations[@"format"] options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:fieldValue options:NSMatchingReportProgress range:NSMakeRange(0, fieldValue.length)];
    return (numberOfMatches > 0);
}

@end
