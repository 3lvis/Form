#import "HYPFormSection+Tests.h"

#import "HYPFormField+Tests.h"

@implementation HYPFormSection (Tests)

+ (HYPFormSection *)personalDetails0
{
    HYPFormSection *section = [HYPFormSection new];
    section.sectionID = @"personal_details-0";
    section.position = @0;

    HYPFormField *firstNameField = [HYPFormField firstNameField];
    firstNameField.section = section;

    HYPFormField *lastNameField = [HYPFormField lastNameField];
    lastNameField.section = section;

    HYPFormField *displayNameField = [HYPFormField displayNameField];
    displayNameField.section = section;

    section.fields = [@[firstNameField,
                        lastNameField,
                        displayNameField] mutableCopy];

    return section;
}

+ (HYPFormSection *)personalDetails1
{
    HYPFormSection *section = [HYPFormSection new];
    section.sectionID = @"personal_details-1";
    section.position = @1;

    HYPFormField *addressField = [HYPFormField addressField];
    addressField.section = section;

    HYPFormField *emailField = [HYPFormField emailField];
    emailField.section = section;

    HYPFormField *usernameField = [HYPFormField usernameField];
    usernameField.section = section;

    section.fields = [@[addressField,
                        emailField,
                        usernameField] mutableCopy];

    return section;
}

+ (HYPFormSection *)employment0
{
    HYPFormSection *section = [HYPFormSection new];
    section.sectionID = @"employment-0";
    section.position = @0;

    HYPFormField *workHoursField = [HYPFormField workHoursField];
    workHoursField.section = section;

    HYPFormField *workerTypeField = [HYPFormField workerTypeField];
    workerTypeField.section = section;

    section.fields = [@[workHoursField,
                        workerTypeField] mutableCopy];

    return section;
}

+ (HYPFormSection *)employment1
{
    HYPFormSection *section = [HYPFormSection new];
    section.sectionID = @"employment-1";
    section.position = @1;

    HYPFormField *startDateField = [HYPFormField startDateField];
    startDateField.section = section;

    HYPFormField *endDateField = [HYPFormField endDateField];
    endDateField.section = section;

    HYPFormField *contractTypeField = [HYPFormField contractTypeField];
    contractTypeField.section = section;

    section.fields = [@[startDateField,
                        endDateField,
                        contractTypeField] mutableCopy];

    return section;
}

+ (HYPFormSection *)employment2
{
    HYPFormSection *section = [HYPFormSection new];
    section.sectionID = @"employment-2";
    section.position = @2;

    HYPFormField *baseSalaryTypeField = [HYPFormField baseSalaryTypeField];
    baseSalaryTypeField.section = section;

    HYPFormField *bonusEnabledField = [HYPFormField bonusEnabledField];
    bonusEnabledField.section = section;

    HYPFormField *bonusField = [HYPFormField bonusField];
    bonusField.section = section;

    HYPFormField *totalField = [HYPFormField totalField];
    totalField.section = section;

    section.fields = [@[baseSalaryTypeField,
                        bonusEnabledField,
                        bonusField,
                        totalField] mutableCopy];

    return section;
}

@end
