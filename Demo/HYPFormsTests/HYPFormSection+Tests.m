#import "HYPFormSection+Tests.h"

#import "HYPFormField+Tests.h"

@implementation HYPFormSection (Tests)

+ (HYPFormSection *)personalDetails0
{
    HYPFormSection *section = [HYPFormSection new];
    section.sectionID = @"personal_details-0";
    section.position = @0;
    section.fields = [@[[HYPFormField firstNameField],
                        [HYPFormField lastNameField],
                        [HYPFormField displayNameField]] mutableCopy];

    return section;
}

+ (HYPFormSection *)personalDetails1
{
    HYPFormSection *section = [HYPFormSection new];
    section.sectionID = @"personal_details-1";
    section.position = @1;
    section.fields = [@[[HYPFormField emailField],
                        [HYPFormField usernameField]] mutableCopy];

    return section;
}

+ (HYPFormSection *)employment0
{
    HYPFormSection *section = [HYPFormSection new];
    section.sectionID = @"employment-0";
    section.position = @0;
    section.fields = [@[[HYPFormField workHoursField],
                        [HYPFormField workerTypeField]] mutableCopy];

    return section;
}

+ (HYPFormSection *)employment1
{
    HYPFormSection *section = [HYPFormSection new];
    section.sectionID = @"employment-1";
    section.position = @1;
    section.fields = [@[[HYPFormField startDateField],
                        [HYPFormField endDateField],
                        [HYPFormField contractTypeField]] mutableCopy];

    return section;
}

+ (HYPFormSection *)employment2
{
    HYPFormSection *section = [HYPFormSection new];
    section.sectionID = @"employment-2";
    section.position = @2;
    section.fields = [@[[HYPFormField baseSalaryTypeField],
                        [HYPFormField bonusEnabledField],
                        [HYPFormField bonusField],
                        [HYPFormField totalField]] mutableCopy];

    return section;
}

@end
