@import XCTest;

#import "HYPFormTarget.h"

@interface HYPFormTargetTests : XCTestCase

@end

@implementation HYPFormTargetTests

- (void)testInitWithDictionary
{
    HYPFormTarget *target = [[HYPFormTarget alloc] initWithDictionary:@{@"id": @"start_date",
                                                                        @"type": @"field",
                                                                        @"action": @"show"}];
    XCTAssertNotNil(target);
    XCTAssertEqualObjects(target.targetID, @"start_date");
    XCTAssertEqualObjects(target.typeString, @"field");
    XCTAssertEqualObjects(target.actionTypeString, @"show");
    XCTAssertTrue(target.type == HYPFormTargetTypeField);
    XCTAssertTrue(target.actionType == HYPFormTargetActionShow);

    target = [[HYPFormTarget alloc] initWithDictionary:@{@"id": @"section_id",
                                                         @"type": @"section",
                                                         @"action": @"hide"}];
    XCTAssertNotNil(target);
    XCTAssertEqualObjects(target.targetID, @"section_id");
    XCTAssertEqualObjects(target.typeString, @"section");
    XCTAssertEqualObjects(target.actionTypeString, @"hide");
    XCTAssertTrue(target.type == HYPFormTargetTypeSection);
    XCTAssertTrue(target.actionType == HYPFormTargetActionHide);

    target = [[HYPFormTarget alloc] initWithDictionary:@{@"id": @"first_name",
                                                         @"type": @"field",
                                                         @"action": @"disable"}];
    XCTAssertNotNil(target);
    XCTAssertEqualObjects(target.targetID, @"first_name");
    XCTAssertEqualObjects(target.typeString, @"field");
    XCTAssertEqualObjects(target.actionTypeString, @"disable");
    XCTAssertTrue(target.type == HYPFormTargetTypeField);

    XCTAssertTrue(target.actionType == HYPFormTargetActionDisable);
    target = [[HYPFormTarget alloc] initWithDictionary:@{@"id": @"last_name",
                                                         @"type": @"field",
                                                         @"action": @"enable"}];
    XCTAssertNotNil(target);
    XCTAssertEqualObjects(target.targetID, @"last_name");
    XCTAssertEqualObjects(target.typeString, @"field");
    XCTAssertEqualObjects(target.actionTypeString, @"enable");
    XCTAssertTrue(target.type == HYPFormTargetTypeField);
    XCTAssertTrue(target.actionType == HYPFormTargetActionEnable);
}

@end
