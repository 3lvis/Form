@import XCTest;

#import "HYPFormsManager.h"

#import "HYPForm.h"
#import "HYPFormSection.h"
#import "HYPFormField.h"
#import "HYPFormTarget.h"
#import "HYPFieldValidation.h"
#import "HYPFormsCollectionViewDataSource.h"

#import "NSDictionary+ANDYSafeValue.h"
#import "NSJSONSerialization+ANDYJSONFile.h"

@interface HYPFormsManagerTests : XCTestCase

@property (nonatomic, strong) HYPFormsManager *manager;
@property (nonatomic, strong) HYPFormsCollectionViewDataSource *dataSource;

@end

@implementation HYPFormsManagerTests

- (void)testFormsGenerationOnlyJSON
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];
    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON
                                                       initialValues:nil
                                                    disabledFieldIDs:nil
                                                            disabled:NO];

    XCTAssertNotNil(manager.forms);

    XCTAssertTrue(manager.forms.count > 0);

    XCTAssertTrue(manager.hiddenFields.count == 0);

    XCTAssertTrue(manager.hiddenSections.count == 0);
}

- (void)testFormsGenerationFieldsWithFormulas
{
    NSDictionary *values = @{@"first_name" : @"Elvis", @"last_name" : @"Nunez"};

    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];
    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON
                                                       initialValues:values
                                                    disabledFieldIDs:nil
                                                            disabled:NO];

    HYPFormField *displayNameField = [manager fieldWithID:@"display_name"];

    XCTAssertEqualObjects(displayNameField.fieldValue, @"Elvis Nunez");
}

- (void)testFormsGenerationHideTargets
{
    NSDictionary *values = @{@"contract_type" : @1};

    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];
    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON
                                                       initialValues:values
                                                    disabledFieldIDs:nil
                                                            disabled:NO];

    XCTAssertTrue(manager.hiddenFields.count > 0);

    XCTAssertTrue(manager.hiddenSections.count > 0);
}

- (void)testRequiredFields
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];
    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON
                                                       initialValues:nil
                                                    disabledFieldIDs:nil
                                                            disabled:NO];

    NSDictionary *requiredFormFields = [manager requiredFormFields];

    XCTAssertTrue([requiredFormFields andy_valueForKey:@"first_name"]);

    XCTAssertTrue([requiredFormFields andy_valueForKey:@"last_name"]);

    XCTAssertNil([requiredFormFields andy_valueForKey:@"address"]);
}

- (void)testFieldValidation
{
    NSDictionary *values = @{@"first_name" : @"Elvis", @"last_name" : @"Nunez"};

    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];
    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON
                                                       initialValues:values
                                                    disabledFieldIDs:nil
                                                            disabled:NO];

    NSArray *fields = [manager invalidFormFields];

    XCTAssertTrue(fields.count == 1);

    XCTAssertEqualObjects([[fields firstObject] fieldID], @"email");
}

- (void)testFieldWithIDWithIndexPath
{
    NSDictionary *values = @{@"first_name" : @"Elvis", @"last_name" : @"Nunez"};

    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];
    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON
                                                       initialValues:values
                                                    disabledFieldIDs:nil
                                                            disabled:NO];

    HYPFormField *firstNameField = [manager fieldWithID:@"first_name"];
    XCTAssertNotNil(firstNameField);
    XCTAssertEqualObjects(firstNameField.fieldID, @"first_name");

    [self.dataSource processTarget:[HYPFormTarget hideFieldTargetWithID:@"start_date"]];
    HYPFormField *startDateField = [manager fieldWithID:@"start_date"];
    XCTAssertNotNil(startDateField);
    XCTAssertEqualObjects(startDateField.fieldID, @"start_date");
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"start_date"]];

    [self.dataSource processTarget:[HYPFormTarget hideSectionTargetWithID:@"employment-1"]];
    HYPFormField *contractTypeField = [manager fieldWithID:@"contract_type"];
    XCTAssertNotNil(contractTypeField);
    XCTAssertEqualObjects(contractTypeField.fieldID, @"contract_type");
    [self.dataSource processTarget:[HYPFormTarget showSectionTargetWithID:@"employment-1"]];
}

@end
