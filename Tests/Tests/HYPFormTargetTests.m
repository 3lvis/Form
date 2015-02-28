@import XCTest;

#import "FORMTarget.h"

@interface FORMTargetTests : XCTestCase

@end

@implementation FORMTargetTests

- (void)testInitWithDictionary
{
    FORMTarget *target = [[FORMTarget alloc] initWithDictionary:@{@"id": @"start_date",
                                                                  @"type": @"field",
                                                                  @"action": @"show"}];
    XCTAssertNotNil(target);
    XCTAssertEqualObjects(target.targetID, @"start_date");
    XCTAssertEqualObjects(target.typeString, @"field");
    XCTAssertEqualObjects(target.actionTypeString, @"show");
    XCTAssertTrue(target.type == FORMTargetTypeField);
    XCTAssertTrue(target.actionType == FORMTargetActionShow);

    target = [[FORMTarget alloc] initWithDictionary:@{@"id": @"section_id",
                                                      @"type": @"section",
                                                      @"action": @"hide"}];
    XCTAssertNotNil(target);
    XCTAssertEqualObjects(target.targetID, @"section_id");
    XCTAssertEqualObjects(target.typeString, @"section");
    XCTAssertEqualObjects(target.actionTypeString, @"hide");
    XCTAssertTrue(target.type == FORMTargetTypeSection);
    XCTAssertTrue(target.actionType == FORMTargetActionHide);

    target = [[FORMTarget alloc] initWithDictionary:@{@"id": @"first_name",
                                                      @"type": @"field",
                                                      @"action": @"disable"}];
    XCTAssertNotNil(target);
    XCTAssertEqualObjects(target.targetID, @"first_name");
    XCTAssertEqualObjects(target.typeString, @"field");
    XCTAssertEqualObjects(target.actionTypeString, @"disable");
    XCTAssertTrue(target.type == FORMTargetTypeField);
    XCTAssertTrue(target.actionType == FORMTargetActionDisable);

    target = [[FORMTarget alloc] initWithDictionary:@{@"id": @"last_name",
                                                      @"type": @"field",
                                                      @"action": @"enable"}];
    XCTAssertNotNil(target);
    XCTAssertEqualObjects(target.targetID, @"last_name");
    XCTAssertEqualObjects(target.typeString, @"field");
    XCTAssertEqualObjects(target.actionTypeString, @"enable");
    XCTAssertTrue(target.type == FORMTargetTypeField);
    XCTAssertTrue(target.actionType == FORMTargetActionEnable);
}

- (void)testFilteredTargets
{
    NSMutableArray *targets = [NSMutableArray new];

    [targets addObject:[FORMTarget showFieldTargetWithID:@"first_name"]];
    [targets addObject:[FORMTarget showFieldTargetWithID:@"first_name"]];
    [targets addObject:[FORMTarget showFieldTargetWithID:@"first_name"]];

    [targets addObject:[FORMTarget hideFieldTargetWithID:@"last_name"]];
    [targets addObject:[FORMTarget hideFieldTargetWithID:@"last_name"]];
    [targets addObject:[FORMTarget hideFieldTargetWithID:@"last_name"]];

    [targets addObject:[FORMTarget enableFieldTargetWithID:@"start_date"]];
    [targets addObject:[FORMTarget enableFieldTargetWithID:@"start_date"]];
    [targets addObject:[FORMTarget enableFieldTargetWithID:@"start_date"]];

    [targets addObject:[FORMTarget disableFieldTargetWithID:@"end_date"]];
    [targets addObject:[FORMTarget disableFieldTargetWithID:@"end_date"]];
    [targets addObject:[FORMTarget disableFieldTargetWithID:@"end_date"]];

    [targets addObject:[FORMTarget disableFieldTargetWithID:@"end_date"]];
    [targets addObject:[FORMTarget disableFieldTargetWithID:@"end_date"]];
    [targets addObject:[FORMTarget disableFieldTargetWithID:@"end_date"]];

    [targets addObject:[FORMTarget updateFieldTargetWithID:@"bonus_enabled"]];
    [targets addObject:[FORMTarget updateFieldTargetWithID:@"bonus_enabled"]];
    [targets addObject:[FORMTarget updateFieldTargetWithID:@"bonus_enabled"]];

    [targets addObject:[FORMTarget clearFieldTargetWithID:@"salary"]];
    [targets addObject:[FORMTarget clearFieldTargetWithID:@"salary"]];
    [targets addObject:[FORMTarget clearFieldTargetWithID:@"salary"]];

    [FORMTarget filteredTargets:targets
                       filtered:^(NSArray *shownTargets, NSArray *hiddenTargets, NSArray *updatedTargets,
                                  NSArray *enabledTargets, NSArray *disabledTargets) {
                           XCTAssertEqual(shownTargets.count, 1);
                           XCTAssertEqual(hiddenTargets.count, 1);
                           XCTAssertEqual(updatedTargets.count, 2);
                           XCTAssertEqual(enabledTargets.count, 1);
                           XCTAssertEqual(disabledTargets.count, 1);
                       }];

}

@end
