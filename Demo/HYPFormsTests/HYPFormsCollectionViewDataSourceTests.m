@import UIKit;
@import XCTest;

#import "HYPFieldValidation.h"
#import "HYPForm.h"
#import "HYPFormField.h"
#import "HYPFormsCollectionViewDataSource.h"
#import "HYPFormSection.h"
#import "HYPFormsManager.h"
#import "HYPFormTarget.h"
#import "HYPImageFormFieldCell.h"
#import "HYPSampleCollectionViewController.h"

#import "NSJSONSerialization+ANDYJSONFile.h"

@interface HYPSampleCollectionViewController ()

@property (nonatomic, strong) HYPFormsCollectionViewDataSource *dataSource;

@end

@interface HYPFormsCollectionViewDataSourceTests : XCTestCase

@end

@implementation HYPFormsCollectionViewDataSourceTests

- (HYPSampleCollectionViewController *)controller
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];

    HYPSampleCollectionViewController *controller = [[HYPSampleCollectionViewController alloc] initWithJSON:JSON andInitialValues:@{}];

    return controller;
}

- (void)testIndexInForms
{
    HYPSampleCollectionViewController *controller = [self controller];

    [controller.dataSource processTarget:[HYPFormTarget hideFieldTargetWithID:@"display_name"]];
    [controller.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"display_name"]];
    HYPFormField *field = [controller.dataSource.formsManager fieldWithID:@"display_name" includingHiddenFields:YES];
    NSUInteger index = [field indexInSectionUsingForms:controller.dataSource.formsManager.forms];
    XCTAssertEqual(index, 2);

    [controller.dataSource processTarget:[HYPFormTarget hideFieldTargetWithID:@"username"]];
    [controller.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"username"]];
    field = [controller.dataSource.formsManager fieldWithID:@"username" includingHiddenFields:YES];
    index = [field indexInSectionUsingForms:controller.dataSource.formsManager.forms];
    XCTAssertEqual(index, 2);

    [controller.dataSource processTargets:[HYPFormTarget hideFieldTargetsWithIDs:@[@"first_name",
                                                                             @"address",
                                                                             @"username"]]];
    [controller.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"username"]];
    field = [controller.dataSource.formsManager fieldWithID:@"username" includingHiddenFields:YES];
    index = [field indexInSectionUsingForms:controller.dataSource.formsManager.forms];
    XCTAssertEqual(index, 1);
    [controller.dataSource processTargets:[HYPFormTarget showFieldTargetsWithIDs:@[@"first_name",
                                                                             @"address"]]];

    [controller.dataSource processTargets:[HYPFormTarget hideFieldTargetsWithIDs:@[@"last_name",
                                                                             @"address"]]];
    [controller.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"address"]];
    field = [controller.dataSource.formsManager fieldWithID:@"address" includingHiddenFields:YES];
    index = [field indexInSectionUsingForms:controller.dataSource.formsManager.forms];
    XCTAssertEqual(index, 0);
    [controller.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"last_name"]];
}

- (void)testEnableAndDisableTargets
{
    HYPSampleCollectionViewController *controller = [self controller];
    [controller.dataSource enable];

    HYPFormField *targetField = [controller.dataSource.formsManager fieldWithID:@"base_salary" includingHiddenFields:YES];
    XCTAssertFalse(targetField.isDisabled);

    HYPFormTarget *disableTarget = [HYPFormTarget disableFieldTargetWithID:@"base_salary"];
    [controller.dataSource processTarget:disableTarget];
    XCTAssertTrue(targetField.isDisabled);

    HYPFormTarget *enableTarget = [HYPFormTarget enableFieldTargetWithID:@"base_salary"];
    [controller.dataSource processTargets:@[enableTarget]];
    XCTAssertFalse(targetField.isDisabled);

    [controller.dataSource disable];
    XCTAssertTrue(targetField.isDisabled);

    [controller.dataSource enable];
    XCTAssertFalse(targetField.isDisabled);
}

- (void)testInitiallyDisabled
{
    HYPSampleCollectionViewController *controller = [self controller];

    HYPFormField *totalField = [controller.dataSource.formsManager fieldWithID:@"total" includingHiddenFields:YES];
    XCTAssertTrue(totalField.disabled);
}

- (void)testUpdatingTargetValue
{
    HYPSampleCollectionViewController *controller = [self controller];

    HYPFormField *targetField = [controller.dataSource.formsManager fieldWithID:@"display_name" includingHiddenFields:YES];
    XCTAssertNil(targetField.fieldValue);

    HYPFormTarget *updateTarget = [HYPFormTarget updateFieldTargetWithID:@"display_name"];
    updateTarget.targetValue = @"John Hyperseed";

    [controller.dataSource processTarget:updateTarget];
    XCTAssertEqualObjects(targetField.fieldValue, @"John Hyperseed");
}

- (void)testDefaultValue
{
    HYPSampleCollectionViewController *controller = [self controller];

    HYPFormField *usernameField = [controller.dataSource.formsManager fieldWithID:@"username" includingHiddenFields:YES];
    XCTAssertNotNil(usernameField.fieldValue);
}

- (void)testCondition
{
    HYPSampleCollectionViewController *controller = [self controller];

    HYPFormField *displayNameField = [controller.dataSource.formsManager fieldWithID:@"display_name" includingHiddenFields:YES];
    HYPFormField *usernameField = [controller.dataSource.formsManager fieldWithID:@"username" includingHiddenFields:YES];
    HYPFieldValue *fieldValue = usernameField.fieldValue;
    XCTAssertEqualObjects(fieldValue.valueID, @0);

    HYPFormTarget *updateTarget = [HYPFormTarget updateFieldTargetWithID:@"display_name"];
    updateTarget.targetValue = @"Mr.Melk";

    updateTarget.condition = @"$username == 2";
    [controller.dataSource processTarget:updateTarget];
    XCTAssertNil(displayNameField.fieldValue);

    updateTarget.condition = @"$username == 0";
    [controller.dataSource processTarget:updateTarget];
    XCTAssertEqualObjects(displayNameField.fieldValue, @"Mr.Melk");
}

- (void)testReloadWithDictionary
{
    HYPSampleCollectionViewController *controller = [self controller];

    [controller.dataSource reloadWithDictionary:@{@"first_name" : @"Elvis",
                                            @"last_name" : @"Nunez"}];

    HYPFormField *field = [controller.dataSource.formsManager fieldWithID:@"display_name" includingHiddenFields:YES];
    XCTAssertEqualObjects(field.fieldValue, @"Elvis Nunez");
}

- (void)testClearTarget
{
    HYPSampleCollectionViewController *controller = [self controller];

    HYPFormField *firstNameField = [controller.dataSource.formsManager fieldWithID:@"first_name" includingHiddenFields:YES];
    XCTAssertNotNil(firstNameField);

    firstNameField.fieldValue = @"John";
    XCTAssertNotNil(firstNameField.fieldValue);

    HYPFormTarget *clearTarget = [HYPFormTarget clearFieldTargetWithID:@"first_name"];
    [controller.dataSource processTarget:clearTarget];
    XCTAssertNil(firstNameField.fieldValue);
}

@end
