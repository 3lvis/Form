@import UIKit;
@import XCTest;

#import "HYPForm.h"
#import "HYPFormField.h"
#import "HYPFormTarget.h"
#import "HYPFormsCollectionViewDataSource.h"

@interface HYPFormsTests : XCTestCase

@property (nonatomic, strong) HYPFormsCollectionViewDataSource *dataSource;

@end

@implementation HYPFormsTests

- (void)setUp
{
    [super setUp];

    HYPFormsLayout *layout = [[HYPFormsLayout alloc] init];

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:layout];

    self.dataSource = [[HYPFormsCollectionViewDataSource alloc] initWithCollectionView:collectionView andDictionary:nil disabledFieldsIDs:nil disabled:NO];
}

- (void)tearDown
{
    [super tearDown];

    self.dataSource = nil;
}

- (void)testFieldIndexInFormsLastField
{
    [self.dataSource processTargets:@[[HYPFormTarget hideFieldTargetWithID:@"image"]]];

    [self.dataSource processTargets:@[[HYPFormTarget showFieldTargetWithID:@"image"]]];

    HYPFormField *field = [HYPFormField fieldWithID:@"image" inForms:self.dataSource.forms withIndexPath:NO];
    NSUInteger index = [field indexInForms:self.dataSource.forms];
    XCTAssertEqual(index, 11);
}

- (void)testFieldIndexInFormsLastFieldWithTwoInTheMiddleRemoved
{
    [self.dataSource processTargets:[HYPFormTarget hideFieldTargetsWithIDs:@[@"image", @"first_name", @"address"]]];

    [self.dataSource processTargets:@[[HYPFormTarget showFieldTargetWithID:@"image"]]];

    HYPFormField *field = [HYPFormField fieldWithID:@"image" inForms:self.dataSource.forms withIndexPath:NO];
    NSUInteger index = [field indexInForms:self.dataSource.forms];
    XCTAssertEqual(index, 9);
}

- (void)testFieldIndexInForms
{
    [self.dataSource processTargets:@[[HYPFormTarget hideFieldTargetWithID:@"last_name"], [HYPFormTarget hideFieldTargetWithID:@"address"]]];

    [self.dataSource processTargets:@[[HYPFormTarget showFieldTargetWithID:@"address"]]];

    HYPFormField *field = [HYPFormField fieldWithID:@"address" inForms:self.dataSource.forms withIndexPath:NO];
    NSUInteger index = [field indexInForms:self.dataSource.forms];
    XCTAssertEqual(index, 4);
}

@end
