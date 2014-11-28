@import XCTest;

#import "HYPFormsManager.h"

#import "HYPForm.h"
#import "HYPFormField.h"

#import "NSJSONSerialization+ANDYJSONFile.h"

@interface HYPFormsManagerTests : XCTestCase

@end

@implementation HYPFormsManagerTests

- (void)testFormsGenerationOnlyJSON
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];

    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON initialValues:nil disabledFieldIDs:nil disabled:NO];

    XCTAssertNotNil(manager.forms);

    XCTAssertTrue(manager.forms.count > 0);

    XCTAssertTrue(manager.hiddenFields.count == 0);

    XCTAssertTrue(manager.hiddenSections.count == 0);
}

- (void)testFormsGenerationFieldsWithFormulas
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];

    NSDictionary *values = @{@"first_name" : @"Elvis", @"last_name" : @"Nunez"};

    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON initialValues:values disabledFieldIDs:nil disabled:NO];

    HYPFormField *displayNameField = [HYPFormField fieldWithID:@"display_name" inForms:manager.forms withIndexPath:NO];

    XCTAssertEqualObjects(displayNameField.fieldValue, @"Elvis Nunez");
}

- (void)testFormsGenerationHideTargets
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];

    NSDictionary *values = @{@"employment_type" : @1};

    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON initialValues:values disabledFieldIDs:nil disabled:NO];

    XCTAssertTrue(manager.hiddenFields.count > 0);

    XCTAssertTrue(manager.hiddenSections.count > 0);
}

@end
