@import XCTest;

#import "FORMTarget.h"

@interface FORMTargetTests : XCTestCase

@end

@implementation FORMTargetTests

- (void)testInitWithDictionary {
    FORMTarget *target = [FORMTarget showFieldTargetWithID:@"start_date"];
    XCTAssertNotNil(target);
    XCTAssertEqualObjects(target.targetID, @"start_date");
    XCTAssertEqualObjects(target.typeString, @"field");
    XCTAssertEqualObjects(target.actionTypeString, @"show");
    XCTAssertEqual(target.type, FORMTargetTypeField);
    XCTAssertEqual(target.actionType, FORMTargetActionShow);

    target = [FORMTarget hideSectionTargetWithID:@"section_id"];
    XCTAssertNotNil(target);
    XCTAssertEqualObjects(target.targetID, @"section_id");
    XCTAssertEqualObjects(target.typeString, @"section");
    XCTAssertEqualObjects(target.actionTypeString, @"hide");
    XCTAssertEqual(target.type, FORMTargetTypeSection);
    XCTAssertEqual(target.actionType, FORMTargetActionHide);

    target = [FORMTarget disableFieldTargetWithID:@"first_name"];
    XCTAssertNotNil(target);
    XCTAssertEqualObjects(target.targetID, @"first_name");
    XCTAssertEqualObjects(target.typeString, @"field");
    XCTAssertEqualObjects(target.actionTypeString, @"disable");
    XCTAssertEqual(target.type, FORMTargetTypeField);
    XCTAssertEqual(target.actionType, FORMTargetActionDisable);

    target = [FORMTarget enableFieldTargetWithID:@"last_name"];
    XCTAssertNotNil(target);
    XCTAssertEqualObjects(target.targetID, @"last_name");
    XCTAssertEqualObjects(target.typeString, @"field");
    XCTAssertEqualObjects(target.actionTypeString, @"enable");
    XCTAssertEqual(target.type, FORMTargetTypeField);
    XCTAssertEqual(target.actionType, FORMTargetActionEnable);
}

- (void)testFilteredTargets {
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

- (void)testFieldPropertiesToUpdate {
    NSDictionary *targetJSON = @{
                                 @"id": @"end_date",
                                 @"type": @"field",
                                 @"action": @"update",
                                 @"validations": @{ @"required": @NO },
                                 @"condition": @"$employment_type == 2 && !missing($temporary_employee_reason)"};

    FORMTarget *target = [[FORMTarget alloc] initWithDictionary:targetJSON];
    NSDictionary *fieldProperties = [target fieldPropertiesToUpdate];
    XCTAssertEqual(fieldProperties.count, 1);
    XCTAssertTrue([fieldProperties[@"validation"] isKindOfClass:[FORMFieldValidation class]]);

    targetJSON = @{
                   @"id": @"end_date",
                   @"type": @"field",
                   @"action": @"show",
                   @"validations": @{ @"required": @NO },
                   @"condition": @"$employment_type == 2 && !missing($temporary_employee_reason)"};

    target = [[FORMTarget alloc] initWithDictionary:targetJSON];
    fieldProperties = [target fieldPropertiesToUpdate];
    XCTAssertEqual(fieldProperties.count, 0);

    targetJSON = @{
                   @"id": @"end_date",
                   @"type": @"section",
                   @"action": @"update",
                   @"validations": @{ @"required": @NO },
                   @"condition": @"$employment_type == 2 && !missing($temporary_employee_reason)"};

    target = [[FORMTarget alloc] initWithDictionary:targetJSON];
    fieldProperties = [target fieldPropertiesToUpdate];
    XCTAssertEqual(fieldProperties.count, 0);
}

@end
