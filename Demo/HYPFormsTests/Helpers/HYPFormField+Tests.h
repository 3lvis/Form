#import "HYPFormField.h"

@interface HYPFormField (Tests)

+ (HYPFormField *)firstNameField;
+ (HYPFormField *)lastNameField;
+ (HYPFormField *)displayNameField;

+ (HYPFormField *)addressField;
+ (HYPFormField *)emailField;
+ (HYPFormField *)usernameField;

+ (HYPFormField *)workHoursField;

+ (HYPFormField *)startDateField;
+ (HYPFormField *)endDateField;
+ (HYPFormField *)contractTypeField;

+ (HYPFormField *)baseSalaryTypeField;
+ (HYPFormField *)bonusEnabledField;
+ (HYPFormField *)bonusField;
+ (HYPFormField *)totalField;

@end
