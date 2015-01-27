@import UIKit;
@import XCTest;

#import "HYPFieldValidation.h"
#import "HYPForm.h"
#import "HYPFormField.h"
#import "HYPFormsCollectionViewDataSource.h"
#import "HYPFormSection.h"
#import "HYPFormsManager.h"
#import "HYPFormTarget.h"

#import "NSJSONSerialization+ANDYJSONFile.h"

@interface HYPFormsCollectionViewDataSourceTests : XCTestCase <HYPFormsLayoutDataSource>

@property (nonatomic, strong) HYPFormsManager *manager;
@property (nonatomic, strong) HYPFormsCollectionViewDataSource *dataSource;

@end

@implementation HYPFormsCollectionViewDataSourceTests

- (void)setUp
{
    [super setUp];

    HYPFormsLayout *layout = [[HYPFormsLayout alloc] init];
    layout.dataSource = self;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds]
                                                          collectionViewLayout:layout];

    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];

    self.manager = [[HYPFormsManager alloc] initWithJSON:JSON
                                           initialValues:nil
                                        disabledFieldIDs:nil
                                                disabled:NO];

    self.dataSource = [[HYPFormsCollectionViewDataSource alloc] initWithCollectionView:collectionView
                                                                       andFormsManager:self.manager];
}

- (void)tearDown
{
    self.manager = nil;
    self.dataSource = nil;

    [super tearDown];
}

- (void)testIndexInForms
{
    [self.dataSource processTarget:[HYPFormTarget hideFieldTargetWithID:@"display_name"]];
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"display_name"]];
    HYPFormField *field = [self.manager fieldWithID:@"display_name" includingHiddenFields:YES];
    NSUInteger index = [field indexInSectionUsingForms:self.manager.forms];
    XCTAssertEqual(index, 2);

    [self.dataSource processTarget:[HYPFormTarget hideFieldTargetWithID:@"username"]];
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"username"]];
    field = [self.manager fieldWithID:@"username" includingHiddenFields:YES];
    index = [field indexInSectionUsingForms:self.manager.forms];
    XCTAssertEqual(index, 2);

    [self.dataSource processTargets:[HYPFormTarget hideFieldTargetsWithIDs:@[@"first_name",
                                                                             @"address",
                                                                             @"username"]]];
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"username"]];
    field = [self.manager fieldWithID:@"username" includingHiddenFields:YES];
    index = [field indexInSectionUsingForms:self.manager.forms];
    XCTAssertEqual(index, 1);
    [self.dataSource processTargets:[HYPFormTarget showFieldTargetsWithIDs:@[@"first_name",
                                                                             @"address"]]];

    [self.dataSource processTargets:[HYPFormTarget hideFieldTargetsWithIDs:@[@"last_name",
                                                                             @"address"]]];
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"address"]];
    field = [self.manager fieldWithID:@"address" includingHiddenFields:YES];
    index = [field indexInSectionUsingForms:self.manager.forms];
    XCTAssertEqual(index, 0);
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"last_name"]];
}

- (void)testEnableAndDisableTargets
{
    HYPFormField *targetField = [self.manager fieldWithID:@"display_name" includingHiddenFields:YES];
    XCTAssertFalse(targetField.isDisabled);

    HYPFormTarget *disableTarget = [HYPFormTarget disableFieldTargetWithID:@"display_name"];
    [self.dataSource processTarget:disableTarget];
    XCTAssertTrue(targetField.isDisabled);

    HYPFormTarget *enableTarget = [HYPFormTarget enableFieldTargetWithID:@"display_name"];
    [self.dataSource processTargets:@[enableTarget]];
    XCTAssertFalse(targetField.isDisabled);

    [self.dataSource disable];
    XCTAssertTrue(targetField.isDisabled);

    [self.dataSource enable];
    XCTAssertFalse(targetField.isDisabled);
}

- (void)testInitiallyDisabled
{
    HYPFormField *totalField = [self.manager fieldWithID:@"total" includingHiddenFields:YES];
    XCTAssertTrue(totalField.disabled);
}

- (void)testUpdatingTargetValue
{
    HYPFormField *targetField = [self.manager fieldWithID:@"display_name" includingHiddenFields:YES];
    XCTAssertNil(targetField.fieldValue);

    HYPFormTarget *updateTarget = [HYPFormTarget updateFieldTargetWithID:@"display_name"];
    updateTarget.targetValue = @"John Hyperseed";
    
    [self.dataSource processTarget:updateTarget];
    XCTAssertEqualObjects(targetField.fieldValue, @"John Hyperseed");
}

- (void)testDefaultValue
{
    HYPFormField *usernameField = [self.manager fieldWithID:@"username" includingHiddenFields:YES];
    XCTAssertNotNil(usernameField.fieldValue);
}

- (void)testCondition
{
    HYPFormField *displayNameField = [self.manager fieldWithID:@"display_name" includingHiddenFields:YES];
    HYPFormField *usernameField = [self.manager fieldWithID:@"username" includingHiddenFields:YES];
    HYPFieldValue *fieldValue = usernameField.fieldValue;
    XCTAssertEqualObjects(fieldValue.valueID, @0);

    HYPFormTarget *updateTarget = [HYPFormTarget updateFieldTargetWithID:@"display_name"];
    updateTarget.targetValue = @"Mr.Melk";

    updateTarget.condition = @"$username == 2";
    [self.dataSource processTarget:updateTarget];
    XCTAssertNil(displayNameField.fieldValue);

    updateTarget.condition = @"$username == 0";
    [self.dataSource processTarget:updateTarget];
    XCTAssertEqualObjects(displayNameField.fieldValue, @"Mr.Melk");
}

#pragma mark - HYPFormsLayoutDataSource

- (NSArray *)forms
{
    return self.manager.forms;
}

- (NSArray *)collapsedForms
{
    return self.dataSource.collapsedForms;
}

@end
