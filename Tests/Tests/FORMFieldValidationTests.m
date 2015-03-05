@import XCTest;

#import "FORMFieldValidation.h"

@interface FORMFieldValidationTests : XCTestCase

@end

@implementation FORMFieldValidationTests

- (void)testInitWithDictionary
{
    FORMFieldValidation *fieldValidation = [[FORMFieldValidation alloc]
                                            initWithDictionary:@{@"required": @YES,
                                                                 @"min_length": @1,
                                                                 @"max_length": @10,
                                                                 @"format": @"[\\w._%+-]+@[\\w.-]+\\.\\w{2,}",
                                                                 @"min_value": @1.1,
                                                                 @"max_value": @9.9}];
    XCTAssertNotNil(fieldValidation);
    XCTAssertTrue(fieldValidation.required);
    XCTAssertTrue(fieldValidation.minimumLength == 1);
    XCTAssertTrue(fieldValidation.maximumLength == 10);
    XCTAssertEqualObjects(fieldValidation.format, @"[\\w._%+-]+@[\\w.-]+\\.\\w{2,}");
    
    fieldValidation = [[FORMFieldValidation alloc]
                                            initWithDictionary:@{}];
    XCTAssertNotNil(fieldValidation);
    XCTAssertFalse(fieldValidation.required);
    XCTAssertNil(fieldValidation.format);
}

@end
