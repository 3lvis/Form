#import "HYPForm+Tests.h"

#import "HYPFormSection+Tests.h"

@implementation HYPForm (Tests)

+ (HYPForm *)personalDetailsForm
{
    HYPForm *form = [HYPForm new];
    form.formID = @"personal_details";
    form.title = @"Personal details";
    form.position = @0;

    HYPFormSection *personalDetails0 = [HYPFormSection personalDetails0];
    personalDetails0.form = form;

    HYPFormSection *personalDetails1 = [HYPFormSection personalDetails1];
    personalDetails1.form = form;

    form.sections = [@[personalDetails0,
                       personalDetails1] mutableCopy];

    return form;
}

+ (HYPForm *)employmentForm
{
    HYPForm *form = [HYPForm new];
    form.formID = @"employment";
    form.title = @"Employment";
    form.position = @1;

    HYPFormSection *employment0 = [HYPFormSection employment0];
    employment0.form = form;

    HYPFormSection *employment1 = [HYPFormSection employment1];
    employment1.form = form;

    HYPFormSection *employment2 = [HYPFormSection employment2];
    employment2.form = form;

    form.sections = [@[employment0,
                       employment1,
                       employment2] mutableCopy];

    return form;
}

@end
