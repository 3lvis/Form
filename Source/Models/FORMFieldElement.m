#import "FORMFieldElement.h"

#import "NSDictionary+ANDYSafeValue.h"
#import "ISO8601DateFormatter.h"
#import "FORMFieldValidation.h"

@implementation FORMFieldElement

#pragma mark - Initializers

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) return nil;

    _title = [dictionary andy_valueForKey:@"title"];
    _info = [dictionary andy_valueForKey:@"info"];
    _typeString  = [dictionary andy_valueForKey:@"type"];
    _type = [self typeFromTypeString:self.typeString];
    _inputTypeString = [dictionary andy_valueForKey:@"input_type"];
    _hidden = [[dictionary andy_valueForKey:@"hidden"] boolValue];

    NSNumber *width = [dictionary andy_valueForKey:@"size.width"];
    NSNumber *height = [dictionary andy_valueForKey:@"size.height"];
    if (height && width) {
        _size = CGSizeMake([width floatValue], [height floatValue]);
    }
    _position = [dictionary andy_valueForKey:@"position"];
    _value = [dictionary andy_valueForKey:@"value"];

    ISO8601DateFormatter *dateFormatter = [ISO8601DateFormatter new];

    NSString *minimumDateString = [dictionary andy_valueForKey:@"minimum_date"];
    if (minimumDateString) {
        _minimumDate = [dateFormatter dateFromString:minimumDateString];
    }

    NSString *maximumDateString = [dictionary andy_valueForKey:@"maximum_date"];
    if (maximumDateString) {
        _maximumDate = [dateFormatter dateFromString:maximumDateString];
    }

    NSDictionary *validations = [dictionary andy_valueForKey:@"validations"];
    if (validations && [validations count] > 0) {
        _validation = [[FORMFieldValidation alloc]
                       initWithDictionary:[dictionary andy_valueForKey:@"validations"]];
    }

    _formula = [dictionary andy_valueForKey:@"formula"];

    BOOL isDateType = (_type == FORMFieldTypeDate ||
                       _type == FORMFieldTypeDateTime ||
                       _type == FORMFieldTypeTime);

    if (_value && isDateType) {
        ISO8601DateFormatter *dateFormatter = [ISO8601DateFormatter new];
        _value = [dateFormatter dateFromString:_value];
    }

    return self;
}

#pragma mark - Setters

- (void)setValue:(id)fieldValue {
    id resultValue = fieldValue;

    switch (self.type) {
        case FORMFieldTypeNumber:
        case FORMFieldTypeFloat: {
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

    _value = resultValue;
}

#pragma mark = Public Methods

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
    } else if ([typeString isEqualToString:@"button"]) {
        return FORMFieldTypeButton;
    } else {
        return FORMFieldTypeCustom;
    }
}

@end
