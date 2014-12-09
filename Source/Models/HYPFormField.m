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
        case HYPFormFieldTypeFloat: {
            if (![fieldValue isKindOfClass:[NSString class]]) {
                resultValue = [fieldValue stringValue];
            }
        } break;

        case HYPFormFieldTypeDate: {
            if ([fieldValue isKindOfClass:[NSString class]]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss' 'Z"];
                resultValue = [formatter dateFromString:fieldValue];
            }
        } break;

        case HYPFormFieldTypeText:
        case HYPFormFieldTypeSelect:
        case HYPFormFieldTypeCustom:
            break;
    }

    _fieldValue = resultValue;
}

#pragma mark - Getters

- (id)rawFieldValue
{
    if ([self.fieldValue isKindOfClass:[HYPFieldValue class]]) {
        return [self.fieldValue valueID];
    }

    switch (self.type) {
        case HYPFormFieldTypeFloat:
            if ([self.fieldValue isKindOfClass:[NSString class]]) {
                self.fieldValue = [self.fieldValue stringByReplacingOccurrencesOfString:@"," withString:@"."];
            }
            return @([self.fieldValue floatValue]);
        case HYPFormFieldTypeNumber:
            return @([self.fieldValue integerValue]);

        case HYPFormFieldTypeText:
        case HYPFormFieldTypeSelect:
        case HYPFormFieldTypeDate:
            return self.fieldValue;

        case HYPFormFieldTypeCustom:
            return nil;
    }
}

- (id)inputValidator
{
    HYPInputValidator *inputValidator;
    Class fieldValidator = [HYPClassFactory classFromString:self.fieldID withSuffix:@"InputValidator"];
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
    Class fieldFormatter = [HYPClassFactory classFromString:self.fieldID withSuffix:@"Formatter"];
    Class typeFormatter = [HYPClassFactory classFromString:self.typeString withSuffix:@"Formatter"];
    SEL selector = NSSelectorFromString(HYPFormatterSelector);

    if (fieldFormatter && [fieldFormatter instanceMethodForSelector:selector]) {
        formatter = [[fieldFormatter alloc] init];
    } else if (typeFormatter && [typeFormatter instanceMethodForSelector:selector]) {
        formatter = [[typeFormatter alloc] init];
    }

    return formatter;
}

- (HYPFormFieldType)typeFromTypeString:(NSString *)typeString
{
    if ([typeString isEqualToString:@"text"] ||
        [typeString isEqualToString:@"name"] ||
        [typeString isEqualToString:@"email"]) {
        return HYPFormFieldTypeText;
    } else if ([typeString isEqualToString:@"select"]) {
        return HYPFormFieldTypeSelect;
    } else if ([typeString isEqualToString:@"date"]) {
        return HYPFormFieldTypeDate;
    } else if ([typeString isEqualToString:@"float"]) {
        return HYPFormFieldTypeFloat;
    } else if ([typeString isEqualToString:@"number"]) {
        return HYPFormFieldTypeNumber;
    } else {
        return HYPFormFieldTypeCustom;
    }
}

- (HYPFieldValue *)fieldValueWithID:(id)fieldValueID
{
    for (HYPFieldValue *fieldValue in self.values) {
        if ([fieldValue identifierIsEqualTo:self.fieldValue]) return fieldValue;
    }

    return nil;
}

- (BOOL)validate
{
    id validator;
    Class validatorClass;

    validatorClass = ([HYPClassFactory classFromString:self.fieldID withSuffix:@"Validator"]) ?: [HYPValidator class];
    validator = [[validatorClass alloc] initWithValidations:self.validations];

    self.valid = [validator validateFieldValue:self.fieldValue];

    return self.valid;
}

#pragma mark - Public Methods

+ (HYPFormField *)fieldAtIndexPath:(NSIndexPath *)indexPath inSection:(HYPFormSection *)section
{
    HYPFormField *field = section.fields[indexPath.row];

    return field;
}

- (NSUInteger)indexInSectionUsingForms:(NSArray *)forms
{
    HYPForm *form = forms[[self.section.form.position integerValue]];
    HYPFormSection *section = form.sections[[self.section.position integerValue]];

    NSUInteger index = 0;
    BOOL found = NO;
    NSUInteger fieldIndex = 0;

    for (HYPFormField *aField in section.fields) {
        if ([aField.position integerValue] >= [self.position integerValue]) {
            index = fieldIndex;
            found = YES;
            break;
        }

        fieldIndex++;
    }

    if (!found) index = [section.fields count];

    return index;
}

- (NSArray *)safeTargets
{
    if (self.type == HYPFormFieldTypeSelect) {
        if ([self.fieldValue isKindOfClass:[HYPFieldValue class]]) {
            if ([self.fieldValue targets].count > 0) return [self.fieldValue targets];
        } else {
            HYPFieldValue *fieldValue = [self fieldValueWithID:self.fieldValue];
            if (fieldValue.targets.count > 0) return fieldValue.targets;
        }
    } else {
        if (self.targets.count > 0) return self.targets;
    }

    return nil;
}

- (void)sectionAndIndexInForms:(NSArray *)forms
                    completion:(void (^)(BOOL found, HYPFormSection *section, NSInteger index))completion
{

    HYPFormSection *section = [HYPFormSection sectionWithID:self.section.sectionID inForms:forms];

    __block NSInteger index = 0;
    __block BOOL found = NO;

    NSUInteger idx = 0;
    for (HYPFormField *aField in section.fields) {
        if ([aField.fieldID isEqualToString:self.fieldID]) {
            index = idx;
            found = YES;
            break;
        }

        idx++;
    }

    if (completion) completion(found, section, index);
}

@end
