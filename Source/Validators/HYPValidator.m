#import "HYPValidator.h"
#import "HYPFieldValue.h"
#import "HYPClassFactory.h"

@interface HYPValidator ()

@property (nonatomic, strong) NSDictionary *validations;

@end

@implementation HYPValidator

- (instancetype)initWithValidations:(NSDictionary *)validations
{
    self = [super init];
    if (!self) return nil;

    self.validations = validations;

    return self;
}

- (HYPFormValidationType)validateFieldValue:(id)fieldValue
{
    if (!self.validations) return HYPFormValidationTypePassed;

    BOOL required = (self.validations[@"required"] &&
                     [self.validations[@"required"] boolValue] == YES);

    NSUInteger minimumLength = 0;

    if (!fieldValue && !required) return YES;

    if ([fieldValue isKindOfClass:[HYPFieldValue class]]) {
        return HYPFormValidationTypePassed;
    }

    if (self.validations[@"min_length"] != nil) {
        minimumLength = [self.validations[@"min_length"] integerValue];
    }

    if (minimumLength == 0 && required) {
        minimumLength = 1;
    }

    if (minimumLength > 0) {
        if (!fieldValue) {
            return HYPFormValidationTypeValueMissing;
        } else if ([fieldValue isKindOfClass:[NSString class]]) {
            BOOL fieldValueIsShorter = ([fieldValue length] < minimumLength);
            if (fieldValueIsShorter) return HYPFormValidationTypeTooShort;
        }
    }

    if ([fieldValue isKindOfClass:[NSString class]] && self.validations[@"max_length"]) {
        BOOL fieldValueIsLonger = ([fieldValue length] > [self.validations[@"max_length"] unsignedIntegerValue]);
        if (fieldValueIsLonger) return HYPFormValidationTypeTooLong;
    }

    if ([fieldValue isKindOfClass:[NSString class]] && self.validations[@"format"]) {
        if (![self validateString:fieldValue
                      withFormat:self.validations[@"format"]]) {
            return HYPFormValidationTypeInvalidFormat;
        }
    }

    return HYPFormValidationTypePassed;
}

- (BOOL)validateString:(NSString *)fieldValue withFormat:(NSString *)format
{
    if (!fieldValue) return YES;

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.validations[@"format"] options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:fieldValue options:NSMatchingReportProgress range:NSMakeRange(0, fieldValue.length)];
    return (numberOfMatches > 0);
}

+ (Class)classForKey:(NSString *)key andType:(NSString *)type
{
    Class validatorClass = ([HYPClassFactory classFromString:key withSuffix:@"Validator"]);
    if (!validatorClass) {
        validatorClass = ([HYPClassFactory classFromString:type withSuffix:@"Validator"]);
    }
    if (!validatorClass) {
        validatorClass = [HYPValidator class];
    }

    return validatorClass;
}

@end
