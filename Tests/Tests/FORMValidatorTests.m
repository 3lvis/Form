@import UIKit;
@import XCTest;

#import "FORMValidator.h"

@interface FORMValidatorTests : XCTestCase

@end

@implementation FORMValidatorTests

- (void)testValidateFieldValue
{
    FORMFieldValidation *validation = [[FORMFieldValidation alloc] initWithDictionary:@{@"min_value" : @1,
                                                                                        @"max_value" : @100}];
    FORMValidator *validator = [[FORMValidator alloc] initWithValidation:validation];

    XCTAssertEqual(FORMValidationResultTypeValid, [validator validateFieldValue:@"100"]);
}

@end
