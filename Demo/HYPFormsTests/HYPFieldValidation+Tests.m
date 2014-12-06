#import "HYPFieldValidation+Tests.h"

@implementation HYPFieldValidation (Tests)

+ (HYPFieldValidation *)requiredValidation
{
    HYPFieldValidation *validation = [HYPFieldValidation new];
    validation.required = YES;

    return validation;
}

+ (HYPFieldValidation *)emailValidation
{
    HYPFieldValidation *fieldValidation = [HYPFieldValidation new];
    fieldValidation.format = @"[\\w._%+-]+@[\\w.-]+\\.\\w{2,}";

    return fieldValidation;
}

@end
