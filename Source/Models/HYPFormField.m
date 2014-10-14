//
//  HYPFormField.m
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPForm.h"
#import "HYPFormField.h"
#import "HYPFormSection.h"
#import "HYPValidator.h"
#import "HYPFormatter.h"
#import "HYPInputValidator.h"
#import "HYPFieldValue.h"
#import "HYPClassFactory.h"

static NSString * const HYPFormFieldSelectType = @"select";
static NSString * const HYPInputValidatorSelector = @"validateString:text:";
static NSString * const HYPFormatterClass = @"HYP%@Formatter";
static NSString * const HYPFormatterSelector = @"formatString:reverse:";

@implementation HYPFormField

#pragma mark - Setters

- (void)setFieldValue:(id)fieldValue
{
    id resultValue = fieldValue;

    switch (self.type) {
        case HYPFormFieldTypeNumber:
        case HYPFormFieldTypeFloat:
            resultValue = [fieldValue stringValue];
            break;

        case HYPFormFieldTypeDate: {
            if ([fieldValue isKindOfClass:[NSString class]]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss' 'Z"];
                resultValue = [formatter dateFromString:fieldValue];
            }
        } break;

        default: break;
    }

    _fieldValue = resultValue;
}

#pragma mark - Getters

- (id)rawFieldValue
{
    if ([self.fieldValue isKindOfClass:[HYPFieldValue class]]) {
        return [self.fieldValue id];
    }

    switch (self.type) {
        case HYPFormFieldTypeFloat:
            return @([self.fieldValue floatValue]);
        case HYPFormFieldTypeNumber:
            return @([self.fieldValue integerValue]);

        case HYPFormFieldTypeDefault:
        case HYPFormFieldTypeSelect:
        case HYPFormFieldTypeDate:
        case HYPFormFieldTypePicture:
            return self.fieldValue;

        case HYPFormFieldTypeNone:
        case HYPFormFieldTypeBlank:
            return nil;
    }
}

- (id)inputValidator
{
    HYPInputValidator *inputValidator;
    Class fieldValidator = [HYPClassFactory classFromString:self.id withSuffix:@"InputValidator"];
    Class typeValidator = [HYPClassFactory classFromString:self.typeString withSuffix:@"InputValidator"];
    SEL selector = NSSelectorFromString(HYPInputValidatorSelector);

    if (fieldValidator && [fieldValidator instanceMethodForSelector:selector]) {
        inputValidator = [[fieldValidator alloc] init];
    } else if (typeValidator && [typeValidator instanceMethodForSelector:selector]) {
        inputValidator = [[typeValidator alloc] init];
    }

    if (inputValidator) {
        inputValidator.validations = self.validations;
    }

    return inputValidator;
}

- (id)formatter
{
    HYPFormatter *formatter;
    Class fieldFormatter = [HYPClassFactory classFromString:self.id withSuffix:@"Formatter"];
    Class typeFormatter = [HYPClassFactory classFromString:self.typeString withSuffix:@"Formatter"];
    SEL selector = NSSelectorFromString(HYPFormatterSelector);

    if (fieldFormatter && [fieldFormatter instanceMethodForSelector:selector]) {
        formatter = [[fieldFormatter alloc] init];
    } else if (typeFormatter && [typeFormatter instanceMethodForSelector:selector]) {
        formatter = [[typeFormatter alloc] init];
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
    } else if ([typeString isEqualToString:@"blank"]) {
        return HYPFormFieldTypeBlank;
    }

    return HYPFormFieldTypeDefault;
}

- (BOOL)isValid
{
    id validator;
    Class validatorClass;

    validatorClass = ([HYPClassFactory classFromString:self.id withSuffix:@"Validator"]) ?: [HYPValidator class];
    validator = [[validatorClass alloc] initWithValidations:self.validations];

    return [validator validateFieldValue:self.fieldValue];
}

#pragma mark - Public Methods

- (void)executeFormula
{
    NSLog(@"this is the formula: %@", self.formula);
}

@end
