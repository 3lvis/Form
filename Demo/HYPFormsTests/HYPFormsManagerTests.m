@import XCTest;

#import "HYPFormsManager.h"

#import "HYPForm.h"
#import "HYPFormSection.h"
#import "HYPFormField.h"
#import "HYPFormTarget.h"
#import "HYPFieldValidation.h"

#import "HYPFormsManager+Tests.h"
#import "NSDictionary+ANDYSafeValue.h"

@interface HYPFormsManagerTests : XCTestCase

@end

@implementation HYPFormsManagerTests

- (void)testFormsGenerationOnlyJSON
{
    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithForms:[HYPFormsManager testForms]
                                                        initialValues:nil];

    XCTAssertNotNil(manager.forms);

    XCTAssertTrue(manager.forms.count > 0);

    XCTAssertTrue(manager.hiddenFields.count == 0);

    XCTAssertTrue(manager.hiddenSections.count == 0);
}

- (void)testFormsGenerationFieldsWithFormulas
{
    NSDictionary *values = @{@"first_name" : @"Elvis", @"last_name" : @"Nunez"};

    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithForms:[HYPFormsManager testForms]
                                                        initialValues:values];

    HYPFormField *displayNameField = [HYPFormField fieldWithID:@"display_name" inForms:manager.forms withIndexPath:NO];

    XCTAssertEqualObjects(displayNameField.fieldValue, @"Elvis Nunez");
}

- (void)testFormsGenerationHideTargets
{
    NSDictionary *values = @{@"contract_type" : @1};

    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithForms:[HYPFormsManager testForms]
                                                        initialValues:values];

    XCTAssertTrue(manager.hiddenFields.count > 0);

    XCTAssertTrue(manager.hiddenSections.count > 0);
}

- (void)testRequiredFields
{
    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithForms:[HYPFormsManager testForms]
                                                        initialValues:nil];

    NSDictionary *requiredFormFields = [manager requiredFormFields];

    XCTAssertTrue([requiredFormFields andy_valueForKey:@"first_name"]);

    XCTAssertTrue([requiredFormFields andy_valueForKey:@"last_name"]);

    XCTAssertNil([requiredFormFields andy_valueForKey:@"address"]);
}

- (void)testFieldValidation
{
    NSDictionary *values = @{@"first_name" : @"Elvis", @"last_name" : @"Nunez"};

    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithForms:[HYPFormsManager testForms]
                                                        initialValues:values];

    NSArray *fields = [manager invalidFormFields];

    XCTAssertTrue(fields.count == 1);

    XCTAssertEqualObjects([[fields firstObject] fieldID], @"email");
}

@end
