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
    HYPFormField *field = [HYPFormField fieldWithID:@"first_name" inForms:self.dataSource.forms withIndexPath:NO];
    NSUInteger index = [field indexInForms:self.dataSource.forms];
    XCTAssertEqual(index, 0);

    field = [HYPFormField fieldWithID:@"image" inForms:self.dataSource.forms withIndexPath:NO];
    index = [field indexInForms:self.dataSource.forms];
    XCTAssertEqual(index, 11);

    HYPFormTarget *target = [HYPFormTarget new];
    target.targetID = @"image";
    target.typeString = @"field";
    target.actionTypeString = @"hide";

    [self.dataSource processTargets:@[target]];

    field = [HYPFormField fieldWithID:@"image" inForms:self.dataSource.forms withIndexPath:NO];
    XCTAssertNil(field);

    target = [HYPFormTarget new];
    target.targetID = @"image";
    target.typeString = @"field";
    target.actionTypeString = @"show";
    [self.dataSource processTargets:@[target]];

    field = [HYPFormField fieldWithID:@"image" inForms:self.dataSource.forms withIndexPath:NO];
    index = [field indexInForms:self.dataSource.forms];
    XCTAssertEqual(index, 11);
}

- (void)testFieldIndexInFormsLastFieldWithTwoInTheMiddleRemoved
{
    HYPFormField *field = [HYPFormField fieldWithID:@"image" inForms:self.dataSource.forms withIndexPath:NO];
    NSUInteger index = [field indexInForms:self.dataSource.forms];
    XCTAssertEqual(index, 11);

    HYPFormTarget *target = [HYPFormTarget new];
    target.targetID = @"image";
    target.typeString = @"field";
    target.actionTypeString = @"hide";

    HYPFormTarget *target1 = [HYPFormTarget new];
    target1.targetID = @"first_name";
    target1.typeString = @"field";
    target1.actionTypeString = @"hide";

    HYPFormTarget *target2 = [HYPFormTarget new];
    target2.targetID = @"address";
    target2.typeString = @"field";
    target2.actionTypeString = @"hide";

    [self.dataSource processTargets:@[target, target1, target2]];

    field = [HYPFormField fieldWithID:@"image" inForms:self.dataSource.forms withIndexPath:NO];
    XCTAssertNil(field);

    target = [HYPFormTarget new];
    target.targetID = @"image";
    target.typeString = @"field";
    target.actionTypeString = @"show";
    [self.dataSource processTargets:@[target]];

    field = [HYPFormField fieldWithID:@"image" inForms:self.dataSource.forms withIndexPath:NO];
    index = [field indexInForms:self.dataSource.forms];
    XCTAssertEqual(index, 9);
}

@end
