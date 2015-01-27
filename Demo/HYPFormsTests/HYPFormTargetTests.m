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

- (void)testFilteredTargets
{
    NSMutableArray *targets = [NSMutableArray new];

    [targets addObject:[HYPFormTarget showFieldTargetWithID:@"first_name"]];
    [targets addObject:[HYPFormTarget showFieldTargetWithID:@"first_name"]];
    [targets addObject:[HYPFormTarget showFieldTargetWithID:@"first_name"]];

    [targets addObject:[HYPFormTarget hideFieldTargetWithID:@"last_name"]];
    [targets addObject:[HYPFormTarget hideFieldTargetWithID:@"last_name"]];
    [targets addObject:[HYPFormTarget hideFieldTargetWithID:@"last_name"]];

    [targets addObject:[HYPFormTarget enableFieldTargetWithID:@"start_date"]];
    [targets addObject:[HYPFormTarget enableFieldTargetWithID:@"start_date"]];
    [targets addObject:[HYPFormTarget enableFieldTargetWithID:@"start_date"]];

    [targets addObject:[HYPFormTarget disableFieldTargetWithID:@"end_date"]];
    [targets addObject:[HYPFormTarget disableFieldTargetWithID:@"end_date"]];
    [targets addObject:[HYPFormTarget disableFieldTargetWithID:@"end_date"]];

    [targets addObject:[HYPFormTarget disableFieldTargetWithID:@"end_date"]];
    [targets addObject:[HYPFormTarget disableFieldTargetWithID:@"end_date"]];
    [targets addObject:[HYPFormTarget disableFieldTargetWithID:@"end_date"]];

    [targets addObject:[HYPFormTarget updateFieldTargetWithID:@"bonus_enabled"]];
    [targets addObject:[HYPFormTarget updateFieldTargetWithID:@"bonus_enabled"]];
    [targets addObject:[HYPFormTarget updateFieldTargetWithID:@"bonus_enabled"]];

    [HYPFormTarget filteredTargets:targets
                          filtered:^(NSArray *shownTargets, NSArray *hiddenTargets, NSArray *updatedTargets,
                                     NSArray *enabledTargets, NSArray *disabledTargets) {
                              XCTAssertEqual(shownTargets.count, 1);
                              XCTAssertEqual(hiddenTargets.count, 1);
                              XCTAssertEqual(updatedTargets.count, 1);
                              XCTAssertEqual(enabledTargets.count, 1);
                              XCTAssertEqual(disabledTargets.count, 1);
                          }];

}

@end
