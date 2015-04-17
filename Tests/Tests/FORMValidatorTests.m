@import UIKit;
@import XCTest;

#import "FORMValidator.h"
#import "FORMBankAccountNumberValidator.h"
#import "FORMPostalCodeValidator.h"
#import "FORMSocialSecurityNumberValidator.h"

@interface FORMValidatorTests : XCTestCase

@end

@implementation FORMValidatorTests

- (void)testValid
{
    FORMFieldValidation *validation = [[FORMFieldValidation alloc] initWithDictionary:nil];
    FORMValidator *validator = [[FORMValidator alloc] initWithValidation:validation];

    XCTAssertEqual(FORMValidationResultTypeValid, [validator validateFieldValue:@"100"]);
    XCTAssertEqual(FORMValidationResultTypeValid, [validator validateFieldValue:nil]);
}

- (void)testRequired {
    FORMFieldValidation *validation = [[FORMFieldValidation alloc] initWithDictionary:@{@"required" : @YES}];
    FORMValidator *validator = [[FORMValidator alloc] initWithValidation:validation];

    XCTAssertEqual(FORMValidationResultTypeValid, [validator validateFieldValue:@"100"]);
    XCTAssertEqual(FORMValidationResultTypeInvalidValueMissing, [validator validateFieldValue:nil]);
}

- (void)testMinAndMaxValue {
    FORMFieldValidation *validation = [[FORMFieldValidation alloc] initWithDictionary:@{@"min_value" : @10,
                                                                                        @"max_value" : @100}];
    FORMValidator *validator = [[FORMValidator alloc] initWithValidation:validation];

    XCTAssertEqual(FORMValidationResultTypeValid, [validator validateFieldValue:nil]);
    XCTAssertEqual(FORMValidationResultTypeValid, [validator validateFieldValue:@"100"]);
    XCTAssertEqual(FORMValidationResultTypeValid, [validator validateFieldValue:@"10"]);
    XCTAssertEqual(FORMValidationResultTypeValid, [validator validateFieldValue:@"50"]);
    XCTAssertEqual(FORMValidationResultTypeInvalidValue, [validator validateFieldValue:@"1"]);
    XCTAssertEqual(FORMValidationResultTypeInvalidValue, [validator validateFieldValue:@"101"]);


    validation = [[FORMFieldValidation alloc] initWithDictionary:@{@"min_value" : @10,
                                                                   @"required": @YES}];
    validator = [[FORMValidator alloc] initWithValidation:validation];
    XCTAssertEqual(FORMValidationResultTypeInvalidValueMissing, [validator validateFieldValue:nil]);
}

- (void)testFormat {
    FORMFieldValidation *validation = [[FORMFieldValidation alloc] initWithDictionary:@{@"format" : @"[\\w._%+-]+@[\\w.-]+\\.\\w{2,}"}];
    FORMValidator *validator = [[FORMValidator alloc] initWithValidation:validation];

    XCTAssertEqual(FORMValidationResultTypeValid, [validator validateFieldValue:@"ios@hyper.no"]);
    XCTAssertEqual(FORMValidationResultTypeInvalidFormat, [validator validateFieldValue:@"ios@hyper"]);
}

- (void)testTooShort {
    FORMFieldValidation *validation = [[FORMFieldValidation alloc] initWithDictionary:@{@"min_length" : @2}];
    FORMValidator *validator = [[FORMValidator alloc] initWithValidation:validation];

    XCTAssertEqual(FORMValidationResultTypeValid, [validator validateFieldValue:@"ABC"]);
    XCTAssertEqual(FORMValidationResultTypeInvalidTooShort, [validator validateFieldValue:@"A"]);
}

- (void)testTooLong {
    FORMFieldValidation *validation = [[FORMFieldValidation alloc] initWithDictionary:@{@"max_length" : @2}];
    FORMValidator *validator = [[FORMValidator alloc] initWithValidation:validation];

    XCTAssertEqual(FORMValidationResultTypeValid, [validator validateFieldValue:@"A"]);
    XCTAssertEqual(FORMValidationResultTypeInvalidTooLong, [validator validateFieldValue:@"ABC"]);
}

#pragma mark - Custom Validators

/*- (void)testBankAccount {
    FORMBankAccountNumberValidator *validation = [FORMBankAccountNumberValidator new];

    XCTAssertEqual(FORMValidationResultTypeValid, [validation validateFieldValue:@"00000000000"]);
    XCTAssertEqual(FORMValidationResultTypeInvalidBankAccount, [validation validateFieldValue:@"101"]);
}*/

/*- (void)testPostalCode {
    FORMPostalCodeValidator *validation = [FORMPostalCodeValidator new];

    XCTAssertEqual(FORMValidationResultTypeValid, [validation validateFieldValue:@"0450"]);
    XCTAssertEqual(FORMValidationResultTypeInvalidPostalCode, [validation validateFieldValue:@"01"]);
}*/

/*- (void)testSSN {
    FORMSocialSecurityNumberValidator *validation = [FORMSocialSecurityNumberValidator new];

    XCTAssertEqual(FORMValidationResultTypeValid, [validation validateFieldValue:@"101"]);
    XCTAssertEqual(FORMValidationResultTypeInvalidSSN, [validation validateFieldValue:@"00000000000"]);
}*/

@end
