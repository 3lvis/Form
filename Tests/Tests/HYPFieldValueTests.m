@import XCTest;

#import "FORMFieldValue.h"

@interface HYPFieldValueTests : XCTestCase

@end

@implementation HYPFieldValueTests

- (void)testInitWithDictionary
{
    FORMFieldValue *fieldValue = [[FORMFieldValue alloc] initWithDictionary:@{@"id": @"contract_type",
                                                                            @"title": @"Contract Type",
                                                                            @"subtitle": @"This is ma' contract",
                                                                            @"value": @1,
                                                                            @"default": @YES}];
    XCTAssertNotNil(fieldValue);
    XCTAssertEqualObjects(fieldValue.valueID, @"contract_type");
    XCTAssertEqualObjects(fieldValue.title, @"Contract Type");
    XCTAssertEqualObjects(fieldValue.subtitle, @"This is ma' contract");
    XCTAssertEqualObjects(fieldValue.value, @1);
    XCTAssertTrue(fieldValue.defaultValue);

    fieldValue = [[FORMFieldValue alloc] initWithDictionary:@{@"id": @0,
                                                             @"title": @"Full time"}];
    XCTAssertNotNil(fieldValue);
    XCTAssertEqualObjects(fieldValue.valueID, @0);
    XCTAssertEqualObjects(fieldValue.title, @"Full time");
}

@end
