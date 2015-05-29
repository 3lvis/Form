#import "FORMField+Tests.h"

#import "FORMFieldValue.h"
#import "FORMTarget.h"
#import "FORMFieldValidation.h"

@implementation FORMField (Tests)

#pragma mark - Convenience

+ (FORMField *)formFieldWithID:(NSString *)fieldID typeString:(NSString *)typeString {
    FORMField *textFormField = [FORMField new];
    textFormField.fieldID = fieldID;
    textFormField.title = fieldID;
    textFormField.typeString = typeString;
    textFormField.type = [textFormField typeFromTypeString:textFormField.typeString];
    textFormField.size = CGSizeMake(25.0f, 1.0f);

    return textFormField;
}

+ (FORMField *)textFormFieldWithID:(NSString *)fieldID {
    return [self formFieldWithID:fieldID typeString:@"text"];
}

+ (FORMField *)floatFormFieldWithID:(NSString *)fieldID {
    return [self formFieldWithID:fieldID typeString:@"float"];
}

+ (FORMField *)selectFormFieldWithID:(NSString *)fieldID {
    return [self formFieldWithID:fieldID typeString:@"select"];
}

+ (FORMField *)dateFormFieldWithID:(NSString *)fieldID {
    return [self formFieldWithID:fieldID typeString:@"date"];
}

#pragma mark - Employment

#pragma mark Section 0

+ (FORMField *)firstNameField {
    FORMField *formField = [FORMField textFormFieldWithID:@"first_name"];
    formField.position = @0;
    formField.validation = [[FORMFieldValidation alloc] initWithDictionary:@{@"required" : @YES}];

    return formField;
}

+ (FORMField *)lastNameField {
    FORMField *formField = [FORMField textFormFieldWithID:@"last_name"];
    formField.position = @1;
    formField.validation = [[FORMFieldValidation alloc] initWithDictionary:@{@"required" : @YES}];

    return formField;
}

+ (FORMField *)displayNameField {
    FORMField *formField = [FORMField textFormFieldWithID:@"display_name"];
    formField.position = @2;
    formField.formula = @"first_name last_name";

    return formField;
}

#pragma mark Section 1

+ (FORMField *)addressField {
    FORMField *field = [FORMField textFormFieldWithID:@"address"];
    field.position = @0;

    return field;
}

+ (FORMField *)emailField {
    FORMField *field = [FORMField textFormFieldWithID:@"email"];
    field.position = @1;
    field.validation = [[FORMFieldValidation alloc]
                        initWithDictionary:@{@"required" : @YES,
                                             @"format": @"[\\w._%+-]+@[\\w.-]+\\.\\w{2,}"}];

    return field;
}

+ (FORMField *)usernameField {
    FORMField *field = [FORMField textFormFieldWithID:@"username"];
    field.position = @2;

    return field;
}

#pragma mark - Employment

#pragma mark Section 0

+ (FORMField *)workHoursField {
    FORMField *field = [FORMField floatFormFieldWithID:@"work_hours"];
    field.position = @0;

    return field;
}

#pragma mark Section 1

+ (FORMField *)startDateField {
    FORMField *field = [self dateFormFieldWithID:@"start_date"];
    field.position = @0;

    return field;
}

+ (FORMField *)endDateField {
    FORMField *field = [self dateFormFieldWithID:@"end_date"];
    field.position = @1;

    return field;
}

+ (FORMField *)contractTypeField {
    FORMField *field = [self selectFormFieldWithID:@"contract_type"];
    field.position = @2;

    FORMFieldValue *value1 = [FORMFieldValue new];
    value1.fieldValueID = @0;
    value1.title = @"Permanent";
    value1.targets = @[[FORMTarget showFieldTargetWithID:@"end_date"],
                       [FORMTarget showSectionTargetWithID:@"employment-2"]];
    value1.field = field;

    FORMFieldValue *value2 = [FORMFieldValue new];
    value2.fieldValueID = @1;
    value2.title = @"Temporary";
    value2.targets = @[[FORMTarget hideFieldTargetWithID:@"end_date"],
                       [FORMTarget hideSectionTargetWithID:@"employment-2"]];
    value2.field = field;

    field.values = @[value1, value2];

    return field;
}

#pragma mark Section 2

+ (FORMField *)baseSalaryTypeField {
    FORMField *field = [self selectFormFieldWithID:@"base_salary"];
    field.position = @0;

    FORMFieldValue *value1 = [FORMFieldValue new];
    value1.fieldValueID = @"base_salary_1";
    value1.title = @"Base salary 1";
    value1.field = field;
    value1.value = @100;
    value1.field = field;

    FORMFieldValue *value2 = [FORMFieldValue new];
    value2.fieldValueID = @"base_salary_2";
    value2.title = @"Base salary 2";
    value2.field = field;
    value2.value = @114;
    value2.field = field;

    FORMFieldValue *value3 = [FORMFieldValue new];
    value3.fieldValueID = @"base_salary_3";
    value3.title = @"Base salary 3";
    value3.field = field;
    value3.value = @454;
    value3.field = field;

    field.values = @[value1, value2, value3];

    return field;
}

+ (FORMField *)bonusEnabledField {
    FORMField *field = [self selectFormFieldWithID:@"bonus_enabled"];
    field.position = @1;

    FORMFieldValue *value1 = [FORMFieldValue new];
    value1.fieldValueID = @"bonus_enabled_yes";
    value1.title = @"YES";
    value1.field = field;
    value1.field = field;

    FORMFieldValue *value2 = [FORMFieldValue new];
    value2.fieldValueID = @"bonus_enabled_no";
    value2.title = @"NO";
    value2.field = field;
    value2.field = field;

    field.values = @[value1, value2];

    return field;
}

+ (FORMField *)bonusField {
    FORMField *field = [FORMField floatFormFieldWithID:@"bonus"];
    field.position = @2;

    return field;
}

+ (FORMField *)totalField {
    FORMField *field = [FORMField floatFormFieldWithID:@"total"];
    field.position = @3;
    field.formula = @"base_salary + bonus";

    return field;
}

@end
