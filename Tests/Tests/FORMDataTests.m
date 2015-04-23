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

@interface FORMData (FORMDataTests)

- (BOOL)evaluateCondition:(NSString *)condition;

@end

@interface FORMDataTests : XCTestCase

@end

@implementation FORMDataTests

- (void)testFormsGeneration {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:nil
                                       disabledFieldIDs:nil
                                               disabled:NO];

    XCTAssertNotNil(formData.groups);

    XCTAssertTrue(formData.groups.count > 0);

    XCTAssertTrue(formData.hiddenFieldsAndFieldIDsDictionary.count == 0);

    XCTAssertTrue(formData.hiddenSections.count == 0);
}

- (void)testDefaultValues {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"default-values.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    NSDate *date = [NSDate date];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:@{@"contract_type" : [NSNull null],
                                                          @"start_date" : date,
                                                          @"base_salary": @2}
                                       disabledFieldIDs:nil
                                               disabled:NO];

    XCTAssertEqualObjects([formData.values objectForKey:@"contract_type"], @0);
    XCTAssertEqualObjects([formData.values objectForKey:@"start_date"], date);
    XCTAssertEqualObjects([formData.values objectForKey:@"base_salary"], @2);
}

- (void)testCalculatedValues {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"number-formula.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:@{@"base_salary" : @1,
                                                          @"bonus" : @100}
                                       disabledFieldIDs:nil
                                               disabled:NO];

    XCTAssertEqualObjects([formData.values objectForKey:@"base_salary"], @1);
    XCTAssertEqualObjects([formData.values objectForKey:@"bonus"], @100);
    XCTAssertEqualObjects([formData.values objectForKey:@"total"], @300);
}

- (void)testFormGenerationSectionPositions {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"section-field-position.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:nil
                                       disabledFieldIDs:nil
                                               disabled:NO];

    FORMSection *section = [formData sectionWithID:@"section-2"];
    XCTAssertNotNil(section);
    XCTAssertEqualObjects(section.position, @2);

    FORMField *field = [formData fieldWithID:@"section-0-field-3" includingHiddenFields:NO];
    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.position, @3);
}

- (void)testFormGenerationSectionPositionsWithHiddenTargets {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"section-field-position.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:@{@"section-0-field-0" : @0}
                                       disabledFieldIDs:nil
                                               disabled:NO];

    XCTAssertTrue(formData.hiddenFieldsAndFieldIDsDictionary.count > 0);
    XCTAssertTrue(formData.hiddenSections.count > 0);

    FORMSection *section = [formData sectionWithID:@"section-2"];
    FORMField *field = [formData fieldWithID:@"section-0-field-3" includingHiddenFields:NO];
    XCTAssertEqualObjects(section.position, @1);
    XCTAssertEqualObjects(field.position, @2);
}

- (void)testSectionPositionForHideAndShowTargets {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"section-field-position.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:nil
                                       disabledFieldIDs:nil
                                               disabled:NO];

    FORMSection *section = [formData sectionWithID:@"section-2"];
    XCTAssertEqualObjects(section.position, @2);

    FORMTarget *target = [FORMTarget hideSectionTargetWithID:@"section-1"];
    [formData hideTargets:@[target]];
    section = [formData sectionWithID:@"section-2"];
    XCTAssertEqualObjects(section.position, @1);

    target = [FORMTarget showSectionTargetWithID:@"section-1"];
    [formData showTargets:@[target]];
    section = [formData sectionWithID:@"section-2"];
    XCTAssertEqualObjects(section.position, @2);
}

- (void)testRequiredFields {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:nil
                                       disabledFieldIDs:nil
                                               disabled:NO];

    NSDictionary *requiredFormFields = [formData requiredFormFields];

    XCTAssertTrue([requiredFormFields andy_valueForKey:@"first_name"]);

    XCTAssertTrue([requiredFormFields andy_valueForKey:@"last_name"]);

    XCTAssertNil([requiredFormFields andy_valueForKey:@"address"]);
}

- (void)testFieldValidation {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"field-validations.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:nil
                                       disabledFieldIDs:nil
                                               disabled:NO];

    NSDictionary *fields = [formData invalidFormFields];

    XCTAssertTrue(fields.count == 2);

    XCTAssertNotNil([fields valueForKey:@"first_name"]);
}

- (void)testFieldWithIDWithIndexPath {
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
    [dataSource processTargets:@[[FORMTarget hideFieldTargetWithID:@"start_date"]]];
    startDateField = [dataSource fieldWithID:@"start_date" includingHiddenFields:NO];
    XCTAssertNil(startDateField);
    [dataSource processTargets:@[[FORMTarget showFieldTargetWithID:@"start_date"]]];
    startDateField = [dataSource fieldWithID:@"start_date" includingHiddenFields:NO];
    XCTAssertNotNil(startDateField);

    [dataSource processTargets:@[[FORMTarget hideSectionTargetWithID:@"employment-1"]]];
    FORMField *contractTypeField = [dataSource fieldWithID:@"contract_type" includingHiddenFields:NO];
    XCTAssertNotNil(contractTypeField);
    XCTAssertEqualObjects(contractTypeField.fieldID, @"contract_type");
    [dataSource processTargets:@[[FORMTarget showSectionTargetWithID:@"employment-1"]]];
}

- (void)testShowingFieldMultipleTimes {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"multiple-show-hide-field-targets.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *normalFormData = [[FORMData alloc] initWithJSON:JSON
                                                initialValues:@{@"contract_type" : @1,
                                                                @"salary_type": @1}
                                             disabledFieldIDs:nil
                                                     disabled:NO];

    NSUInteger numberOfFields = [[[normalFormData.groups firstObject] fields] count];
    XCTAssertEqual(numberOfFields, 2);

    FORMData *evaluatedFormData = [[FORMData alloc] initWithJSON:JSON
                                                   initialValues:@{@"contract_type" : @0,
                                                                   @"salary_type": @0}
                                                disabledFieldIDs:nil
                                                        disabled:NO];

    NSUInteger numberOfFieldsWithHiddenTargets = [[[evaluatedFormData.groups firstObject] fields] count];
    XCTAssertEqual(numberOfFieldsWithHiddenTargets, 3);
}

- (void)testHidingFieldMultipleTimes {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"multiple-show-hide-field-targets.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *normalformData = [[FORMData alloc] initWithJSON:JSON
                                                initialValues:nil
                                             disabledFieldIDs:nil
                                                     disabled:NO];

    NSUInteger numberOfFields = [[[normalformData.groups firstObject] fields] count];
    XCTAssertEqual(numberOfFields, 3);

    FORMData *evaluatedformData = [[FORMData alloc] initWithJSON:JSON
                                                   initialValues:@{@"contract_type" : @1,
                                                                   @"salary_type": @1}
                                                disabledFieldIDs:nil
                                                        disabled:NO];

    NSUInteger numberOfFieldsWithHiddenTargets = [[[evaluatedformData.groups firstObject] fields] count];
    XCTAssertEqual(numberOfFieldsWithHiddenTargets, 2);
}

- (void)testShowingSectionMultipleTimes {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"multiple-show-hide-section-targets.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *normalFormData = [[FORMData alloc] initWithJSON:JSON
                                                initialValues:@{@"contract_type" : @1,
                                                                @"salary_type": @1}
                                             disabledFieldIDs:nil
                                                     disabled:NO];

    NSUInteger numberOfSections = [[[normalFormData.groups firstObject] sections] count];
    XCTAssertEqual(numberOfSections, 2);

    FORMData *evaluatedFormData = [[FORMData alloc] initWithJSON:JSON
                                                   initialValues:@{@"contract_type" : @0,
                                                                   @"salary_type": @0}
                                                disabledFieldIDs:nil
                                                        disabled:NO];

    NSUInteger numberOfSectionsWithHiddenTargets = [[[evaluatedFormData.groups firstObject] sections] count];
    XCTAssertEqual(numberOfSectionsWithHiddenTargets, 3);
}

- (void)testHidingSectionMultipleTimes {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"multiple-show-hide-section-targets.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *normalFormData = [[FORMData alloc] initWithJSON:JSON
                                                initialValues:nil
                                             disabledFieldIDs:nil
                                                     disabled:NO];

    NSUInteger numberOfSections = [[[normalFormData.groups firstObject] sections] count];
    XCTAssertEqual(numberOfSections, 3);

    FORMData *evaluatedFormData = [[FORMData alloc] initWithJSON:JSON
                                                   initialValues:@{@"contract_type" : @1,
                                                                   @"salary_type": @1}
                                                disabledFieldIDs:nil
                                                        disabled:NO];

    NSUInteger numberOfSectionsWithHiddenTargets = [[[evaluatedFormData.groups firstObject] sections] count];
    XCTAssertEqual(numberOfSectionsWithHiddenTargets, 2);
}

- (void)testFormatValidation {
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
    XCTAssertEqual(FORMValidationResultTypeValid, [emailField validate]);
}

- (void)testFieldWithIDIncludingHiddenFields {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:@{@"first_name" : @"Elvis",
                                                          @"last_name" : @"Nunez"}
                                       disabledFieldIDs:nil
                                               disabled:NO];

    FORMField *field = [formData fieldWithID:@"first_name" includingHiddenFields:YES];
    XCTAssertEqualObjects(field.fieldID, @"first_name");

    [formData indexForFieldWithID:field.fieldID
                  inSectionWithID:field.section.sectionID
                       completion:^(FORMSection *section, NSInteger index) {
                           if (section) [section.fields removeObjectAtIndex:index];
                       }];

    field = [formData fieldWithID:@"first_name" includingHiddenFields:YES];

    XCTAssertNil(field);
}

- (void)testDynamicWithInitialValues {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:@{@"email" : @"hi@there.com",
                                                          @"companies[0].name" : @"Facebook",
                                                          @"companies[0].phone_number" : @"1222333",
                                                          @"companies[1].name" : @"Google"}
                                       disabledFieldIDs:nil
                                               disabled:NO];

    FORMField *field = [formData fieldWithID:@"companies[0].name" includingHiddenFields:NO];
    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.value, @"Facebook");

    field = [formData fieldWithID:@"companies[0].phone_number" includingHiddenFields:NO];
    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.value, @"1222333");

    field = [formData fieldWithID:@"companies[1].name" includingHiddenFields:NO];
    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.value, @"Google");

    field = [formData fieldWithID:@"companies[1].phone_number" includingHiddenFields:NO];
    XCTAssertNotNil(field);
    XCTAssertNil(field.value);

    field = [formData fieldWithID:@"email" includingHiddenFields:NO];
    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.value, @"hi@there.com");
}

- (void)testRemovedValuesWhenRemovingDynamicSection {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:@{@"email" : @"hi@there.com",
                                                          @"companies[0].name" : @"Facebook",
                                                          @"companies[0].phone_number" : @"1222333"}
                                       disabledFieldIDs:nil
                                               disabled:NO];

    XCTAssertEqual(formData.values.count, 3);
    XCTAssertEqual(formData.removedValues.count, 0);
    XCTAssertEqualObjects(formData.values[@"companies[0].name"], @"Facebook");
    XCTAssertEqualObjects(formData.values[@"companies[0].phone_number"], @"1222333");
    XCTAssertEqualObjects(formData.values[@"email"], @"hi@there.com");

    FORMSection *section = [formData sectionWithID:@"companies[0]"];
    [formData removeSection:section inCollectionView:nil];

    XCTAssertEqual(formData.values.count, 1);
    XCTAssertEqual(formData.removedValues.count, 2);
    XCTAssertEqualObjects(formData.values[@"email"], @"hi@there.com");
    XCTAssertEqualObjects(formData.removedValues[@"companies[0].name"], @"Facebook");
    XCTAssertEqualObjects(formData.removedValues[@"companies[0].phone_number"], @"1222333");
}

- (void)testRemoveDynamicSectionA {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:@{@"companies[0].name" : @"Facebook",
                                                          @"companies[0].phone_number" : @"1222333",
                                                          @"companies[1].name" : @"Apple",
                                                          @"companies[1].phone_number" : @"4444555"}
                                       disabledFieldIDs:nil
                                               disabled:NO];

    FORMGroup *group = formData.groups[0];
    XCTAssertEqual(group.sections.count, 6);
    NSArray *sectionPositions = @[@0, @1, @2, @3, @4, @5];
    NSArray *comparedSectionPositions = [group.sections valueForKey:@"position"];
    XCTAssertEqualObjects(sectionPositions, comparedSectionPositions);

    FORMSection *section = group.sections[1];
    XCTAssertEqualObjects(section.sectionID, @"companies[0]");
    NSArray *fieldIDs = [section.fields valueForKey:@"fieldID"];
    NSArray *comparedFieldIDs = @[@"companies[0].name", @"companies[0].phone_number", @"companies[0].remove"];
    XCTAssertEqualObjects(fieldIDs, comparedFieldIDs);

    [formData removeSection:section inCollectionView:nil];

    XCTAssertEqual(group.sections.count, 5);
    sectionPositions = @[@0, @1, @2, @3, @4];
    comparedSectionPositions = [group.sections valueForKey:@"position"];
    XCTAssertEqualObjects(sectionPositions, comparedSectionPositions);

    section = group.sections[1];
    XCTAssertEqualObjects(section.sectionID, @"companies[0]");
    fieldIDs = [section.fields valueForKey:@"fieldID"];
    comparedFieldIDs = @[@"companies[0].name", @"companies[0].phone_number", @"companies[0].remove"];
    XCTAssertEqualObjects(fieldIDs, comparedFieldIDs);
}

- (void)testRemoveDynamicSectionB {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:@{@"companies[0].name" : @"Facebook",
                                                          @"companies[0].phone_number" : @"1222333"}
                                       disabledFieldIDs:nil
                                               disabled:NO];

    FORMGroup *group = formData.groups[0];
    XCTAssertEqual(group.sections.count, 5);
    NSArray *sectionPositions = @[@0, @1, @2, @3, @4];
    NSArray *comparedSectionPositions = [group.sections valueForKey:@"position"];
    XCTAssertEqualObjects(sectionPositions, comparedSectionPositions);

    FORMSection *section = group.sections[1];
    XCTAssertEqualObjects(section.sectionID, @"companies[0]");

    [formData removeSection:section inCollectionView:nil];

    sectionPositions = @[@0, @1, @2, @3];
    comparedSectionPositions = [group.sections valueForKey:@"position"];
    XCTAssertEqualObjects(sectionPositions, comparedSectionPositions);

    section = group.sections[1];
    XCTAssertEqualObjects(section.sectionID, @"personal-details-0");
}

- (void)testRemoveDynamicSectionC {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:@{@"companies[0].name" : @"Facebook",
                                                          @"companies[0].phone_number" : @"1222333",
                                                          @"contacts[0].first_name" : @"Apple",
                                                          @"contacts[0].last_name" : @"Computers"}
                                       disabledFieldIDs:nil
                                               disabled:NO];

    FORMGroup *group = formData.groups[0];
    XCTAssertEqual(group.sections.count, 6);
    NSArray *sectionPositions = @[@0, @1, @2, @3, @4, @5];
    NSArray *comparedSectionPositions = [group.sections valueForKey:@"position"];
    XCTAssertEqualObjects(sectionPositions, comparedSectionPositions);

    FORMSection *section = group.sections[1];
    XCTAssertEqualObjects(section.sectionID, @"companies[0]");
    NSArray *fieldIDs = [section.fields valueForKey:@"fieldID"];
    NSArray *comparedFieldIDs = @[@"companies[0].name", @"companies[0].phone_number", @"companies[0].remove"];
    XCTAssertEqualObjects(fieldIDs, comparedFieldIDs);

    [formData removeSection:section inCollectionView:nil];

    XCTAssertEqual(group.sections.count, 5);
    sectionPositions = @[@0, @1, @2, @3, @4];
    comparedSectionPositions = [group.sections valueForKey:@"position"];
    XCTAssertEqualObjects(sectionPositions, comparedSectionPositions);

    section = group.sections[4];
    XCTAssertEqualObjects(section.sectionID, @"contacts[0]");
    fieldIDs = [section.fields valueForKey:@"fieldID"];
    comparedFieldIDs = @[@"contacts[0].first_name", @"contacts[0].last_name", @"contacts[0].remove"];
    XCTAssertEqualObjects(fieldIDs, comparedFieldIDs);
}

#pragma mark - removedSectionsUsingInitialValues

- (void)testRemovedSectionsUsingInitialValuesA {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    NSDictionary *initialValues = @{@"companies[0].name" : @"Company1"};

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:initialValues
                                       disabledFieldIDs:nil
                                               disabled:NO];

    FORMGroup *group = formData.groups[0];
    XCTAssertEqual(group.sections.count, 5);

    NSDictionary *sectionDictionary = @{@"id" : @"companies[1]",
                                        @"fields":@[
                                                @{@"id":@"companies[1].name",
                                                  @"title":@"Name 1",
                                                  @"type":@"name",
                                                  @"size":@{
                                                          @"width":@50,
                                                          @"height":@1
                                                          }}
                                                ]};
    FORMSection *section = [[FORMSection alloc] initWithDictionary:sectionDictionary
                                                          position:2
                                                          disabled:NO
                                                 disabledFieldsIDs:nil
                                                     isLastSection:NO];
    [group.sections insertObject:section atIndex:2];

    NSArray *removedSections = [formData removedSectionsUsingInitialValues:initialValues];
    NSArray *sectionIDs = [removedSections valueForKey:@"sectionID"];
    XCTAssertEqual(sectionIDs.count, 1);
    XCTAssertEqualObjects([sectionIDs lastObject], @"companies[1]");
}

- (void)testRemovedSectionsUsingInitialValuesB {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    NSDictionary *initialValues = @{@"companies[0].name" : @"Company1",
                                    @"companies[1].name" : @"Company2",
                                    @"contacts[0].first_name" : @"Contact1",
                                    @"contacts[1].first_name" : @"Contact2"};

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:initialValues
                                       disabledFieldIDs:nil
                                               disabled:NO];

    FORMGroup *group = formData.groups[0];
    XCTAssertEqual(group.sections.count, 8);
    FORMSection *section = group.sections[2];
    XCTAssertEqualObjects(section.sectionID, @"companies[1]");

    [formData removeSection:section inCollectionView:nil];

    group = formData.groups[0];
    XCTAssertEqual(group.sections.count, 7);

    NSArray *removedSections = [formData removedSectionsUsingInitialValues:initialValues];
    NSArray *sectionIDs = [removedSections valueForKey:@"sectionID"];
    XCTAssertEqual(sectionIDs.count, 0);
}

- (void)testRemovedSectionsUsingInitialValuesC {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    NSDictionary *initialValues = @{@"companies[0].name" : @"Company1",
                                    @"companies[1].name" : @"Company2",
                                    @"contacts[0].first_name" : @"Contact1",
                                    @"contacts[1].first_name" : @"Contact2"};

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:initialValues
                                       disabledFieldIDs:nil
                                               disabled:NO];

    FORMGroup *group = formData.groups[0];
    XCTAssertEqual(group.sections.count, 8);
    FORMSection *section = group.sections[2];
    XCTAssertEqualObjects(section.sectionID, @"companies[1]");

    [formData removeSection:section inCollectionView:nil];

    NSDictionary *sectionDictionary = @{@"id" : @"companies[1]",
                                        @"fields":@[
                                                @{@"id":@"companies[1].name",
                                                  @"title":@"Name 1",
                                                  @"type":@"name",
                                                  @"size":@{
                                                          @"width":@50,
                                                          @"height":@1
                                                          }}
                                                ]};
    section = [[FORMSection alloc] initWithDictionary:sectionDictionary
                                             position:2
                                             disabled:NO
                                    disabledFieldsIDs:nil
                                        isLastSection:NO];
    [group.sections insertObject:section atIndex:2];

    group = formData.groups[0];
    XCTAssertEqual(group.sections.count, 8);

    NSArray *removedSections = [formData removedSectionsUsingInitialValues:initialValues];
    NSArray *sectionIDs = [removedSections valueForKey:@"sectionID"];
    XCTAssertEqual(sectionIDs.count, 0);
}

- (void)testTargetConditions {

    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:@{@"first_name":@"Frank",
                                                          @"last_name":@"Underwood",
                                                          @"display_name":@"",
                                                          @"username": [NSNull null],
                                                          @"base_salary" : @150,
                                                          @"bonus_enabled" : @YES,
                                                          }
                                       disabledFieldIDs:nil
                                               disabled:NO];

    XCTAssertTrue([formData evaluateCondition:@"present($first_name)"]);
    XCTAssertTrue([formData evaluateCondition:@"present($last_name)"]);
    XCTAssertFalse([formData evaluateCondition:@"present($display_name)"]);

    XCTAssertFalse([formData evaluateCondition:@"missing($first_name)"]);
    XCTAssertFalse([formData evaluateCondition:@"missing($last_name)"]);
    XCTAssertTrue([formData evaluateCondition:@"missing($display_name)"]);

    XCTAssertFalse([formData evaluateCondition:@"equals($first_name, \"Claire\")"]);
    XCTAssertTrue([formData evaluateCondition:@"equals($last_name, \"Underwood\")"]);

    XCTAssertFalse([formData evaluateCondition:@"equals($username, \"Francis\")"]);
    XCTAssertFalse([formData evaluateCondition:@"equals($base_salary, 150)"]);
    XCTAssertFalse([formData evaluateCondition:@"equals($bonus_enabled, 1)"]);
}

- (void)testCleaningUpFieldValueWhenHiddingAndShowing {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"simple-text-field.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:@{@"textie" : @"some text"}
                                       disabledFieldIDs:nil
                                               disabled:NO];

    XCTAssertEqual(formData.values.count, 1);

    FORMTarget *target = [FORMTarget hideFieldTargetWithID:@"textie"];
    [formData hideTargets:@[target]];

    XCTAssertEqual(formData.values.count, 0);

    target = [FORMTarget showFieldTargetWithID:@"textie"];
    [formData showTargets:@[target]];

    XCTAssertEqual(formData.values.count, 1);
}

- (void)testCleaningUpSectionValueWhenHiddingAndShowing {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"simple-section.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:@{@"first_name" : @"John",
                                                          @"last_name" : @"Minion"}
                                       disabledFieldIDs:nil
                                               disabled:NO];

    XCTAssertEqual(formData.values.count, 2);

    FORMTarget *target = [FORMTarget hideSectionTargetWithID:@"section"];
    [formData hideTargets:@[target]];

    XCTAssertEqual(formData.values.count, 0);

    target = [FORMTarget showSectionTargetWithID:@"section"];
    [formData showTargets:@[target]];

    XCTAssertEqual(formData.values.count, 2);
}

- (void)testCleaningUpSelectFieldWhenHiddingAndShowing {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"default-values.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:nil
                                       disabledFieldIDs:nil
                                               disabled:NO];

    XCTAssertEqualObjects(formData.values[@"contract_type"], @0);

    FORMTarget *target = [FORMTarget hideFieldTargetWithID:@"contract_type"];
    [formData hideTargets:@[target]];

    XCTAssertEqual(formData.values.count, 0);

    target = [FORMTarget showFieldTargetWithID:@"contract_type"];
    [formData showTargets:@[target]];

    XCTAssertEqualObjects(formData.values[@"contract_type"], @0);
}

- (void)testInitializatingAFieldWithAValueInTheJSON {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"simple-text-field.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMData *formData = [[FORMData alloc] initWithJSON:JSON
                                          initialValues:nil
                                       disabledFieldIDs:nil
                                               disabled:NO];

    XCTAssertEqualObjects(formData.values[@"textie"], @"1");
}

@end
