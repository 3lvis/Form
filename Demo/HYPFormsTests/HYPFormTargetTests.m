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
}

@end
