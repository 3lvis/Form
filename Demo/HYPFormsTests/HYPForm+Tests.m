#import "HYPForm+Tests.h"

#import "HYPFormSection+Tests.h"

@implementation HYPForm (Tests)

+ (HYPForm *)personalDetailsForm
{
    HYPForm *form = [HYPForm new];
    form.formID = @"personal_details";
    form.title = @"Personal details";
    form.position = @0;
    form.sections = [@[[HYPFormSection personalDetails0],
                       [HYPFormSection personalDetails1]] mutableCopy];

    return form;
}

+ (HYPForm *)employmentForm
{
    HYPForm *form = [HYPForm new];
    form.formID = @"employment";
    form.title = @"Employment";
    form.position = @1;
    form.sections = [@[[HYPFormSection employment0],
                       [HYPFormSection employment1],
                       [HYPFormSection employment2]] mutableCopy];

    return form;
}

@end
