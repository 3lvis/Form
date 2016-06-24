@import XCTest;

#import "FORMInputValidator.h"

@interface FORMInputValidatorTests : XCTestCase

@end

@implementation FORMInputValidatorTests

- (void)testValidateReplacementStringWithInvalidRange {
    FORMInputValidator *inputValidator = [[FORMInputValidator alloc] init];
    FORMFieldValidation *fieldValidation = [[FORMFieldValidation alloc]
                                            initWithDictionary:@{@"required": @YES,
                                                                 @"max_value": @19.9}];
    inputValidator.validation = fieldValidation;
    BOOL isValid = [inputValidator validateReplacementString:@"1"
                                                    withText:@"10.0"
                                                   withRange:NSMakeRange(5, 1)];

    XCTAssertFalse(isValid);
}

- (void)testValidateReplacementStringWithValidRange {
    FORMInputValidator *inputValidator = [[FORMInputValidator alloc] init];
    FORMFieldValidation *fieldValidation = [[FORMFieldValidation alloc]
                                            initWithDictionary:@{@"required": @YES,
                                                                 @"max_value": @19.9}];
    inputValidator.validation = fieldValidation;
    BOOL isValid = [inputValidator validateReplacementString:@"1"
                                                    withText:@"10.0"
                                                   withRange:NSMakeRange(4, 1)];

    XCTAssertTrue(isValid);
}

- (void)testValidateReplacementStringWithInvalidString {
    FORMInputValidator *inputValidator = [[FORMInputValidator alloc] init];
    FORMFieldValidation *fieldValidation = [[FORMFieldValidation alloc]
                                            initWithDictionary:@{@"required": @YES,
                                                                 @"max_value": @19.9}];
    inputValidator.validation = fieldValidation;
    BOOL isValid = [inputValidator validateReplacementString:@"1000"
                                                    withText:@"10.0"
                                                   withRange:NSMakeRange(2, 1)];
    
    XCTAssertFalse(isValid);
}

@end
