#import "FORMField.h"
#import "FORMFieldValidation.h"

@interface FORMInputValidator : NSObject

@property (nonatomic) FORMFieldValidation *validation;

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text withRange:(NSRange)range;

@end
