@import UIKit;
@import XCTest;

#import "FORMValidator.h"

@interface FORMValidatorTests : XCTestCase

@end

@implementation FORMValidatorTests

- (void)testValidateFieldValue {
    FORMFieldValidation *validation = [[FORMFieldValidation alloc] initWithDictionary:@{@"min_value" : @10,
                                                                                        @"max_value" : @100}];
    FORMValidator *validator = [[FORMValidator alloc] initWithValidation:validation];

    XCTAssertEqual(FORMValidationResultTypeValid, [validator validateFieldValue:@"100"]);
    XCTAssertEqual(FORMValidationResultTypeValid, [validator validateFieldValue:@"10"]);
    XCTAssertEqual(FORMValidationResultTypeValid, [validator validateFieldValue:@"50"]);
    XCTAssertEqual(FORMValidationResultTypeInvalidValue, [validator validateFieldValue:@"1"]);
    XCTAssertEqual(FORMValidationResultTypeInvalidValue, [validator validateFieldValue:@"101"]);
}

@end
