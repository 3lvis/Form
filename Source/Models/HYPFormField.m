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

#import "NSString+HYPWordExtractor.h"

static NSString * const HYPFormFieldSelectType = @"select";
static NSString * const HYPInputValidatorSelector = @"validateString:text:";
static NSString * const HYPFormatterClass = @"HYP%@Formatter";
static NSString * const HYPFormatterSelector = @"formatString:reverse:";

@implementation HYPFormField

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    _valid = YES;

    return self;
}

#pragma mark - Setters

- (void)setFieldValue:(id)fieldValue
{
    id resultValue = fieldValue;

    switch (self.type) {
        case HYPFormFieldTypeNumber:
        case HYPFormFieldTypeFloat:
            if (![fieldValue isKindOfClass:[NSString class]]) {
                resultValue = [fieldValue stringValue];
            }
            break;

        case HYPFormFieldTypeDate: {
            if ([fieldValue isKindOfClass:[NSString class]]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss' 'Z"];
                resultValue = [formatter dateFromString:fieldValue];
            }
        } break;

        case HYPFormFieldTypeDefault:
        case HYPFormFieldTypeNone:
        case HYPFormFieldTypeBlank:
        case HYPFormFieldTypeSelect:
        case HYPFormFieldTypePicture:
        case HYPFormFieldTypeImage:
            break;
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
            if ([self.fieldValue isKindOfClass:[NSString class]]) {
                self.fieldValue = [self.fieldValue stringByReplacingOccurrencesOfString:@"," withString:@"."];
            }
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
        case HYPFormFieldTypeImage:
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
    } else if ([typeString isEqualToString:@"image"]) {
        return HYPFormFieldTypeImage;
    }

    return HYPFormFieldTypeDefault;
}

- (HYPFieldValue *)fieldValueWithID:(id)fieldValueID
{
    for (HYPFieldValue *fieldValue in self.values) {
        if ([fieldValue identifierIsEqualTo:self.fieldValue]) {
            return fieldValue;
        }
    }

    return nil;
}

- (BOOL)validate
{
    id validator;
    Class validatorClass;

    validatorClass = ([HYPClassFactory classFromString:self.id withSuffix:@"Validator"]) ?: [HYPValidator class];
    validator = [[validatorClass alloc] initWithValidations:self.validations];

    self.valid = [validator validateFieldValue:self.fieldValue];

    return self.valid;
}

#pragma mark - Public Methods

+ (HYPFormField *)fieldWithID:(NSString *)id inForms:(NSArray *)forms withIndexPath:(BOOL)withIndexPath
{
    __block BOOL found = NO;
    __block HYPFormField *foundField = nil;

    [forms enumerateObjectsUsingBlock:^(HYPForm *form, NSUInteger formIndex, BOOL *formStop) {
        if (found) {
            *formStop = YES;
        }

        [form.fields enumerateObjectsUsingBlock:^(HYPFormField *field, NSUInteger fieldIndex, BOOL *fieldStop) {
            if ([field.id isEqualToString:id]) {
                if (withIndexPath) {
                    field.indexPath = [NSIndexPath indexPathForRow:fieldIndex inSection:formIndex];
                }
                foundField = field;

                found = YES;
                *fieldStop = YES;
            }
        }];
    }];

    return foundField;
}

- (NSInteger)indexInForms:(NSArray *)forms
{
    HYPForm *form = forms[[self.section.form.position integerValue]];

    __block NSInteger index = 0;

    [form.sections enumerateObjectsUsingBlock:^(HYPFormSection *aSection, NSUInteger sectionIndex, BOOL *sectionStop) {
        [aSection.fields enumerateObjectsUsingBlock:^(HYPFormField *aField, NSUInteger fieldIndex, BOOL *fieldStop) {
            if ([aField.position integerValue] >= [self.position integerValue]) {
                index = fieldIndex;
                *fieldStop = YES;
            }
        }];
    }];

    return index;
}

- (NSMutableDictionary *)valuesForFormulaInForms:(NSArray *)forms
{
    NSMutableDictionary *values = [NSMutableDictionary dictionary];

    NSArray *fieldIDs = [self.formula hyp_variables];

    for (NSString *fieldID in fieldIDs) {
        HYPFormField *targetField = [HYPFormField fieldWithID:fieldID inForms:forms withIndexPath:NO];
        id value = targetField.fieldValue;
        if (value) {
            if (targetField.type == HYPFormFieldTypeSelect) {
                HYPFieldValue *fieldValue = targetField.fieldValue;
                if (fieldValue.value) {
                    [values addEntriesFromDictionary:@{fieldID : fieldValue.value}];
                }
            } else {
                if ([value isKindOfClass:[NSString class]] && [value length] > 0) {
                    [values addEntriesFromDictionary:@{fieldID : value}];
                } else {
                    if ([value respondsToSelector:NSSelectorFromString(@"stringValue")]) {
                        [values addEntriesFromDictionary:@{fieldID : [value stringValue]}];
                    } else {
                        [values addEntriesFromDictionary:@{fieldID : @""}];
                    }
                }
            }
        }
    }

    return values;
}

- (NSArray *)safeTargets
{
    if (self.type == HYPFormFieldTypeSelect) {
        if ([self.fieldValue isKindOfClass:[HYPFieldValue class]]) {
            HYPFieldValue *fieldValue = self.fieldValue;
            if (fieldValue.targets.count > 0) return fieldValue.targets;
        } else {
            HYPFieldValue *fieldValue = [self fieldValueWithID:self.fieldValue];
            if (fieldValue.targets.count > 0) return fieldValue.targets;
        }
    } else {
        if (self.targets.count > 0) return self.targets;
    }

    return nil;
}

@end
