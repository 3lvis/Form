//
//  REMAFormField.m
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFieldset.h"
#import "REMAFormField.h"
#import "REMAFormSection.h"
#import "REMAValidator.h"
#import "REMAFormatter.h"
#import "REMAInputValidator.h"

static NSString * const REMAFormFieldSelectType = @"select";
static NSString * const REMAInputValidatorSelector = @"validateString:text:";
static NSString * const REMAFormatterClass = @"REMA%@Formatter";
static NSString * const REMAFormatterSelector = @"formatString:reverse:";

@implementation REMAFormField

#pragma mark - Getters

- (id)rawFieldValue
{
    switch (self.type) {
        case REMAFormFieldTypeFloat:
            return @([self.fieldValue floatValue]);
        case REMAFormFieldTypeNumber:
            return @([self.fieldValue integerValue]);

        case REMAFormFieldTypeDefault:
        case REMAFormFieldTypeNone:
        case REMAFormFieldTypeSelect:
        case REMAFormFieldTypeDate:
        case REMAFormFieldTypePicture:
            return self.fieldValue;
    }
}

- (id)validator
{
    REMAInputValidator *validator;
    Class fieldValidator = [REMAInputValidator validatorClass:self.id];
    Class typeValidator = [REMAInputValidator validatorClass:self.typeString];
    SEL selector = NSSelectorFromString(REMAInputValidatorSelector);

    if (fieldValidator && [fieldValidator instanceMethodForSelector:selector]) {
        validator = [[fieldValidator alloc] init];
    } else if (typeValidator && [typeValidator instanceMethodForSelector:selector]) {
        validator = [[typeValidator alloc] init];
    }

    if (validator) {
        validator.validations = self.validations;
    }

    return validator;
}

- (id)formatter
{
    REMAFormatter *formatter = nil;

    Class formatterClass = [REMAFormatter formatterClass:self.typeString];
    SEL selector = NSSelectorFromString(REMAFormatterSelector);

    if (formatterClass && [formatterClass instanceMethodForSelector:selector]) {
        formatter = [[formatterClass alloc] init];
    }

    return formatter;
}

+ (REMAFormField *)fieldAtIndexPath:(NSIndexPath *)indexPath inSection:(REMAFormSection *)section
{
    REMAFormField *field = section.fields[indexPath.row];

    return field;
}

- (REMAFormFieldType)typeFromTypeString:(NSString *)typeString
{
    if ([typeString isEqualToString:@"picture"]) {
        return REMAFormFieldTypePicture;
    } else if ([typeString isEqualToString:@"select"]) {
        return REMAFormFieldTypeSelect;
    } else if ([typeString isEqualToString:@"date"]) {
        return REMAFormFieldTypeDate;
    } else if ([typeString isEqualToString:@"float"]) {
        return REMAFormFieldTypeFloat;
    } else if ([typeString isEqualToString:@"number"]) {
        return REMAFormFieldTypeNumber;
    }

    return REMAFormFieldTypeDefault;
}

- (BOOL)isValid
{
    REMAValidator *validator = [[REMAValidator alloc] initWithValidations:self.validations];
    return [validator validateFieldValue:self.fieldValue];
}

@end
