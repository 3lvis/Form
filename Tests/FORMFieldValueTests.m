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
                                                                              @"default": @YES,
                                                                              @"data": @{
                                                                                @"remote_id": @"1234"
                                                                              }}];
    XCTAssertNotNil(fieldValue);
    XCTAssertEqualObjects(fieldValue.valueID, @"contract_type");
    XCTAssertEqualObjects(fieldValue.title, @"Contract Type");
    XCTAssertEqualObjects(fieldValue.info, @"This is ma' contract");
    XCTAssertEqualObjects(fieldValue.accessibilityLabel, @"Accessibility label");
    XCTAssertEqualObjects(fieldValue.value, @1);
    XCTAssertTrue(fieldValue.defaultValue);
    XCTAssertEqualObjects([fieldValue.data objectForKey:@"remote_id"], @"1234");

    fieldValue = [[FORMFieldValue alloc] initWithDictionary:@{@"id": @0,
                                                              @"title": @"Full time"}];
    XCTAssertNotNil(fieldValue);
    XCTAssertEqualObjects(fieldValue.valueID, @0);
    XCTAssertEqualObjects(fieldValue.title, @"Full time");
}

@end
