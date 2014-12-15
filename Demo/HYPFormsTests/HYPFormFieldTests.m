@import XCTest;

#import "HYPFormsManager.h"
#import "HYPFormField.h"
#import "HYPFormSection.h"
#import "HYPFormsLayout.h"
#import "HYPFormsCollectionViewDataSource.h"
#import "NSJSONSerialization+ANDYJSONFile.h"

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
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];
    self.manager = [[HYPFormsManager alloc] initWithJSON:JSON
                                           initialValues:nil
                                        disabledFieldIDs:nil
                                                disabled:NO];
    self.dataSource = [[HYPFormsCollectionViewDataSource alloc] initWithCollectionView:collectionView andFormsManager:self.manager];
}

- (void)tearDown
{
    self.manager = nil;
    self.dataSource = nil;

    [super tearDown];
}

- (void)testInitWithDictionary
{
    NSDictionary *firstNameDictionary = @{@"id": @"first_name",
                                 @"title": @"First name",
                                 @"type": @"name",
                                 @"size": @{@"width": @30, @"height": @1},
                                 @"validations": @{@"required": @YES, @"min_length": @2}
                                 };

    HYPFormField *firstNameField = [[HYPFormField alloc] initWithDictionary:firstNameDictionary
                                                          position:0
                                                          disabled:NO
                                                 disabledFieldsIDs:nil];

    XCTAssertNotNil(firstNameField);
    XCTAssertEqualObjects(firstNameField.position, @0);
    XCTAssertEqualObjects(firstNameField.fieldID, @"first_name");
    XCTAssertEqualObjects(firstNameField.title, @"First name");
    XCTAssertEqualObjects(firstNameField.typeString, @"name");
    XCTAssertTrue(firstNameField.type == HYPFormFieldTypeText);
    XCTAssertTrue(CGSizeEqualToSize(firstNameField.size, CGSizeMake(30, 1)));
    XCTAssertFalse(firstNameField.disabled);
    XCTAssertNotNil(firstNameField.validations);

    NSDictionary *startDateDictionary = @{@"id": @"start_date",
                                          @"title": @"Start date",
                                          @"type": @"date",
                                          @"size": @{@"width": @10, @"height": @4}
                                          };

    HYPFormField *startDateField = [[HYPFormField alloc] initWithDictionary:startDateDictionary
                                                                   position:1
                                                                   disabled:NO
                                                          disabledFieldsIDs:@[@"start_date"]];

    XCTAssertNotNil(startDateField);
    XCTAssertEqualObjects(startDateField.position, @1);
    XCTAssertEqualObjects(startDateField.fieldID, @"start_date");
    XCTAssertEqualObjects(startDateField.title, @"Start date");
    XCTAssertEqualObjects(startDateField.typeString, @"date");
    XCTAssertTrue(startDateField.type == HYPFormFieldTypeDate);
    XCTAssertTrue(CGSizeEqualToSize(startDateField.size, CGSizeMake(10, 4)));
    XCTAssertTrue(startDateField.disabled);
    XCTAssertNil(startDateField.validations);
}

- (void)testFieldWithID
{
    NSDictionary *values = @{@"first_name" : @"Elvis", @"last_name" : @"Nunez"};

    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];
    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON
                                           initialValues:values
                                        disabledFieldIDs:nil
                                                disabled:NO];

    HYPFormField *field = [manager fieldWithID:@"first_name" includingHiddenFields:YES];
    XCTAssertEqualObjects(field.fieldID, @"first_name");

    [manager indexForFieldWithID:field.fieldID
                 inSectionWithID:field.section.sectionID
                      completion:^(HYPFormSection *section, NSInteger index) {
                          if (section) {
                              [section.fields removeObjectAtIndex:index];
                          }
                      }];

    field = [manager fieldWithID:@"first_name" includingHiddenFields:YES];

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
