@import XCTest;

#import "FORMFieldValidation.h"

@interface FORMFieldValidationTests : XCTestCase

@end

@implementation FORMFieldValidationTests

- (void)testInitWithDictionary {
    FORMFieldValidation *fieldValidation = [[FORMFieldValidation alloc]
                                            initWithDictionary:@{@"required": @YES,
                                                                 @"min_length": @1,
                                                                 @"max_length": @10,
                                                                 @"format": @"[\\w._%+-]+@[\\w.-]+\\.\\w{2,}",
                                                                 @"min_value": @1.1,
                                                                 @"max_value": @9.9}];
    XCTAssertNotNil(fieldValidation);
    XCTAssertTrue(fieldValidation.isRequired);
    XCTAssertEqualObjects(fieldValidation.minimumLength, @1);
    XCTAssertEqualObjects(fieldValidation.maximumLength, @10);
    XCTAssertEqualObjects(fieldValidation.format, @"[\\w._%+-]+@[\\w.-]+\\.\\w{2,}");
    XCTAssertEqualObjects(fieldValidation.minimumValue, @1.1);
    XCTAssertEqualObjects(fieldValidation.maximumValue, @9.9);

    fieldValidation = [[FORMFieldValidation alloc]
                                            initWithDictionary:@{}];
    XCTAssertNotNil(fieldValidation);
    XCTAssertFalse(fieldValidation.isRequired);
    XCTAssertNil(fieldValidation.minimumLength);
    XCTAssertNil(fieldValidation.maximumLength);
    XCTAssertNil(fieldValidation.format);
    XCTAssertNil(fieldValidation.minimumValue);
    XCTAssertNil(fieldValidation.maximumValue);
}

@end
