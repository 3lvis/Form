@import XCTest;

#import "HYPForm.h"
#import "HYPFormField.h"
#import "HYPFormTarget.h"
#import "HYPFormsCollectionViewDataSource.h"

@interface HYPFormTests : XCTestCase

@property (nonatomic, strong) HYPFormsCollectionViewDataSource *dataSource;

@end

@implementation HYPFormTests

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

- (void)testFieldWithID
{
    HYPFormField *field = [HYPFormField fieldWithID:@"first_name" inForms:self.dataSource.forms withIndexPath:NO];
    XCTAssertEqualObjects(field.fieldID, @"first_name");

    [field sectionAndIndexInForms:self.dataSource.forms completion:^(BOOL found, HYPFormSection *section, NSInteger index) {
        if (found) {
            [section.fields removeObjectAtIndex:index];
        }
    }];

    field = [HYPFormField fieldWithID:@"first_name" inForms:self.dataSource.forms withIndexPath:NO];
    XCTAssertNil(field);
}

@end
