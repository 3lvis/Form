@import UIKit;
@import XCTest;

#import "HYPForm.h"
#import "HYPFormField.h"
#import "HYPFormTarget.h"
#import "HYPFormsCollectionViewDataSource.h"
#import "HYPFormsManager.h"

#import "HYPFormsManager+Tests.h"

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

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:layout];
    self.manager = [[HYPFormsManager alloc] initWithForms:[HYPFormsManager testForms] initialValues:nil];
    self.dataSource = [[HYPFormsCollectionViewDataSource alloc] initWithCollectionView:collectionView andFormsManager:self.manager];
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
    HYPFormField *field = [HYPFormField fieldWithID:@"display_name" inForms:self.manager.forms withIndexPath:NO];
    NSUInteger index = [field indexInSectionUsingForms:self.manager.forms];
    XCTAssertEqual(index, 2);

    [self.dataSource processTarget:[HYPFormTarget hideFieldTargetWithID:@"username"]];
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"username"]];
    field = [HYPFormField fieldWithID:@"username" inForms:self.manager.forms withIndexPath:NO];
    index = [field indexInSectionUsingForms:self.manager.forms];
    XCTAssertEqual(index, 2);

    [self.dataSource processTargets:[HYPFormTarget hideFieldTargetsWithIDs:@[@"first_name", @"address", @"username"]]];
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"username"]];
    field = [HYPFormField fieldWithID:@"username" inForms:self.manager.forms withIndexPath:NO];
    index = [field indexInSectionUsingForms:self.manager.forms];
    XCTAssertEqual(index, 1);
    [self.dataSource processTargets:[HYPFormTarget showFieldTargetsWithIDs:@[@"first_name", @"address"]]];

    [self.dataSource processTargets:[HYPFormTarget hideFieldTargetsWithIDs:@[@"last_name", @"address"]]];
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"address"]];
    field = [HYPFormField fieldWithID:@"address" inForms:self.manager.forms withIndexPath:NO];
    index = [field indexInSectionUsingForms:self.manager.forms];
    XCTAssertEqual(index, 0);
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"last_name"]];
}

- (void)testFieldWithIDWithIndexPath
{
    HYPFormField *firstNameField = [self.dataSource fieldWithID:@"first_name" withIndexPath:YES];
    XCTAssertNotNil(firstNameField);
    XCTAssertEqualObjects(firstNameField.fieldID, @"first_name");

    [self.dataSource processTarget:[HYPFormTarget hideFieldTargetWithID:@"start_date"]];
    HYPFormField *startDateField = [self.dataSource fieldWithID:@"start_date" withIndexPath:YES];
    XCTAssertNotNil(startDateField);
    XCTAssertEqualObjects(startDateField.fieldID, @"start_date");
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"start_date"]];

    [self.dataSource processTarget:[HYPFormTarget hideSectionTargetWithID:@"employment-1"]];
    HYPFormField *contractTypeField = [self.dataSource fieldWithID:@"contract_type" withIndexPath:YES];
    XCTAssertNotNil(contractTypeField);
    XCTAssertEqualObjects(contractTypeField.fieldID, @"contract_type");
    [self.dataSource processTarget:[HYPFormTarget showSectionTargetWithID:@"employment-1"]];
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
