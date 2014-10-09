//
//  HYPFormField.m
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFieldset.h"
#import "HYPFormField.h"
#import "HYPFormSection.h"
#import "HYPValidator.h"
#import "HYPFormatter.h"
#import "HYPInputValidator.h"

static NSString * const HYPFormFieldSelectType = @"select";
static NSString * const HYPInputValidatorSelector = @"validateString:text:";
static NSString * const HYPFormatterClass = @"HYP%@Formatter";
static NSString * const HYPFormatterSelector = @"formatString:reverse:";

@implementation HYPFormField

#pragma mark - Getters

- (id)rawFieldValue
{
    switch (self.type) {
        case HYPFormFieldTypeFloat:
            return @([self.fieldValue floatValue]);
        case HYPFormFieldTypeNumber:
            return @([self.fieldValue integerValue]);

        case HYPFormFieldTypeDefault:
        case HYPFormFieldTypeNone:
        case HYPFormFieldTypeSelect:
        case HYPFormFieldTypeDate:
        case HYPFormFieldTypePicture:
            return self.fieldValue;
    }
}

- (id)validator
{
    HYPInputValidator *validator;
    Class fieldValidator = [HYPInputValidator validatorClass:self.id];
    Class typeValidator = [HYPInputValidator validatorClass:self.typeString];
    SEL selector = NSSelectorFromString(HYPInputValidatorSelector);

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
    HYPFormatter *formatter = nil;

    Class formatterClass = [HYPFormatter formatterClass:self.typeString];
    SEL selector = NSSelectorFromString(HYPFormatterSelector);

    if (formatterClass && [formatterClass instanceMethodForSelector:selector]) {
        formatter = [[formatterClass alloc] init];
    }

    return formatter;
}

+ (HYPFormField *)fieldAtIndexPath:(NSIndexPath *)indexPath inSection:(HYPFormSection *)section
{
    HYPFormField *field = section.fields[indexPath.row];

    return field;
}

- (HYPFormFieldType)typeFromTypeString:(NSString *)typeString
{
    if ([typeString isEqualToString:@"picture"]) {
        return HYPFormFieldTypePicture;
    } else if ([typeString isEqualToString:@"select"]) {
        return HYPFormFieldTypeSelect;
    } else if ([typeString isEqualToString:@"date"]) {
        return HYPFormFieldTypeDate;
    } else if ([typeString isEqualToString:@"float"]) {
        return HYPFormFieldTypeFloat;
    } else if ([typeString isEqualToString:@"number"]) {
        return HYPFormFieldTypeNumber;
    }

    return HYPFormFieldTypeDefault;
}

- (BOOL)isValid
{
    HYPValidator *validator = [[HYPValidator alloc] initWithValidations:self.validations];
    return [validator validateFieldValue:self.fieldValue];
}

@end
