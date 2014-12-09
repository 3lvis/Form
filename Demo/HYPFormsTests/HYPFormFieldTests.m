@import XCTest;

#import "HYPFormsManager.h"
#import "HYPFormField.h"
#import "HYPFormSection.h"
#import "HYPFormsLayout.h"
#import "HYPFormsCollectionViewDataSource.h"

#import "HYPFormsManager+Tests.h"

@interface HYPFormFieldTests : XCTestCase <HYPFormsLayoutDataSource>

@property (nonatomic, strong) HYPFormsManager *manager;
@property (nonatomic, strong) HYPFormsCollectionViewDataSource *dataSource;

@end

@implementation HYPFormFieldTests

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

- (void)testFieldWithID
{
    NSDictionary *values = @{@"first_name" : @"Elvis", @"last_name" : @"Nunez"};

    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithForms:[HYPFormsManager testForms]
                                                        initialValues:values];

    HYPFormField *field = [manager fieldWithID:@"first_name" withIndexPath:NO];
    XCTAssertEqualObjects(field.fieldID, @"first_name");

    [field sectionAndIndexInForms:manager.forms completion:^(BOOL found, HYPFormSection *section, NSInteger index) {
        if (found) {
            [section.fields removeObjectAtIndex:index];
        }
    }];

    field = [manager fieldWithID:@"first_name" withIndexPath:NO];

    XCTAssertNil(field);
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
