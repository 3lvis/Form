@import XCTest;

#import "FORMFieldValue.h"

@interface FORMFieldValueTests : XCTestCase

@end

@implementation FORMFieldValueTests

- (void)testInitWithDictionary {
    FORMFieldValue *fieldValue = [[FORMFieldValue alloc] initWithDictionary:@{@"id": @"contract_type",
                                                                              @"title": @"Contract Type",
                                                                              @"info": @"This is ma' contract",
                                                                              @"accessibility_label": @"Accessibility label",
                                                                              @"value": @1,
                                                                              @"default": @YES}];
    XCTAssertNotNil(fieldValue);
    XCTAssertEqualObjects(fieldValue.valueID, @"contract_type");
    XCTAssertEqualObjects(fieldValue.title, @"Contract Type");
    XCTAssertEqualObjects(fieldValue.info, @"This is ma' contract");
    XCTAssertEqualObjects(fieldValue.accessibilityLabel, @"Accessibility label");
    XCTAssertEqualObjects(fieldValue.value, @1);
    XCTAssertTrue(fieldValue.defaultValue);

    fieldValue = [[FORMFieldValue alloc] initWithDictionary:@{@"id": @0,
                                                              @"title": @"Full time"}];
    XCTAssertNotNil(fieldValue);
    XCTAssertEqualObjects(fieldValue.valueID, @0);
    XCTAssertEqualObjects(fieldValue.title, @"Full time");
}

@end
