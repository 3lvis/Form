@import XCTest;

#import "FORMData.h"

#import "FORMGroup.h"
#import "FORMSection.h"
#import "FORMField.h"
#import "FORMTarget.h"
#import "FORMFieldValidation.h"
#import "FORMDataSource.h"

#import "NSDictionary+ANDYSafeValue.h"
#import "NSJSONSerialization+ANDYJSONFile.h"

@interface FORMDataTests : XCTestCase

@end

@implementation FORMDataTests

- (void)testFormsGeneration
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *manager = [[FORMData alloc] initWithJSON:JSON
                                         initialValues:nil
                                      disabledFieldIDs:nil
                                              disabled:NO];

    XCTAssertNotNil(manager.forms);

    XCTAssertTrue(manager.forms.count > 0);

    XCTAssertTrue(manager.hiddenFieldsAndFieldIDsDictionary.count == 0);

    XCTAssertTrue(manager.hiddenSections.count == 0);
}

- (void)testDefaultValues
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"default-values.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    NSDate *date = [NSDate date];

    FORMData *manager = [[FORMData alloc] initWithJSON:JSON
                                         initialValues:@{@"contract_type" : [NSNull null],
                                                         @"start_date" : date,
                                                         @"base_salary": @2}
                                      disabledFieldIDs:nil
                                              disabled:NO];

    XCTAssertEqualObjects([manager.values objectForKey:@"contract_type"], @0);
    XCTAssertEqualObjects([manager.values objectForKey:@"start_date"], date);
    XCTAssertEqualObjects([manager.values objectForKey:@"base_salary"], @2);
}

- (void)testCalculatedValues
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"number-formula.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *manager = [[FORMData alloc] initWithJSON:JSON
                                         initialValues:@{@"base_salary" : @1,
                                                         @"bonus" : @100}
                                      disabledFieldIDs:nil
                                              disabled:NO];

    XCTAssertEqualObjects([manager.values objectForKey:@"base_salary"], @1);
    XCTAssertEqualObjects([manager.values objectForKey:@"bonus"], @100);
    XCTAssertEqualObjects([manager.values objectForKey:@"total"], @300);
}

- (void)testFormGenerationSectionPositions
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"section-field-position.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *manager = [[FORMData alloc] initWithJSON:JSON
                                         initialValues:nil
                                      disabledFieldIDs:nil
                                              disabled:NO];

    FORMSection *section = [manager sectionWithID:@"section-2"];
    XCTAssertNotNil(section);
    XCTAssertEqualObjects(section.position, @2);

    FORMField *field = [manager fieldWithID:@"section-0-field-3" includingHiddenFields:NO];
    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.position, @3);
}

- (void)testFormGenerationSectionPositionsWithHiddenTargets
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"section-field-position.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *manager = [[FORMData alloc] initWithJSON:JSON
                                         initialValues:@{@"section-0-field-0" : @0}
                                      disabledFieldIDs:nil
                                              disabled:NO];

    XCTAssertTrue(manager.hiddenFieldsAndFieldIDsDictionary.count > 0);
    XCTAssertTrue(manager.hiddenSections.count > 0);

    FORMSection *section = [manager sectionWithID:@"section-2"];
    FORMField *field = [manager fieldWithID:@"section-0-field-3" includingHiddenFields:NO];
    XCTAssertEqualObjects(section.position, @1);
    XCTAssertEqualObjects(field.position, @2);
}

- (void)testSectionPositionForHideAndShowTargets
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"section-field-position.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *manager = [[FORMData alloc] initWithJSON:JSON
                                         initialValues:nil
                                      disabledFieldIDs:nil
                                              disabled:NO];

    FORMSection *section = [manager sectionWithID:@"section-2"];
    XCTAssertEqualObjects(section.position, @2);

    FORMTarget *target = [FORMTarget hideSectionTargetWithID:@"section-1"];
    [manager hideTargets:@[target]];
    section = [manager sectionWithID:@"section-2"];
    XCTAssertEqualObjects(section.position, @1);

    target = [FORMTarget showSectionTargetWithID:@"section-1"];
    [manager showTargets:@[target]];
    section = [manager sectionWithID:@"section-2"];
    XCTAssertEqualObjects(section.position, @2);
}

- (void)testRequiredFields
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *manager = [[FORMData alloc] initWithJSON:JSON
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
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"field-validations.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *manager = [[FORMData alloc] initWithJSON:JSON
                                         initialValues:nil
                                      disabledFieldIDs:nil
                                              disabled:NO];

    NSArray *fields = [manager invalidFormFields];

    XCTAssertTrue(fields.count == 1);

    XCTAssertEqualObjects([[fields firstObject] fieldID], @"first_name");
}

- (void)testFieldWithIDWithIndexPath
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:@{@"first_name" : @"Elvis",
                                                                        @"last_name" : @"Nunez"}
                                                             disabled:NO];

    FORMField *firstNameField = [dataSource fieldWithID:@"first_name" includingHiddenFields:NO];
    XCTAssertNotNil(firstNameField);
    XCTAssertEqualObjects(firstNameField.fieldID, @"first_name");
    XCTAssertEqualObjects(firstNameField.value, @"Elvis");

    FORMField *startDateField = [dataSource fieldWithID:@"start_date" includingHiddenFields:NO];
    XCTAssertNotNil(startDateField);
    XCTAssertEqualObjects(startDateField.fieldID, @"start_date");
    [dataSource processTarget:[FORMTarget hideFieldTargetWithID:@"start_date"]];
    startDateField = [dataSource fieldWithID:@"start_date" includingHiddenFields:NO];
    XCTAssertNil(startDateField);
    [dataSource processTarget:[FORMTarget showFieldTargetWithID:@"start_date"]];
    startDateField = [dataSource fieldWithID:@"start_date" includingHiddenFields:NO];
    XCTAssertNotNil(startDateField);

    [dataSource processTarget:[FORMTarget hideSectionTargetWithID:@"employment-1"]];
    FORMField *contractTypeField = [dataSource fieldWithID:@"contract_type" includingHiddenFields:NO];
    XCTAssertNotNil(contractTypeField);
    XCTAssertEqualObjects(contractTypeField.fieldID, @"contract_type");
    [dataSource processTarget:[FORMTarget showSectionTargetWithID:@"employment-1"]];
}

- (void)testShowingFieldMultipleTimes
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"multiple-show-hide-field-targets.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *normalManager = [[FORMData alloc] initWithJSON:JSON
                                               initialValues:@{@"contract_type" : @1,
                                                               @"salary_type": @1}
                                            disabledFieldIDs:nil
                                                    disabled:NO];

    NSUInteger numberOfFields = [[[normalManager.forms firstObject] fields] count];
    XCTAssertEqual(numberOfFields, 2);

    FORMData *evaluatedManager = [[FORMData alloc] initWithJSON:JSON
                                                  initialValues:@{@"contract_type" : @0,
                                                                  @"salary_type": @0}
                                               disabledFieldIDs:nil
                                                       disabled:NO];

    NSUInteger numberOfFieldsWithHiddenTargets = [[[evaluatedManager.forms firstObject] fields] count];
    XCTAssertEqual(numberOfFieldsWithHiddenTargets, 3);
}

- (void)testHidingFieldMultipleTimes
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"multiple-show-hide-field-targets.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *normalManager = [[FORMData alloc] initWithJSON:JSON
                                               initialValues:nil
                                            disabledFieldIDs:nil
                                                    disabled:NO];

    NSUInteger numberOfFields = [[[normalManager.forms firstObject] fields] count];
    XCTAssertEqual(numberOfFields, 3);

    FORMData *evaluatedManager = [[FORMData alloc] initWithJSON:JSON
                                                  initialValues:@{@"contract_type" : @1,
                                                                  @"salary_type": @1}
                                               disabledFieldIDs:nil
                                                       disabled:NO];

    NSUInteger numberOfFieldsWithHiddenTargets = [[[evaluatedManager.forms firstObject] fields] count];
    XCTAssertEqual(numberOfFieldsWithHiddenTargets, 2);
}

- (void)testShowingSectionMultipleTimes
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"multiple-show-hide-section-targets.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *normalManager = [[FORMData alloc] initWithJSON:JSON
                                               initialValues:@{@"contract_type" : @1,
                                                               @"salary_type": @1}
                                            disabledFieldIDs:nil
                                                    disabled:NO];

    NSUInteger numberOfSections = [[[normalManager.forms firstObject] sections] count];
    XCTAssertEqual(numberOfSections, 2);

    FORMData *evaluatedManager = [[FORMData alloc] initWithJSON:JSON
                                                  initialValues:@{@"contract_type" : @0,
                                                                  @"salary_type": @0}
                                               disabledFieldIDs:nil
                                                       disabled:NO];

    NSUInteger numberOfSectionsWithHiddenTargets = [[[evaluatedManager.forms firstObject] sections] count];
    XCTAssertEqual(numberOfSectionsWithHiddenTargets, 3);
}

- (void)testHidingSectionMultipleTimes
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"multiple-show-hide-section-targets.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *normalManager = [[FORMData alloc] initWithJSON:JSON
                                               initialValues:nil
                                            disabledFieldIDs:nil
                                                    disabled:NO];

    NSUInteger numberOfSections = [[[normalManager.forms firstObject] sections] count];
    XCTAssertEqual(numberOfSections, 3);

    FORMData *evaluatedManager = [[FORMData alloc] initWithJSON:JSON
                                                  initialValues:@{@"contract_type" : @1,
                                                                  @"salary_type": @1}
                                               disabledFieldIDs:nil
                                                       disabled:NO];

    NSUInteger numberOfSectionsWithHiddenTargets = [[[evaluatedManager.forms firstObject] sections] count];
    XCTAssertEqual(numberOfSectionsWithHiddenTargets, 2);
}

- (void)testFormatValidation
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];
    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:@{@"email" : @"faultyEmail"}
                                                             disabled:NO];

    FORMField *emailField = [dataSource fieldWithID:@"email" includingHiddenFields:NO];
    XCTAssertEqual(FORMValidationResultTypeInvalidFormat, [emailField validate]);

    [dataSource reloadWithDictionary:@{@"email" : @"teknologi@hyper.no"}];
    XCTAssertEqual(FORMValidationResultTypePassed, [emailField validate]);
}

- (void)testFieldWithIDIncludingHiddenFields
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *manager = [[FORMData alloc] initWithJSON:JSON
                                         initialValues:@{@"first_name" : @"Elvis",
                                                         @"last_name" : @"Nunez"}
                                      disabledFieldIDs:nil
                                              disabled:NO];

    FORMField *field = [manager fieldWithID:@"first_name" includingHiddenFields:YES];
    XCTAssertEqualObjects(field.fieldID, @"first_name");

    [manager indexForFieldWithID:field.fieldID
                 inSectionWithID:field.section.sectionID
                      completion:^(FORMSection *section, NSInteger index) {
                          if (section) [section.fields removeObjectAtIndex:index];
                      }];

    field = [manager fieldWithID:@"first_name" includingHiddenFields:YES];

    XCTAssertNil(field);
}

- (void)testDynamicWithInitialValues
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *data = [[FORMData alloc] initWithJSON:JSON
                                      initialValues:@{@"companies[0].name" : @"Facebook",
                                                      @"companies[0].phone_number" : @"1222333",
                                                      @"companies[1].name" : @"Google"}
                                   disabledFieldIDs:nil
                                           disabled:NO];

    FORMField *field = [data fieldWithID:@"companies[0].name" includingHiddenFields:NO];
    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.value, @"Facebook");

    field = [data fieldWithID:@"companies[0].phone_number" includingHiddenFields:NO];
    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.value, @"1222333");

    field = [data fieldWithID:@"companies[1].name" includingHiddenFields:NO];
    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.value, @"Google");

    field = [data fieldWithID:@"companies[1].phone_number" includingHiddenFields:NO];
    XCTAssertNotNil(field);
    XCTAssertNil(field.value);
}

@end
