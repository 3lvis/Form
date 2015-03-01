#import "FORMGroup.h"
#import "FORMField.h"
#import "FORMSection.h"
#import "FORMValidator.h"
#import "FORMFormatter.h"
#import "FORMInputValidator.h"
#import "FORMFieldValue.h"
#import "FORMClassFactory.h"
#import "FORMTarget.h"

#import "NSDictionary+ANDYSafeValue.h"

static NSString * const FORMFieldSelectType = @"select";
static NSString * const FORMInputValidatorSelector = @"validateString:text:";
static NSString * const HYPFormatterSelector = @"formatString:reverse:";

@implementation FORMField

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          position:(NSInteger)position
                          disabled:(BOOL)disabled
                 disabledFieldsIDs:(NSArray *)disabledFieldsIDs
{
    self = [super init];
    if (!self) return nil;

    NSString *remoteID = [dictionary andy_valueForKey:@"id"];

    _valid = YES;
    _fieldID = remoteID;
    _validationType = FORMValidationResultTypeNone;
    _title = [dictionary andy_valueForKey:@"title"];
    _subtitle = [dictionary andy_valueForKey:@"subtitle"];
    _typeString  = [dictionary andy_valueForKey:@"type"];
    _type = [self typeFromTypeString:self.typeString];
    NSNumber *width = [dictionary andy_valueForKey:@"size.width"];
    NSNumber *height = [dictionary andy_valueForKey:@"size.height"];
    if (!height || !width) abort();

    _size = CGSizeMake([width floatValue], [height floatValue]);
    _position = @(position);
    _validations = [dictionary andy_valueForKey:@"validations"];
    _disabled = [[dictionary andy_valueForKey:@"disabled"] boolValue];
    _initiallyDisabled = _disabled;
    _formula = [dictionary andy_valueForKey:@"formula"];
    _maximumDate = [dictionary andy_valueForKey:@"maximum_date"];
    _minimumDate = [dictionary andy_valueForKey:@"minimum_date"];

    NSMutableArray *targets = [NSMutableArray new];

    for (NSDictionary *targetDict in [dictionary andy_valueForKey:@"targets"]) {
        FORMTarget *target = [[FORMTarget alloc] initWithDictionary:targetDict];
        [targets addObject:target];
    }

    _targets = targets;

    BOOL shouldDisable = (disabled || [disabledFieldsIDs containsObject:_fieldID]);

    if (shouldDisable) _disabled = YES;

    NSMutableArray *values = [NSMutableArray new];
    NSArray *dataSourceValues = [dictionary andy_valueForKey:@"values"];

    if (dataSourceValues) {
        for (NSDictionary *valueDict in dataSourceValues) {
            FORMFieldValue *fieldValue = [[FORMFieldValue alloc] initWithDictionary:valueDict];
            fieldValue.field = self;
            [values addObject:fieldValue];
        }
    }

    _values = values;

    return self;
}

#pragma mark - Setters

- (void)setFieldValue:(id)fieldValue
{
    id resultValue = fieldValue;

    switch (self.type) {
        case FORMFieldTypeNumber:
        case FORMFieldTypeFloat: {
            if (![fieldValue isKindOfClass:[NSString class]]) {
                resultValue = [fieldValue stringValue];
            }
        } break;

        case FORMFieldTypeDate: {
            if ([fieldValue isKindOfClass:[NSString class]]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss' 'Z"];
                resultValue = [formatter dateFromString:fieldValue];
            }
        } break;

        case FORMFieldTypeText:
        case FORMFieldTypeSelect:
        case FORMFieldTypeButton:
        case FORMFieldTypeCustom:
            break;
    }

    _fieldValue = resultValue;
}

#pragma mark - Getters

- (id)rawFieldValue
{
    if ([self.fieldValue isKindOfClass:[FORMFieldValue class]]) {
        return [self.fieldValue valueID];
    }

    switch (self.type) {
        case FORMFieldTypeFloat:
            if ([self.fieldValue isKindOfClass:[NSString class]]) {
                self.fieldValue = [self.fieldValue stringByReplacingOccurrencesOfString:@"," withString:@"."];
            }
            return @([self.fieldValue floatValue]);
        case FORMFieldTypeNumber:
            return @([self.fieldValue integerValue]);

        case FORMFieldTypeText:
        case FORMFieldTypeSelect:
        case FORMFieldTypeDate:
            return self.fieldValue;

        case FORMFieldTypeButton:
        case FORMFieldTypeCustom:
            return nil;
    }
}

- (id)inputValidator
{
    FORMInputValidator *inputValidator;
    Class fieldValidator = [FORMClassFactory classFromString:self.fieldID withSuffix:@"InputValidator"];
    Class typeValidator = [FORMClassFactory classFromString:self.typeString withSuffix:@"InputValidator"];
    SEL selector = NSSelectorFromString(FORMInputValidatorSelector);

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
    NSString *fieldClassName = self.fieldID;
    NSRange dotRange = [self.fieldID rangeOfString:@"."];
    if (dotRange.location != NSNotFound) {
        fieldClassName = [self.fieldID substringFromIndex:dotRange.location+1];
    }

    FORMFormatter *formatter;
    Class fieldFormatter = [FORMClassFactory classFromString:fieldClassName withSuffix:@"Formatter"];
    Class typeFormatter = [FORMClassFactory classFromString:self.typeString withSuffix:@"Formatter"];
    SEL selector = NSSelectorFromString(HYPFormatterSelector);

    if (fieldFormatter && [fieldFormatter instanceMethodForSelector:selector]) {
        formatter = [[fieldFormatter alloc] init];
    } else if (typeFormatter && [typeFormatter instanceMethodForSelector:selector]) {
        formatter = [[typeFormatter alloc] init];
    }

    return formatter;
}

- (FORMFieldType)typeFromTypeString:(NSString *)typeString
{
    if ([typeString isEqualToString:@"text"] ||
        [typeString isEqualToString:@"name"] ||
        [typeString isEqualToString:@"email"] ||
        [typeString isEqualToString:@"password"]) {
        return FORMFieldTypeText;
    } else if ([typeString isEqualToString:@"select"]) {
        return FORMFieldTypeSelect;
    } else if ([typeString isEqualToString:@"date"]) {
        return FORMFieldTypeDate;
    } else if ([typeString isEqualToString:@"float"]) {
        return FORMFieldTypeFloat;
    } else if ([typeString isEqualToString:@"number"]) {
        return FORMFieldTypeNumber;
    } else if ([typeString isEqualToString:@"button"]) {
        return FORMFieldTypeButton;
    } else {
        return FORMFieldTypeCustom;
    }
}

- (FORMFieldValue *)fieldValueWithID:(id)fieldValueID
{
    for (FORMFieldValue *fieldValue in self.values) {
        if ([fieldValue identifierIsEqualTo:self.fieldValue]) return fieldValue;
    }

    return nil;
}

- (FORMFieldValue *)selectFieldValueWithValueID:(id)fieldValueID
{
    for (FORMFieldValue *fieldValue in self.values) {
        if ([fieldValue identifierIsEqualTo:fieldValueID]) {
            self.fieldValue = fieldValue;
            return self.fieldValue;
        }
    }

    return nil;
}

- (FORMValidationResultType)validate
{
    id validator;
    Class validatorClass;

    validatorClass = ([FORMClassFactory classFromString:self.fieldID withSuffix:@"Validator"]) ?: [FORMValidator class];
    validator = [[validatorClass alloc] initWithValidations:self.validations];

    self.validationType = [validator validateFieldValue:self.fieldValue];
    self.valid = (self.validationType == FORMValidationResultTypePassed);

    return self.validationType;
}

#pragma mark - Public Methods

+ (FORMField *)fieldAtIndexPath:(NSIndexPath *)indexPath inSection:(FORMSection *)section
{
    FORMField *field = section.fields[indexPath.row];

    return field;
}

- (NSUInteger)indexInSectionUsingForms:(NSArray *)forms
{
    FORMGroup *form = forms[[self.section.form.position integerValue]];
    FORMSection *section = form.sections[[self.section.position integerValue]];

    NSUInteger index = 0;
    BOOL found = NO;
    NSUInteger fieldIndex = 0;

    for (FORMField *aField in section.fields) {
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
    if (self.type == FORMFieldTypeSelect) {
        if ([self.fieldValue isKindOfClass:[FORMFieldValue class]]) {
            if ([self.fieldValue targets].count > 0) return [self.fieldValue targets];
        } else {
            FORMFieldValue *fieldValue = [self fieldValueWithID:self.fieldValue];
            if (fieldValue.targets.count > 0) return fieldValue.targets;
        }
    } else {
        if (self.targets.count > 0) return self.targets;
    }

    return nil;
}

- (NSNumber *)sectionPosition
{
    if (self.section) {
        return self.section.position;
    } else {
        return nil;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n — Field: %@ —\n title: %@\n subtitle: %@\n size: %@\n position: %@\n fieldValue: %@\n type: %@\n values: %@\n disabled: %@\n initiallyDisabled: %@\n minimumDate: %@\n maximumDate: %@\n validations: %@\n formula: %@\n valid: %@\n sectionSeparator: %@\n",
            self.fieldID, self.title, self.subtitle, NSStringFromCGSize(self.size), self.position,
            self.fieldValue, self.typeString, self.values, (self.disabled) ? @"YES" : @"NO", (self.initiallyDisabled) ? @"YES" : @"NO", self.minimumDate,
            self.maximumDate, self.validations, self.formula, (self.valid) ? @"YES" : @"NO", (self.sectionSeparator) ? @"YES" : @"NO"];
}

@end
