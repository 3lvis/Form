#import "FORMField.h"

@interface FORMField (Tests)

+ (FORMField *)firstNameField;
+ (FORMField *)lastNameField;
+ (FORMField *)displayNameField;

+ (FORMField *)addressField;
+ (FORMField *)emailField;
+ (FORMField *)usernameField;

+ (FORMField *)workHoursField;

+ (FORMField *)startDateField;
+ (FORMField *)endDateField;
+ (FORMField *)contractTypeField;

+ (FORMField *)baseSalaryTypeField;
+ (FORMField *)bonusEnabledField;
+ (FORMField *)bonusField;
+ (FORMField *)totalField;

@end
