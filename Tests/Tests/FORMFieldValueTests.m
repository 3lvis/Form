@import XCTest;

#import "FORMFieldValue.h"

@interface FORMFieldValueTests : XCTestCase

@end

@implementation FORMFieldValueTests

- (void)testInitWithDictionary {
    FORMFieldValue *fieldValue = [[FORMFieldValue alloc] initWithDictionary:@{@"id": @"contract_type",
                                                                              @"title": @"Contract Type",
                                                                              @"info": @"This is ma' contract",
                                                                              @"value": @1,
                                                                              @"default": @YES}];
    XCTAssertNotNil(fieldValue);
    XCTAssertEqualObjects(fieldValue.fieldValueID, @"contract_type");
    XCTAssertEqualObjects(fieldValue.title, @"Contract Type");
    XCTAssertEqualObjects(fieldValue.info, @"This is ma' contract");
    XCTAssertEqualObjects(fieldValue.value, @1);
    XCTAssertTrue(fieldValue.isDefaultValue);

    fieldValue = [[FORMFieldValue alloc] initWithDictionary:@{@"id": @0,
                                                              @"title": @"Full time"}];
    XCTAssertNotNil(fieldValue);
    XCTAssertEqualObjects(fieldValue.fieldValueID, @0);
    XCTAssertEqualObjects(fieldValue.title, @"Full time");
    XCTAssertFalse(fieldValue.isDefaultValue);
}

- (void)testIdentifierIsEqualTo {
    FORMFieldValue *fieldValue = [[FORMFieldValue alloc] initWithDictionary:@{@"id": @NO}];
    XCTAssertTrue([fieldValue identifierIsEqualTo:@NO]);

    NSDate *date = [NSDate date];
    fieldValue = [[FORMFieldValue alloc] initWithDictionary:@{@"id": date}];
    XCTAssertTrue([fieldValue identifierIsEqualTo:date]);

    fieldValue = [[FORMFieldValue alloc] initWithDictionary:@{@"id": @"hello"}];
    XCTAssertTrue([fieldValue identifierIsEqualTo:@"hello"]);

    fieldValue = [[FORMFieldValue alloc] initWithDictionary:@{@"id": @"hello"}];
    XCTAssertFalse([fieldValue identifierIsEqualTo:nil]);
}

@end
