#import "HYPFormsManager+Tests.h"

#import "HYPForm.h"
#import "HYPFormSection.h"
#import "HYPFormField.h"
#import "HYPFormTarget.h"
#import "HYPFieldValidation.h"
#import "HYPForm+Tests.h"

@implementation HYPFormsManager (Tests)

+ (NSMutableArray *)testForms
{
    return [@[[HYPForm personalDetailsForm],
              [HYPForm employmentForm]] mutableCopy];
}

@end
