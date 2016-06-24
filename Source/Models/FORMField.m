#import "FORMGroup.h"
#import "FORMField.h"
#import "FORMSection.h"
#import "FORMValidator.h"
#import "FORMFormatter.h"
#import "FORMInputValidator.h"
#import "FORMFieldValue.h"
#import "FORMClassFactory.h"
#import "FORMTarget.h"
#import "FORMFieldValidation.h"

#import "NSDictionary+ANDYSafeValue.h"
#import "ISO8601DateFormatter.h"

static NSString * const FORMFieldSelectType = @"select";
static NSString * const FORMInputValidatorSelector = @"validateString:text:";
static NSString * const FORMFormatterSelector = @"formatString:reverse:";

@implementation FORMField

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          position:(NSInteger)position
                          disabled:(BOOL)disabled
                 disabledFieldsIDs:(NSArray *)disabledFieldsIDs {
    self = [super init];
    if (!self) return nil;

    NSString *remoteID = [dictionary andy_valueForKey:@"id"];

    _valid = YES;
    _fieldID = remoteID;
    _validationResultType = FORMValidationResultTypeValid;
    _title = NSLocalizedString([dictionary andy_valueForKey:@"title"], nil);
    _typeString  = [dictionary andy_valueForKey:@"type"];
    _hidden = [[dictionary andy_valueForKey:@"hidden"] boolValue];
    _type = [self typeFromTypeString:self.typeString];
    _inputTypeString = [dictionary andy_valueForKey:@"input_type"];
    if (_inputTypeString.length == 0) {
        _inputTypeString = _typeString;
    }
    _info = NSLocalizedString([dictionary andy_valueForKey:@"info"], nil);
    _placeholder = NSLocalizedString([dictionary andy_valueForKey:@"placeholder"], nil);
    NSNumber *width = [dictionary andy_valueForKey:@"size.width"] ?: @100;
    NSNumber *height = [dictionary andy_valueForKey:@"size.height"]?: @1;
    _size = CGSizeMake([width floatValue], [height floatValue]);
    _position = @(position);

    NSDictionary *validations = [dictionary andy_valueForKey:@"validations"];
    if (validations && [validations count] > 0) {
        _validation = [[FORMFieldValidation alloc]
                       initWithDictionary:[dictionary andy_valueForKey:@"validations"]];
    }

    _disabled = [[dictionary andy_valueForKey:@"disabled"] boolValue];
    _initiallyDisabled = _disabled;
    _formula = [dictionary andy_valueForKey:@"formula"];

    ISO8601DateFormatter *dateFormatter = [ISO8601DateFormatter new];

    NSString *maximumDateString = [dictionary andy_valueForKey:@"maximum_date"];
    if (maximumDateString) {
        _maximumDate = [dateFormatter dateFromString:maximumDateString];
    }

    NSString *minimumDateString = [dictionary andy_valueForKey:@"minimum_date"];
    if (minimumDateString) {
        _minimumDate = [dateFormatter dateFromString:minimumDateString];
    }

    NSMutableArray *targets = [NSMutableArray new];

    for (NSDictionary *targetDict in [dictionary andy_valueForKey:@"targets"]) {
        FORMTarget *target = [[FORMTarget alloc] initWithDictionary:targetDict];
        [targets addObject:target];
    }

    _targets = targets;

    NSDictionary *styles = [dictionary andy_valueForKey:@"styles"];

    _styles = styles;

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

    _value = [dictionary andy_valueForKey:@"value"];

    BOOL isDateType = (_type == FORMFieldTypeDate ||
                       _type == FORMFieldTypeDateTime ||
                       _type == FORMFieldTypeTime);

    if (_value && isDateType) {
        _value = [dateFormatter dateFromString:_value];
    }

    return self;
}

#pragma mark - Setters

- (void)setValue:(id)fieldValue {
    id resultValue = fieldValue;

    switch (self.type) {
        case FORMFieldTypeNumber:
        case FORMFieldTypeFloat:
        case FORMFieldTypeCount: {
            if (![fieldValue isKindOfClass:[NSString class]]) {
                resultValue = [fieldValue stringValue];
            }
        } break;

        case FORMFieldTypeDateTime:
        case FORMFieldTypeTime:
        case FORMFieldTypeDate: {
            if ([fieldValue isKindOfClass:[NSString class]]) {
                NSDateFormatter *formatter = [NSDateFormatter new];
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

    if ([resultValue isKindOfClass:[NSString class]]) {
        NSString *value = (NSString *)resultValue;
        if (!value.length) {
            resultValue = nil;
        }
    }

    _value = resultValue;
}

#pragma mark - Getters

- (id)rawFieldValue {
    if ([self.value isKindOfClass:[FORMFieldValue class]]) {
        return [self.value valueID];
    }

    switch (self.type) {
        case FORMFieldTypeFloat:
            if ([self.value isKindOfClass:[NSString class]]) {
                self.value = [self.value stringByReplacingOccurrencesOfString:@"," withString:@"."];
            }
            return @([self.value floatValue]);
        case FORMFieldTypeNumber:
        case FORMFieldTypeCount:
            return @([self.value integerValue]);

        case FORMFieldTypeText:
        case FORMFieldTypeSelect:
        case FORMFieldTypeDate:
        case FORMFieldTypeDateTime:
        case FORMFieldTypeTime:
            return self.value;

        case FORMFieldTypeButton:
        case FORMFieldTypeCustom:
            return nil;
    }
}

- (id)inputValidator {
    FORMInputValidator *inputValidator;

    Class fieldValidator = [FORMClassFactory classFromString:self.fieldID withSuffix:@"InputValidator"];

    NSString *typeID = (self.inputTypeString != nil) ? self.inputTypeString : self.typeString;
    Class typeValidator = [FORMClassFactory classFromString:typeID withSuffix:@"InputValidator"];

    SEL selector = NSSelectorFromString(FORMInputValidatorSelector);

    if (fieldValidator && [fieldValidator instanceMethodForSelector:selector]) {
        inputValidator = [fieldValidator new];
    } else if (typeValidator && [typeValidator instanceMethodForSelector:selector]) {
        inputValidator = [typeValidator new];
    }

    if (inputValidator) {
        inputValidator.validation = self.validation;
    }

    return inputValidator;
}

- (id)formatter {
    NSString *fieldClassName = self.fieldID;
    NSRange dotRange = [self.fieldID rangeOfString:@"."];
    if (dotRange.location != NSNotFound) {
        fieldClassName = [self.fieldID substringFromIndex:dotRange.location+1];
    }

    FORMFormatter *formatter;
    Class fieldFormatter = [FORMClassFactory classFromString:fieldClassName withSuffix:@"Formatter"];
    Class typeFormatter = [FORMClassFactory classFromString:self.typeString withSuffix:@"Formatter"];
    SEL selector = NSSelectorFromString(FORMFormatterSelector);

    if (fieldFormatter && [fieldFormatter instanceMethodForSelector:selector]) {
        formatter = [fieldFormatter new];
    } else if (typeFormatter && [typeFormatter instanceMethodForSelector:selector]) {
        formatter = [typeFormatter new];
    }

    return formatter;
}

- (FORMFieldType)typeFromTypeString:(NSString *)typeString {
    if ([typeString isEqualToString:@"text"] ||
        [typeString isEqualToString:@"name"] ||
        [typeString isEqualToString:@"email"] ||
        [typeString isEqualToString:@"password"]) {
        return FORMFieldTypeText;
    } else if ([typeString isEqualToString:@"select"]) {
        return FORMFieldTypeSelect;
    } else if ([typeString isEqualToString:@"date"]) {
        return FORMFieldTypeDate;
    } else if ([typeString isEqualToString:@"date_time"]) {
        return FORMFieldTypeDateTime;
    } else if ([typeString isEqualToString:@"time"]) {
        return FORMFieldTypeTime;
    } else if ([typeString isEqualToString:@"float"]) {
        return FORMFieldTypeFloat;
    } else if ([typeString isEqualToString:@"number"]) {
        return FORMFieldTypeNumber;
    } else if ([typeString isEqualToString:@"count"]) {
        return FORMFieldTypeCount;
    } else if ([typeString isEqualToString:@"button"]) {
        return FORMFieldTypeButton;
    } else {
        return FORMFieldTypeCustom;
    }
}

- (FORMFieldValue *)fieldValueWithID:(id)fieldValueID {
    for (FORMFieldValue *fieldValue in self.values) {
        if ([fieldValue identifierIsEqualTo:self.value]) return fieldValue;
    }

    return nil;
}

- (FORMFieldValue *)selectFieldValueWithValueID:(id)fieldValueID {
    for (FORMFieldValue *fieldValue in self.values) {
        if ([fieldValue identifierIsEqualTo:fieldValueID]) {
            self.value = fieldValue;
            return self.value;
        }
    }

    return nil;
}

- (FORMValidationResultType)validate {
    id validator;
    Class validatorClass;

    validatorClass = ([FORMClassFactory classFromString:self.fieldID withSuffix:@"Validator"]) ?: [FORMValidator class];
    validator = [[validatorClass alloc] initWithValidation:self.validation];

    self.validationResultType = [validator validateFieldValue:self.value];

    if (self.validation.compareToFieldID.length) {
        FORMField *field = [self.class fieldForFieldID:self.validation.compareToFieldID inSection:self.section];
        id dependantFieldValue = field.value;
        self.validationResultType = [validator validateFieldValue:self.value withDependentValue:dependantFieldValue withComparator:self.validation.compareRule];
    }

    self.valid = (self.validationResultType == FORMValidationResultTypeValid);

    return self.validationResultType;
}

#pragma mark - Public Methods

+ (FORMField *)fieldAtIndexPath:(NSIndexPath *)indexPath inSection:(FORMSection *)section {
    FORMField *field = section.fields[indexPath.row];
    return field;
}

+ (FORMField *)fieldForFieldID:(NSString *)fieldID inSection:(FORMSection *)section {
    __block FORMField *formField;
    [section.fields enumerateObjectsUsingBlock:^(FORMField *field, NSUInteger idx, BOOL *stop) {
        if ([field.fieldID isEqualToString:fieldID]) {
            formField = field;
        }
    }];
    return formField;
}

- (NSUInteger)indexInSectionUsingGroups:(NSArray *)groups {
    FORMGroup *group = groups[[self.section.group.position integerValue]];
    FORMSection *section = group.sections[[self.section.position integerValue]];

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

- (NSArray *)safeTargets {
    if (self.type == FORMFieldTypeSelect) {
        if ([self.value isKindOfClass:[FORMFieldValue class]]) {
            if ([self.value targets].count > 0) return [self.value targets];
        } else {
            FORMFieldValue *fieldValue = [self fieldValueWithID:self.value];
            if (fieldValue.targets.count > 0) return fieldValue.targets;
        }
    } else {
        if (self.targets.count > 0) return self.targets;
    }

    return nil;
}

- (NSNumber *)sectionPosition {
    if (self.section) {
        return self.section.position;
    } else {
        return nil;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n — Field: %@ —\n title: %@\n info: %@\n placeholder: %@\n size: %@\n position: %@\n fieldValue: %@\n type: %@\n values: %@\n disabled: %@\n initiallyDisabled: %@\n minimumDate: %@\n maximumDate: %@\n validations: %@\n formula: %@\n valid: %@\n sectionSeparator: %@\n",
            self.fieldID, self.title, self.info, self.placeholder, NSStringFromCGSize(self.size), self.position,
            self.value, self.typeString, self.values, (self.disabled) ? @"YES" : @"NO", (self.initiallyDisabled) ? @"YES" : @"NO", self.minimumDate,
            self.maximumDate, self.validation, self.formula, (self.valid) ? @"YES" : @"NO", (self.sectionSeparator) ? @"YES" : @"NO"];
}

@end
