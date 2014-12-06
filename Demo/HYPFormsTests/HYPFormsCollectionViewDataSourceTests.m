@import UIKit;
@import XCTest;

#import "HYPForm.h"
#import "HYPFormField.h"
#import "HYPFormTarget.h"
#import "HYPFormsCollectionViewDataSource.h"
#import "HYPFormsManager.h"

#import "HYPFormsManager+Tests.h"

@interface HYPFormsCollectionViewDataSourceTests : XCTestCase

@end

@implementation HYPFormsCollectionViewDataSourceTests


- (void)testIndexInForms
{
    HYPFormsLayout *layout = [[HYPFormsLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:layout];
    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithForms:[HYPFormsManager testForms] initialValues:nil];
    HYPFormsCollectionViewDataSource *dataSource = [[HYPFormsCollectionViewDataSource alloc] initWithCollectionView:collectionView andFormsManager:manager];

    [dataSource processTarget:[HYPFormTarget hideFieldTargetWithID:@"postal_code"]];
    [dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"postal_code"]];
    HYPFormField *field = [HYPFormField fieldWithID:@"postal_code" inForms:manager.forms withIndexPath:NO];
    NSUInteger index = [field indexInForms:manager.forms];
    XCTAssertEqual(index, 6);

    [dataSource processTarget:[HYPFormTarget hideFieldTargetWithID:@"image"]];
    [dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"image"]];
    field = [HYPFormField fieldWithID:@"image" inForms:manager.forms withIndexPath:NO];
    index = [field indexInForms:manager.forms];
    XCTAssertEqual(index, 11);

    [dataSource processTargets:[HYPFormTarget hideFieldTargetsWithIDs:@[@"first_name", @"address", @"image"]]];
    [dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"image"]];
    field = [HYPFormField fieldWithID:@"image" inForms:manager.forms withIndexPath:NO];
    index = [field indexInForms:manager.forms];
    XCTAssertEqual(index, 9);
    [dataSource processTargets:[HYPFormTarget showFieldTargetsWithIDs:@[@"first_name", @"address"]]];

    [dataSource processTargets:[HYPFormTarget hideFieldTargetsWithIDs:@[@"last_name", @"address"]]];
    [dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"address"]];
    field = [HYPFormField fieldWithID:@"address" inForms:manager.forms withIndexPath:NO];
    index = [field indexInForms:manager.forms];
    XCTAssertEqual(index, 4);
    [dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"last_name"]];
}

- (void)testFieldWithIDWithIndexPath
{
    HYPFormsLayout *layout = [[HYPFormsLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:layout];
    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithForms:[HYPFormsManager testForms] initialValues:nil];
    HYPFormsCollectionViewDataSource *dataSource = [[HYPFormsCollectionViewDataSource alloc] initWithCollectionView:collectionView andFormsManager:manager];

    HYPFormField *firstNameField = [dataSource fieldWithID:@"first_name" withIndexPath:YES];
    XCTAssertNotNil(firstNameField);
    XCTAssertEqualObjects(firstNameField.fieldID, @"first_name");

    [dataSource processTarget:[HYPFormTarget hideFieldTargetWithID:@"student"]];
    HYPFormField *studentField = [dataSource fieldWithID:@"student" withIndexPath:YES];
    XCTAssertNotNil(studentField);
    XCTAssertEqualObjects(studentField.fieldID, @"student");
    [dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"student"]];

    [dataSource processTarget:[HYPFormTarget hideSectionTargetWithID:@"ansettelsesforhold-1"]];
    HYPFormField *temporaryEmployeeTypeField = [dataSource fieldWithID:@"temporary_employee_type" withIndexPath:YES];
    XCTAssertNotNil(temporaryEmployeeTypeField);
    XCTAssertEqualObjects(temporaryEmployeeTypeField.fieldID, @"temporary_employee_type");
    [dataSource processTarget:[HYPFormTarget showSectionTargetWithID:@"ansettelsesforhold-1"]];
}

- (void)testFieldValidation
{
    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithForms:[HYPFormsManager testForms] initialValues:nil];

    NSArray *fields = [manager invalidFormFields];

    XCTAssertNotNil(fields);
}

@end
