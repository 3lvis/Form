#import "FORMValidator.h"
#import "FORMFieldValue.h"
#import "FORMClassFactory.h"

@interface FORMValidator ()

@property (nonatomic) FORMFieldValidation *validation;

@end

@implementation FORMValidator

- (instancetype)initWithValidation:(FORMFieldValidation *)validation {
    self = [super init];
    if (!self) return nil;

    self.validation = validation;

    return self;
}

- (FORMValidationResultType)validateFieldValue:(id)fieldValue {
    if (!self.validation) return FORMValidationResultTypeValid;

    if (!fieldValue) {
        if (self.validation.isRequired) {
            return FORMValidationResultTypeInvalidValueMissing;
        } else {
            return FORMValidationResultTypeValid;
        }
    }

    if ([fieldValue isKindOfClass:[FORMFieldValue class]]) {
        return FORMValidationResultTypeValid;
    }

    if (self.validation.minimumLength > 0) {
        if (!fieldValue) {
            return FORMValidationResultTypeInvalidValueMissing;
        } else if ([fieldValue isKindOfClass:[NSString class]]) {
            BOOL fieldValueIsShorter = ([fieldValue length] < [self.validation.minimumLength unsignedIntegerValue]);
            if (fieldValueIsShorter) return FORMValidationResultTypeInvalidTooShort;
        }
    }

    if ([fieldValue isKindOfClass:[NSString class]] && self.validation.maximumLength) {
        BOOL fieldValueIsLonger = ([fieldValue length] > [self.validation.maximumLength unsignedIntegerValue]);
        if (fieldValueIsLonger) return FORMValidationResultTypeInvalidTooLong;
    }

    if (self.validation.minimumValue || self.validation.maximumValue) {
        CGFloat value = 0.0f;
        if ([fieldValue isKindOfClass:[NSNumber class]]) {
            value = [fieldValue floatValue];
        } else if ([fieldValue isKindOfClass:[NSString class]]) {
            value = [fieldValue floatValue];
        }

        if (self.validation.minimumValue) {
            BOOL valueIsLessThanMinimum = (value < [self.validation.minimumValue floatValue]);
            if (valueIsLessThanMinimum) return FORMValidationResultTypeInvalidValue;
        }

        if (self.validation.maximumValue) {
            BOOL valueIsMoreThanMaximum = (value > [self.validation.maximumValue floatValue]);
            if (valueIsMoreThanMaximum) return FORMValidationResultTypeInvalidValue;
        }
    }

    if ([fieldValue isKindOfClass:[NSString class]] && self.validation.format) {
        if (![self validateString:fieldValue withFormat:self.validation.format]) {
            return FORMValidationResultTypeInvalidFormat;
        }
    }

    return FORMValidationResultTypeValid;
}

- (FORMValidationResultType)validateFieldValue:(id)fieldValue withDependentValue:(id)dependentValue withComparator:(NSString *)comparator {
  if ([fieldValue isKindOfClass:[NSDate class]]) {
    if ([comparator isEqualToString:@">"] && [fieldValue laterDate:dependentValue] == fieldValue) {
      return FORMValidationResultTypeValid;
    }
    else if ([comparator isEqualToString:@"<"] && [fieldValue earlierDate:dependentValue] == fieldValue) {
      return FORMValidationResultTypeValid;
    }
  }

  if ([comparator isEqualToString:@">"] && fieldValue > dependentValue) {
    return FORMValidationResultTypeValid;
  }
  if ([comparator isEqualToString:@">="] && fieldValue >= dependentValue) {
    return FORMValidationResultTypeValid;
  }
  if ([comparator isEqualToString:@"<"] && fieldValue < dependentValue) {
    return FORMValidationResultTypeValid;
  }
  if ([comparator isEqualToString:@"<="] && fieldValue <= dependentValue) {
    return FORMValidationResultTypeValid;
  }
  if ([comparator isEqualToString:@"=="] && fieldValue == dependentValue) {
    return FORMValidationResultTypeValid;
  }
  return FORMValidationResultTypeInvalidTooShort;
}


- (BOOL)validateString:(NSString *)fieldValue withFormat:(NSString *)format {
    if (!fieldValue) return YES;

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:format options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:fieldValue options:NSMatchingReportProgress range:NSMakeRange(0, fieldValue.length)];
    return (numberOfMatches > 0);
}

+ (Class)classForKey:(NSString *)key andType:(NSString *)type {
    Class validatorClass = ([FORMClassFactory classFromString:key withSuffix:@"Validator"]);
    if (!validatorClass) {
        validatorClass = ([FORMClassFactory classFromString:type withSuffix:@"Validator"]);
    }
    if (!validatorClass) {
        validatorClass = [FORMValidator class];
    }

    return validatorClass;
}

@end
