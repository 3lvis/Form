#import "HYPFormField+Tests.h"

#import "HYPFieldValue.h"
#import "HYPFormTarget.h"
#import "HYPFieldValidation+Tests.h"

@implementation HYPFormField (Tests)

#pragma mark - Convenience

+ (HYPFormField *)formFieldWithID:(NSString *)fieldID typeString:(NSString *)typeString
{
    HYPFormField *textFormField = [HYPFormField new];
    textFormField.fieldID = fieldID;
    textFormField.title = fieldID;
    textFormField.typeString = typeString;
    textFormField.type = [textFormField typeFromTypeString:textFormField.typeString];
    textFormField.size = CGSizeMake(25.0f, 1.0f);

    return textFormField;
}

+ (HYPFormField *)textFormFieldWithID:(NSString *)fieldID
{
    return [self formFieldWithID:fieldID typeString:@"text"];
}

+ (HYPFormField *)floatFormFieldWithID:(NSString *)fieldID
{
    return [self formFieldWithID:fieldID typeString:@"float"];
}

+ (HYPFormField *)selectFormFieldWithID:(NSString *)fieldID
{
    return [self formFieldWithID:fieldID typeString:@"select"];
}

+ (HYPFormField *)dateFormFieldWithID:(NSString *)fieldID
{
    return [self formFieldWithID:fieldID typeString:@"date"];
}

#pragma mark - Employment

#pragma mark Section 0

+ (HYPFormField *)firstNameField
{
    HYPFormField *formField = [HYPFormField textFormFieldWithID:@"first_name"];
    formField.position = @0;
    formField.validation = [HYPFieldValidation requiredValidation];

    return formField;
}

+ (HYPFormField *)lastNameField
{
    HYPFormField *formField = [HYPFormField textFormFieldWithID:@"last_name"];
    formField.position = @1;
    formField.validation = [HYPFieldValidation requiredValidation];

    return formField;
}

+ (HYPFormField *)displayNameField
{
    HYPFormField *formField = [HYPFormField textFormFieldWithID:@"display_name"];
    formField.position = @2;
    formField.formula = @"first_name last_name";

    return formField;
}

#pragma mark Section 1

+ (HYPFormField *)emailField
{
    HYPFormField *field = [HYPFormField textFormFieldWithID:@"email"];
    field.position = @0;
    field.validation = [HYPFieldValidation emailValidation];

    return field;
}

+ (HYPFormField *)usernameField
{
    HYPFormField *field = [HYPFormField textFormFieldWithID:@"username"];
    field.position = @1;

    return field;
}

#pragma mark - Employment

#pragma mark Section 0

+ (HYPFormField *)workHoursField
{
    HYPFormField *field = [HYPFormField floatFormFieldWithID:@"work_hours"];
    field.position = @0;

    return field;
}

+ (HYPFormField *)workerTypeField
{
    HYPFormField *field = [self selectFormFieldWithID:@"worker_type"];
    field.position = @1;

    HYPFieldValue *value1 = [HYPFieldValue new];
    value1.valueID = @"part_time";
    value1.title = @"Part time";

#warning TODO: update-> work_hours max value 3 * 5
    value1.targets = nil;
    value1.field = field;
    value1.value = @3;

    HYPFieldValue *value2 = [HYPFieldValue new];
    value2.valueID = @"full_time";
    value2.title = @"Full time";

#warning TODO: update-> work_hours max value 7.5 * 5
    value2.targets = nil;
    value2.field = field;
    value2.value = @7.5;

    field.values = @[value1, value2];

    return field;
}

#pragma mark Section 1

+ (HYPFormField *)startDateField
{
    HYPFormField *field = [self dateFormFieldWithID:@"start_date"];
    field.position = @0;

    return field;
}

+ (HYPFormField *)endDateField
{
    HYPFormField *field = [self dateFormFieldWithID:@"end_date"];
    field.position = @1;

    return field;
}

+ (HYPFormField *)contractTypeField
{
    HYPFormField *field = [self selectFormFieldWithID:@"contract_type"];
    field.position = @2;

    HYPFieldValue *value1 = [HYPFieldValue new];
    value1.valueID = @"permanent";
    value1.title = @"Permanent";
    value1.targets = @[[HYPFormTarget hideFieldTargetWithID:@"end_date"]];
    value1.field = field;

    HYPFieldValue *value2 = [HYPFieldValue new];
    value2.valueID = @"Temporary";
    value2.title = @"Temporary";

#warning TODO: hide salary section too!
    value2.targets = @[[HYPFormTarget showFieldTargetWithID:@"end_date"]];
    value2.field = field;

    field.values = @[value1, value2];

    return field;
}

#pragma mark Section 2

+ (HYPFormField *)baseSalaryTypeField
{
    HYPFormField *field = [self selectFormFieldWithID:@"base_salary"];
    field.position = @0;

    HYPFieldValue *value1 = [HYPFieldValue new];
    value1.valueID = @"base_salary_1";
    value1.title = @"Base salary 1";
    value1.field = field;
    value1.value = @100;

    HYPFieldValue *value2 = [HYPFieldValue new];
    value2.valueID = @"base_salary_2";
    value2.title = @"Base salary 2";
    value2.field = field;
    value2.value = @114;

    HYPFieldValue *value3 = [HYPFieldValue new];
    value3.valueID = @"base_salary_3";
    value3.title = @"Base salary 3";
    value3.field = field;
    value3.value = @454;

    field.values = @[value1, value2, value3];

    return field;
}

+ (HYPFormField *)bonusEnabledField
{
    HYPFormField *field = [self selectFormFieldWithID:@"bonus_enabled"];
    field.position = @1;

    HYPFieldValue *value1 = [HYPFieldValue new];
    value1.valueID = @"bonus_enabled_yes";
    value1.title = @"YES";
    value1.field = field;

    HYPFieldValue *value2 = [HYPFieldValue new];
    value2.valueID = @"bonus_enabled_no";
    value2.title = @"NO";
    value2.field = field;

    field.values = @[value1, value2];

    return field;
}

+ (HYPFormField *)bonusField
{
    HYPFormField *field = [HYPFormField floatFormFieldWithID:@"bonus"];
    field.position = @2;

    return field;
}

+ (HYPFormField *)totalField
{
    HYPFormField *field = [HYPFormField floatFormFieldWithID:@"total"];
    field.position = @3;
    field.formula = @"base_salary + bonus";

    return field;
}

@end
