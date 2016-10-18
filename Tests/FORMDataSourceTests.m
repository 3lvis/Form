@import UIKit;
@import XCTest;

#import "FORMFieldValidation.h"
#import "FORMGroup.h"
#import "FORMField.h"
#import "FORMDataSource.h"
#import "FORMSection.h"
#import "FORMData.h"
#import "FORMTarget.h"
#import "FORMImageFormFieldCell.h"

#import "NSJSONSerialization+ANDYJSONFile.h"
@import NSDictionary_HYPImmutable;

@interface FORMDataSource ()

- (void)fieldCell:(UICollectionViewCell *)fieldCell updatedWithField:(FORMField *)field;

@end

@interface FORMDataSourceTests : XCTestCase

@end

@implementation FORMDataSourceTests

- (void)testIndexInForms {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    [dataSource processTargets:@[[FORMTarget hideFieldTargetWithID:@"display_name"]]];
    [dataSource processTargets:@[[FORMTarget showFieldTargetWithID:@"display_name"]]];
    FORMField *field = [dataSource fieldWithID:@"display_name" includingHiddenFields:YES];
    NSUInteger index = [field indexInSectionUsingGroups:dataSource.groups];
    XCTAssertEqual(index, 2);

    [dataSource processTargets:@[[FORMTarget hideFieldTargetWithID:@"username"]]];
    [dataSource processTargets:@[[FORMTarget showFieldTargetWithID:@"username"]]];
    field = [dataSource fieldWithID:@"username" includingHiddenFields:YES];
    index = [field indexInSectionUsingGroups:dataSource.groups];
    XCTAssertEqual(index, 2);

    [dataSource processTargets:[FORMTarget hideFieldTargetsWithIDs:@[@"first_name",
                                                                     @"address",
                                                                     @"username"]]];
    [dataSource processTargets:@[[FORMTarget showFieldTargetWithID:@"username"]]];
    field = [dataSource fieldWithID:@"username" includingHiddenFields:YES];
    index = [field indexInSectionUsingGroups:dataSource.groups];
    XCTAssertEqual(index, 1);
    [dataSource processTargets:[FORMTarget showFieldTargetsWithIDs:@[@"first_name",
                                                                     @"address"]]];

    [dataSource processTargets:[FORMTarget hideFieldTargetsWithIDs:@[@"last_name",
                                                                     @"address"]]];
    [dataSource processTargets:@[[FORMTarget showFieldTargetWithID:@"address"]]];
    field = [dataSource fieldWithID:@"address" includingHiddenFields:YES];
    index = [field indexInSectionUsingGroups:dataSource.groups];
    XCTAssertEqual(index, 0);
    [dataSource processTargets:@[[FORMTarget showFieldTargetWithID:@"last_name"]]];
}

- (void)testEnableAndDisableTargets {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];
    [dataSource enable];

    FORMField *targetField = [dataSource fieldWithID:@"base_salary" includingHiddenFields:YES];
    XCTAssertFalse(targetField.isDisabled);

    FORMTarget *disableTarget = [FORMTarget disableFieldTargetWithID:@"base_salary"];
    [dataSource processTargets:@[disableTarget]];
    XCTAssertTrue(targetField.isDisabled);

    FORMTarget *enableTarget = [FORMTarget enableFieldTargetWithID:@"base_salary"];
    [dataSource processTargets:@[enableTarget]];
    XCTAssertFalse(targetField.isDisabled);

    [dataSource disable];
    XCTAssertTrue(targetField.isDisabled);

    [dataSource enable];
    XCTAssertFalse(targetField.isDisabled);
}

- (void)testInitiallyDisabled {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMField *totalField = [dataSource fieldWithID:@"total" includingHiddenFields:YES];
    XCTAssertTrue(totalField.disabled);
}

- (void)testUpdatingTargetValue {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMField *targetField = [dataSource fieldWithID:@"display_name" includingHiddenFields:YES];
    XCTAssertNil(targetField.value);

    FORMTarget *updateTarget = [FORMTarget updateFieldTargetWithID:@"display_name"];
    updateTarget.targetValue = @"John Hyperseed";

    [dataSource processTargets:@[updateTarget]];
    XCTAssertEqualObjects(targetField.value, @"John Hyperseed");
}

- (void)testDefaultValue {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMField *usernameField = [dataSource fieldWithID:@"username" includingHiddenFields:YES];
    XCTAssertNotNil(usernameField.value);
}

- (void)testDefaultValueInTemplate {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"default-values-in-template.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMField *addField = [dataSource fieldWithID:@"tickets.add" includingHiddenFields:NO];
    XCTAssertNotNil(addField);

    [dataSource fieldCell:nil updatedWithField:addField];

    FORMField *ticketTypeField = [dataSource fieldWithID:@"tickets[0].type" includingHiddenFields:NO];
    XCTAssertNotNil(ticketTypeField);
    XCTAssertEqualObjects(ticketTypeField.value, @1);
}

- (void)testCondition {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMField *displayNameField = [dataSource fieldWithID:@"display_name" includingHiddenFields:YES];
    FORMField *usernameField = [dataSource fieldWithID:@"username" includingHiddenFields:YES];
    FORMFieldValue *fieldValue = usernameField.value;
    XCTAssertEqualObjects(fieldValue.valueID, @0);

    FORMTarget *updateTarget = [FORMTarget updateFieldTargetWithID:@"display_name"];
    updateTarget.targetValue = @"Mr.Melk";

    updateTarget.condition = @"$username == 2";
    [dataSource processTargets:@[updateTarget]];
    XCTAssertNil(displayNameField.value);

    updateTarget.condition = @"$username == 0";
    [dataSource processTargets:@[updateTarget]];
    XCTAssertEqualObjects(displayNameField.value, @"Mr.Melk");
}

#pragma mark - reloadWithDictionary

- (void)testReloadWithDictionary {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:@{@"username": @0}
                                                             disabled:YES];

    FORMField *usernameField = [dataSource fieldWithID:@"username" includingHiddenFields:YES];
    FORMFieldValue *usernameValue = usernameField.value;
    XCTAssertTrue([usernameValue isKindOfClass:[FORMFieldValue class]]);

    [dataSource reloadWithDictionary:@{@"first_name" : @"Elvis",
                                       @"last_name" : @"Nunez",
                                       @"username" : @1}];

    FORMField *field = [dataSource fieldWithID:@"display_name" includingHiddenFields:YES];
    XCTAssertEqualObjects(field.value, @"Elvis Nunez");

    usernameValue = usernameField.value;
    XCTAssertTrue([usernameValue isKindOfClass:[FORMFieldValue class]]);
    XCTAssertEqualObjects(usernameValue.valueID, @1);

    [dataSource reloadWithDictionary:@{@"username" : @4}];
    XCTAssertNil(usernameValue.value);

    [dataSource reloadWithDictionary:@{@"username" : [NSNull null]}];
    XCTAssertNil(usernameValue.value);
}

#pragma mark - testResetDynamicSectionsWithDictionary

- (void)testResetDynamicSectionsWithDictionaryA {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    NSDictionary *initialValues = @{@"email" : @"hi@there.com",
                                    @"companies[0].name" : @"Facebook",
                                    @"companies[0].phone_number" : @"1222333"};

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:initialValues
                                                             disabled:NO];

    FORMGroup *group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 5);
    FORMSection *section = group.sections[1];
    XCTAssertEqualObjects(section.sectionID, @"companies[0]");
    XCTAssertEqualObjects(dataSource.values, initialValues);
    XCTAssertEqual(dataSource.removedValues.count, 0);

    FORMField *removeField = [dataSource fieldWithID:@"companies[0].remove" includingHiddenFields:YES];
    [dataSource fieldCell:nil updatedWithField:removeField];

    group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 4);
    section = group.sections[1];
    XCTAssertEqualObjects(section.sectionID, @"personal-details-0");
    XCTAssertNil([dataSource.values valueForKey:@"companies[0].name"]);
    XCTAssertNil([dataSource.values valueForKey:@"companies[0].phone_number"]);
    XCTAssertEqualObjects([dataSource.removedValues valueForKey:@"companies[0].name"], @"Facebook");
    XCTAssertEqualObjects([dataSource.removedValues valueForKey:@"companies[0].phone_number"], @"1222333");

    [dataSource resetDynamicSectionsWithDictionary:initialValues];

    group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 5);
    section = group.sections[1];
    XCTAssertEqualObjects(section.sectionID, @"companies[0]");
    XCTAssertEqualObjects(dataSource.values, initialValues);
}

- (void)testResetDynamicSectionsWithDictionaryB {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    NSDictionary *initialValues = @{@"email" : @"hi@there.com",
                                    @"companies[0].name" : @"Facebook",
                                    @"companies[0].phone_number" : @"1222333"};

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:initialValues
                                                             disabled:NO];

    FORMGroup *group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 5);

    FORMField *field = [dataSource fieldWithID:@"companies.add" includingHiddenFields:NO];
    XCTAssertNotNil(field);
    [dataSource fieldCell:nil updatedWithField:field];
    [dataSource fieldCell:nil updatedWithField:field];

    group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 7);

    [dataSource resetDynamicSectionsWithDictionary:initialValues];

    group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 5);
    FORMSection *section = group.sections[1];
    XCTAssertEqualObjects(section.sectionID, @"companies[0]");
    XCTAssertEqualObjects(dataSource.values, initialValues);
}

- (void)testResetDynamicSectionsWithDictionaryC {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    NSDictionary *initialValues = @{@"email" : @"hi@there.com",
                                    @"companies[0].name" : @"Facebook",
                                    @"companies[0].phone_number" : @"1222333",
                                    @"companies[1].name" : @"Facebook",
                                    @"companies[1].phone_number" : @"1222333"};

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:initialValues
                                                             disabled:NO];

    FORMGroup *group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 6);

    FORMField *removeField = [dataSource fieldWithID:@"companies[0].remove" includingHiddenFields:YES];
    XCTAssertNotNil(removeField);
    [dataSource fieldCell:nil updatedWithField:removeField];
    [dataSource fieldCell:nil updatedWithField:removeField];

    group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 4);

    [dataSource resetDynamicSectionsWithDictionary:initialValues];

    group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 6);
    FORMSection *section = group.sections[1];
    XCTAssertEqualObjects(section.sectionID, @"companies[0]");
    XCTAssertEqualObjects(dataSource.values, initialValues);
}

- (void)testResetDynamicSectionsWithDictionaryD {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    NSDictionary *initialValues = @{@"email" : @"hi@there.com",
                                    @"companies[0].name" : @"Company1",
                                    @"companies[1].name" : @"Company2",
                                    @"contacts[0].first_name" : @"Contact1",
                                    @"contacts[1].first_name" : @"Contact2"};

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:initialValues
                                                             disabled:NO];

    FORMGroup *group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 8);
    FORMSection *section = group.sections[2];
    XCTAssertEqualObjects(section.sectionID, @"companies[1]");

    FORMField *removeField = [dataSource fieldWithID:@"companies[1].remove" includingHiddenFields:YES];
    XCTAssertNotNil(removeField);
    [dataSource fieldCell:nil updatedWithField:removeField];

    group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 7);

    [dataSource resetDynamicSectionsWithDictionary:initialValues];

    group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 8);
    section = group.sections[2];
    XCTAssertEqualObjects(section.sectionID, @"companies[1]");

    XCTAssertEqualObjects([dataSource.values hyp_removingNulls], initialValues);
}

- (void)testResetDynamicSectionsWithDictionaryE {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    NSDictionary *initialValues = @{@"companies[0].name" : @"Company1",
                                    @"companies[1].name" : @"Company2",
                                    @"contacts[0].first_name" : @"Contact1",
                                    @"contacts[1].first_name" : @"Contact2"};

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:initialValues
                                                             disabled:NO];

    FORMGroup *group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 8);
    FORMSection *section = group.sections[2];
    XCTAssertEqualObjects(section.sectionID, @"companies[1]");

    FORMField *removeField = [dataSource fieldWithID:@"companies[1].remove" includingHiddenFields:YES];
    XCTAssertNotNil(removeField);
    [dataSource fieldCell:nil updatedWithField:removeField];

    FORMField *field = [dataSource fieldWithID:@"companies.add" includingHiddenFields:NO];
    XCTAssertNotNil(field);
    [dataSource fieldCell:nil updatedWithField:field];

    [dataSource resetDynamicSectionsWithDictionary:initialValues];

    group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 8);
}

- (void)testResetDynamicSectionsWithDictionaryF {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    NSDictionary *initialValues = @{@"companies[0].name" : @"Company1",
                                    @"companies[0].phone_number" : @"1111111",
                                    @"companies[0].external_person_id" : @0,
                                    @"companies[1].name" : @"Company2",
                                    @"companies[1].phone_number" : @"2222222",
                                    @"companies[1].external_person_id" : @1,
                                    @"contacts[0].first_name" : @"Contact1",
                                    @"contacts[0].last_name" : @"Lastname",
                                    @"contacts[0].external_person_id" : @2,
                                    @"contacts[1].first_name" : @"Contact2",
                                    @"contacts[1].last_name" : @"Lastname",
                                    @"contacts[1].external_person_id" : @2};

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:initialValues
                                                             disabled:NO];

    FORMGroup *group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 8);
    FORMSection *section = group.sections[2];
    XCTAssertEqualObjects(section.sectionID, @"companies[1]");

    FORMField *removeField = [dataSource fieldWithID:@"companies[1].remove" includingHiddenFields:YES];
    XCTAssertNotNil(removeField);
    [dataSource fieldCell:nil updatedWithField:removeField];

    FORMField *field = [dataSource fieldWithID:@"companies.add" includingHiddenFields:NO];
    XCTAssertNotNil(field);
    [dataSource fieldCell:nil updatedWithField:field];

    [dataSource resetDynamicSectionsWithDictionary:initialValues];

    group = dataSource.groups[0];
    XCTAssertEqual(group.sections.count, 8);
}

#pragma mark - processTarget

- (void)testClearTarget {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMField *firstNameField = [dataSource fieldWithID:@"first_name" includingHiddenFields:YES];
    XCTAssertNotNil(firstNameField);

    firstNameField.value = @"John";
    XCTAssertNotNil(firstNameField.value);

    FORMTarget *clearTarget = [FORMTarget clearFieldTargetWithID:@"first_name"];
    [dataSource processTargets:@[clearTarget]];
    XCTAssertNil(firstNameField.value);
}

- (void)testFormFieldsAreValid {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"field-validations.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];
    XCTAssertFalse([dataSource isValid]);

    [dataSource reloadWithDictionary:@{@"first_name" : @"Supermancito",
                                       @"birthday" : @"2014-10-31 23:00:00 +00:00" }];

    XCTAssertTrue([dataSource isValid]);
}

- (void)testAddingAndRemovingDynamicFields {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMField *field = [dataSource fieldWithID:@"companies.add" includingHiddenFields:NO];
    XCTAssertNotNil(field);

    NSInteger numberOfFields = [dataSource numberOfFields];

    [dataSource fieldCell:nil updatedWithField:field];
    XCTAssertEqual(numberOfFields + 3, [dataSource numberOfFields]);

    FORMSection *section = [dataSource sectionWithID:@"companies[0]"];
    XCTAssertNotNil(section);

    FORMField *nameField = [dataSource fieldWithID:@"companies[0].name" includingHiddenFields:NO];
    XCTAssertNotNil(nameField);

    FORMField *phoneNumberField = [dataSource fieldWithID:@"companies[0].phone_number" includingHiddenFields:NO];
    XCTAssertNotNil(phoneNumberField);

    FORMField *removeField = [dataSource fieldWithID:@"companies[0].remove" includingHiddenFields:NO];
    XCTAssertNotNil(removeField);

    [dataSource fieldCell:nil updatedWithField:removeField];
    XCTAssertEqual(numberOfFields, [dataSource numberOfFields]);

    [dataSource fieldCell:nil updatedWithField:field];

    section = [dataSource sectionWithID:@"companies[0]"];
    XCTAssertNotNil(section);

    nameField = [dataSource fieldWithID:@"companies[0].name" includingHiddenFields:NO];
    XCTAssertNotNil(nameField);

    phoneNumberField = [dataSource fieldWithID:@"companies[0].phone_number" includingHiddenFields:NO];
    XCTAssertNotNil(phoneNumberField);

    removeField = [dataSource fieldWithID:@"companies[0].remove" includingHiddenFields:NO];
    XCTAssertNotNil(removeField);
}

- (void)testDynamicWithInitialValues {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:@{@"email":@"hi@there.com",
                                                                        @"companies[0].name" : @"Facebook",
                                                                        @"companies[0].phone_number" : @"1222333",
                                                                        @"companies[1].name" : @"Google",
                                                                        @"companies[1].phone_number" : @"4555666"}
                                                             disabled:YES];

    FORMSection *section = [dataSource sectionWithID:@"companies[0]"];
    XCTAssertNotNil(section);

    FORMField *field = [dataSource fieldWithID:@"companies[0].name" includingHiddenFields:NO];
    XCTAssertEqualObjects(field.value, @"Facebook");

    field = [dataSource fieldWithID:@"companies[0].phone_number" includingHiddenFields:NO];
    XCTAssertEqualObjects(field.value, @"1222333");

    section = [dataSource sectionWithID:@"companies[1]"];
    XCTAssertNotNil(section);

    field = [dataSource fieldWithID:@"companies[1].name" includingHiddenFields:NO];
    XCTAssertEqualObjects(field.value, @"Google");

    field = [dataSource fieldWithID:@"companies[1].phone_number" includingHiddenFields:NO];
    XCTAssertEqualObjects(field.value, @"4555666");

    field = [dataSource fieldWithID:@"email" includingHiddenFields:NO];
    XCTAssertEqualObjects(field.value, @"hi@there.com");
}

- (void)testAddingMultipleDynamicSections {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMField *field = [dataSource fieldWithID:@"companies.add" includingHiddenFields:NO];
    XCTAssertNotNil(field);

    [dataSource fieldCell:nil updatedWithField:field];

    __block NSIndexPath *fieldIndexPath;
    [dataSource fieldWithID:@"companies[0].name" includingHiddenFields:NO completion:^(FORMField *field, NSIndexPath *indexPath) {
        fieldIndexPath = indexPath;
    }];

    XCTAssertEqualObjects(fieldIndexPath, [NSIndexPath indexPathForRow:2 inSection:0]);

    [dataSource fieldCell:nil updatedWithField:field];

    [dataSource fieldWithID:@"companies[1].name" includingHiddenFields:NO completion:^(FORMField *field, NSIndexPath *indexPath) {
        fieldIndexPath = indexPath;
    }];

    XCTAssertEqualObjects(fieldIndexPath, [NSIndexPath indexPathForRow:5 inSection:0]);

    field = [dataSource fieldWithID:@"contacts.add" includingHiddenFields:NO];
    XCTAssertNotNil(field);

    [dataSource fieldCell:nil updatedWithField:field];

    [dataSource fieldWithID:@"contacts[0].first_name" includingHiddenFields:NO completion:^(FORMField *field, NSIndexPath *indexPath) {
        fieldIndexPath = indexPath;
    }];

    XCTAssertEqualObjects(fieldIndexPath, [NSIndexPath indexPathForRow:14 inSection:0]);
}

- (void)testRemovingSectionsAddedByInitialValuesA {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:@{@"email" : @"hi@there.com",
                                                                        @"companies[0].name" : @"Facebook",
                                                                        @"companies[0].phone_number" : @"1222333",
                                                                        @"companies[1].name" : @"Google",
                                                                        @"companies[1].phone_number" : @"4555666",
                                                                        @"companies[2].name" : @"Apple",
                                                                        @"companies[2].phone_number" : @"7888999",
                                                                        @"companies[3].name" : @"Microsoft",
                                                                        @"companies[3].phone_number" : @"11223344"
                                                                        }
                                                             disabled:NO];

    XCTAssertEqual(dataSource.values.count, 9);
    XCTAssertEqual(dataSource.removedValues.count, 0);
    XCTAssertEqualObjects(dataSource.values[@"companies[0].name"], @"Facebook");
    XCTAssertEqualObjects(dataSource.values[@"companies[0].phone_number"], @"1222333");

    FORMField *removeField = [dataSource fieldWithID:@"companies[0].remove" includingHiddenFields:YES];
    [dataSource fieldCell:nil updatedWithField:removeField];

    XCTAssertEqual(dataSource.values.count, 7);
    XCTAssertEqual(dataSource.removedValues.count, 2);
    XCTAssertEqualObjects(dataSource.removedValues[@"companies[0].name"], @"Facebook");
    XCTAssertEqualObjects(dataSource.removedValues[@"companies[0].phone_number"], @"1222333");
    XCTAssertEqualObjects(dataSource.values[@"companies[0].name"], @"Google");
    XCTAssertEqualObjects(dataSource.values[@"companies[0].phone_number"], @"4555666");
    XCTAssertEqualObjects(dataSource.values[@"email"], @"hi@there.com");
}

- (void)testRemovingSectionsAddedByInitialValuesB {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:@{@"email" : @"hi@there.com",
                                                                        @"companies[0].name" : @"Facebook",
                                                                        @"companies[0].phone_number" : @"1222333",
                                                                        @"companies[1].name" : @"Google",
                                                                        @"companies[1].phone_number" : @"4555666",
                                                                        @"companies[2].name" : @"Apple",
                                                                        @"companies[2].phone_number" : @"7888999",
                                                                        @"companies[3].name" : @"Microsoft",
                                                                        @"companies[3].phone_number" : @"11223344"
                                                                        }
                                                             disabled:NO];

    XCTAssertEqual(dataSource.values.count, 9);
    XCTAssertEqual(dataSource.removedValues.count, 0);
    XCTAssertEqualObjects(dataSource.values[@"companies[2].name"], @"Apple");
    XCTAssertEqualObjects(dataSource.values[@"companies[2].phone_number"], @"7888999");

    FORMField *removeField = [dataSource fieldWithID:@"companies[1].remove" includingHiddenFields:YES];
    [dataSource fieldCell:nil updatedWithField:removeField];

    XCTAssertEqual(dataSource.values.count, 7);
    XCTAssertTrue(dataSource.removedValues.count == 2);
    XCTAssertEqualObjects(dataSource.removedValues[@"companies[0].name"], @"Google");
    XCTAssertEqualObjects(dataSource.removedValues[@"companies[0].phone_number"], @"4555666");
    XCTAssertEqualObjects(dataSource.values[@"companies[2].name"], @"Microsoft");
    XCTAssertEqualObjects(dataSource.values[@"companies[2].phone_number"], @"11223344");
    XCTAssertEqualObjects(dataSource.values[@"email"], @"hi@there.com");
}

- (void)testRemovingMultipleDynamicSectionsAddedByInitialValues {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:@{@"companies[0].name" : @"Facebook",
                                                                        @"companies[0].phone_number" : @"1222333",
                                                                        @"companies[1].name" : @"Google",
                                                                        @"companies[1].phone_number" : @"4555666"
                                                                        }
                                                             disabled:NO];

    FORMField *removeField = [dataSource fieldWithID:@"companies[0].remove" includingHiddenFields:YES];
    [dataSource fieldCell:nil updatedWithField:removeField];

    XCTAssertTrue(dataSource.values.count == 2);
    XCTAssertEqualObjects(dataSource.values[@"companies[0].name"], @"Google");
    XCTAssertEqualObjects(dataSource.values[@"companies[0].phone_number"], @"4555666");

    XCTAssertTrue(dataSource.removedValues.count == 2);
    XCTAssertEqualObjects(dataSource.removedValues[@"companies[0].name"], @"Facebook");
    XCTAssertEqualObjects(dataSource.removedValues[@"companies[0].phone_number"], @"1222333");

    removeField = [dataSource fieldWithID:@"companies[0].remove" includingHiddenFields:YES];
    [dataSource fieldCell:nil updatedWithField:removeField];

    XCTAssertTrue(dataSource.values.count == 0);
    XCTAssertTrue(dataSource.removedValues.count == 4);
    XCTAssertEqualObjects(dataSource.removedValues[@"companies[1].name"], @"Google");
    XCTAssertEqualObjects(dataSource.removedValues[@"companies[1].phone_number"], @"4555666");
}

- (void)testUpdatedSectionPositionWhenRemovingDynamicSections {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMSection *section = [dataSource sectionWithID:@"companies"];
    XCTAssertEqualObjects(section.position, @0);

    section = [dataSource sectionWithID:@"personal-details-0"];
    XCTAssertEqualObjects(section.position, @1);

    FORMField *addField = [dataSource fieldWithID:@"companies.add" includingHiddenFields:NO];
    XCTAssertNotNil(addField);

    [dataSource fieldCell:nil updatedWithField:addField];

    section = [dataSource sectionWithID:@"companies[0]"];
    XCTAssertNotNil(section);
    XCTAssertEqualObjects(section.position, @1);

    section = [dataSource sectionWithID:@"personal-details-0"];
    XCTAssertEqualObjects(section.position, @2);
    XCTAssertNotNil(section);

    FORMField *removeField = [dataSource fieldWithID:@"companies[0].remove" includingHiddenFields:NO];
    XCTAssertNotNil(removeField);

    [dataSource fieldCell:nil updatedWithField:removeField];

    section = [dataSource sectionWithID:@"personal-details-0"];
    XCTAssertEqualObjects(section.position, @1);
    XCTAssertNotNil(section);
}

- (void)testUpdatedFieldPositionWhenHidingAndShowingField {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"section-field-position.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMSection *section = [dataSource sectionWithID:@"section-0"];
    NSMutableArray *fieldPositions = [NSMutableArray new];

    for (FORMField *field in section.fields) {
        [fieldPositions addObject:field.position];
    }

    NSArray *expectedInitialPositions = @[@0, @1, @2, @3, @4, @5];
    XCTAssertEqualObjects(fieldPositions, expectedInitialPositions);

    [dataSource processTargets:@[[FORMTarget hideFieldTargetWithID:@"section-0-field-2"]]];
    [fieldPositions removeAllObjects];

    for (FORMField *field in section.fields) {
        [fieldPositions addObject:field.position];
    }

    NSArray *expectedUpdatedPositions = @[@0, @1, @3, @4, @5];
    XCTAssertEqualObjects(fieldPositions, expectedUpdatedPositions);

    [dataSource processTargets:@[[FORMTarget showFieldTargetWithID:@"section-0-field-2"]]];
    [fieldPositions removeAllObjects];

    for (FORMField *field in section.fields) {
        [fieldPositions addObject:field.position];
    }

    XCTAssertEqualObjects(fieldPositions, expectedInitialPositions);
}

- (void)testDynamicSectionsInvolvingHideTargets {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:@{@"title" : @0}
                                                             disabled:YES];

    FORMField *addField = [dataSource fieldWithID:@"contacts.add" includingHiddenFields:NO];
    XCTAssertNotNil(addField);

    [dataSource fieldCell:nil updatedWithField:addField];

    FORMSection *section = [dataSource sectionWithID:@"contacts[0]"];
    XCTAssertEqualObjects(section.position, @3);
}

- (void)testDynamicTargetCondition {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:@{@"email" : @"john.hyperseed"}
                                                             disabled:YES];

    FORMField *emailField = [dataSource fieldWithID:@"email" includingHiddenFields:YES];
    NSString *expectedEmail = @"john.hyperseed@hyper.no";

    FORMField *addField = [dataSource fieldWithID:@"companies.add" includingHiddenFields:NO];
    XCTAssertNotNil(addField);

    [dataSource fieldCell:nil updatedWithField:addField];

    XCTAssertEqualObjects(emailField.value, expectedEmail);
}

- (void)testDynamicFormulas {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic-formulas.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:NO];

	FORMField *addField = [dataSource fieldWithID:@"tickets.add" includingHiddenFields:NO];
	XCTAssertNotNil(addField);

    [dataSource fieldCell:nil updatedWithField:addField];

    FORMField *priceField = [dataSource fieldWithID:@"tickets[0].price" includingHiddenFields:NO];
    XCTAssertNotNil(priceField);
    FORMTarget *priceTarget = [[priceField targets] firstObject];
    FORMField *quantityField = [dataSource fieldWithID:@"tickets[0].quantity" includingHiddenFields:NO];
    XCTAssertNotNil(quantityField);
    FORMField *totalField = [dataSource fieldWithID:@"tickets[0].total" includingHiddenFields:NO];
    XCTAssertNotNil(totalField);

    [dataSource reloadWithDictionary:@{@"tickets[0].price" : @100,
                                       @"tickets[0].quantity" : @3}];

    XCTAssertEqualObjects(priceTarget.targetID, @"tickets[0].total");
    XCTAssertEqualObjects(totalField.formula, @"tickets[0].quantity * tickets[0].price");
    XCTAssertEqualObjects(totalField.value, @"300");

    addField = [dataSource fieldWithID:@"tickets.add" includingHiddenFields:NO];
    XCTAssertNotNil(addField);

    // Second add

    [dataSource fieldCell:nil updatedWithField:addField];

    priceField = [dataSource fieldWithID:@"tickets[1].price" includingHiddenFields:NO];
    XCTAssertNotNil(priceField);
    priceTarget = [[priceField targets] firstObject];
    quantityField = [dataSource fieldWithID:@"tickets[1].quantity" includingHiddenFields:NO];
    XCTAssertNotNil(quantityField);
    totalField = [dataSource fieldWithID:@"tickets[1].total" includingHiddenFields:NO];
    XCTAssertNotNil(totalField);

    [dataSource reloadWithDictionary:@{@"tickets[1].price" : @100,
                                       @"tickets[1].quantity" : @3}];

    XCTAssertEqualObjects(priceTarget.targetID, @"tickets[1].total");
    XCTAssertEqualObjects(totalField.formula, @"tickets[1].quantity * tickets[1].price");
    XCTAssertEqualObjects(totalField.value, @"300");
}

- (void)testCollapseAllGroups{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    [dataSource collapseAllGroupsForCollectionView:nil];

    XCTAssertEqual([dataSource.collapsedGroups count], [dataSource.groups count]);
}

- (void)testStyleFields {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"styled-fields.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    // Button Field Styles
    FORMField *buttonField = [dataSource fieldWithID:@"styled_button" includingHiddenFields:NO];
    XCTAssertNotNil(buttonField);

    [dataSource fieldCell:nil updatedWithField:buttonField];
    XCTAssertNotNil(buttonField.styles);
    XCTAssertEqualObjects([buttonField.styles objectForKey:@"background_color"], @"#FF0000");
    XCTAssertEqualObjects([buttonField.styles objectForKey:@"highlighted_background_color"], @"#FF0000");
    XCTAssertEqualObjects([buttonField.styles objectForKey:@"title_color"], @"#000000");
    XCTAssertEqualObjects([buttonField.styles objectForKey:@"highlighted_title_color"], @"#000000");
    XCTAssertEqualObjects([buttonField.styles objectForKey:@"border_color"], @"#FF0000");
    XCTAssertEqualObjects([buttonField.styles objectForKey:@"corner_radius"], @"5.0f");
    XCTAssertEqualObjects([buttonField.styles objectForKey:@"border_width"], @"1.0f");
    XCTAssertEqualObjects([buttonField.styles objectForKey:@"font"], @"AvenirNext-DemiBold");
    XCTAssertEqualObjects([buttonField.styles objectForKey:@"font_size"], @"16.0");

    // Segment Field Styles
    FORMField *segmentField = [dataSource fieldWithID:@"styled_segment" includingHiddenFields:NO];
    XCTAssertNotNil(segmentField);
    
    [dataSource fieldCell:nil updatedWithField:segmentField];
    XCTAssertNotNil(segmentField.styles);
    XCTAssertEqualObjects([segmentField.styles objectForKey:@"tint_color"], @"#FF0000");
    XCTAssertEqualObjects([segmentField.styles objectForKey:@"font"], @"AvenirNext-DemiBold");
    XCTAssertEqualObjects([segmentField.styles objectForKey:@"font_size"], @"16.0");
    
    // Text Field Styles
    FORMField *textField = [dataSource fieldWithID:@"styled_text_field" includingHiddenFields:NO];
    XCTAssertNotNil(textField);

    [dataSource fieldCell:nil updatedWithField:textField];
    XCTAssertNotNil(textField.styles);
    XCTAssertEqualObjects([textField.styles objectForKey:@"font"], @"AvenirNext-DemiBold");
    XCTAssertEqualObjects([textField.styles objectForKey:@"font_size"], @"14.0");
    XCTAssertEqualObjects([textField.styles objectForKey:@"border_width"], @"1.0f");
    XCTAssertEqualObjects([textField.styles objectForKey:@"border_color"], @"#999999");
    XCTAssertEqualObjects([textField.styles objectForKey:@"corner_radius"], @"5.0f");
    XCTAssertEqualObjects([textField.styles objectForKey:@"active_background_color"], @"#FF0000");
    XCTAssertEqualObjects([textField.styles objectForKey:@"active_border_color"], @"#FF0000");
    XCTAssertEqualObjects([textField.styles objectForKey:@"inactive_background_color"], @"#999999");
    XCTAssertEqualObjects([textField.styles objectForKey:@"inactive_border_color"], @"#4C4C4C");
    XCTAssertEqualObjects([textField.styles objectForKey:@"enabled_background_color"], @"#FFFFFF");
    XCTAssertEqualObjects([textField.styles objectForKey:@"enabled_border_color"], @"#000000");
    XCTAssertEqualObjects([textField.styles objectForKey:@"enabled_text_color"], @"#000000");
    XCTAssertEqualObjects([textField.styles objectForKey:@"disabled_background_color"], @"#E6E6E6");
    XCTAssertEqualObjects([textField.styles objectForKey:@"disabled_border_color"], @"#666666");
    XCTAssertEqualObjects([textField.styles objectForKey:@"disabled_text_color"], @"#666666");
    XCTAssertEqualObjects([textField.styles objectForKey:@"valid_background_color"], @"#D6F5D6");
    XCTAssertEqualObjects([textField.styles objectForKey:@"valid_border_color"], @"#5CD65C");
    XCTAssertEqualObjects([textField.styles objectForKey:@"invalid_background_color"], @"#FFE6E6");
    XCTAssertEqualObjects([textField.styles objectForKey:@"invalid_border_color"], @"#FF3333");
    XCTAssertEqualObjects([textField.styles objectForKey:@"tooltip_font"], @"AvenirNext-Medium");
    XCTAssertEqualObjects([textField.styles objectForKey:@"tooltip_font_size"], @"14.0");
    XCTAssertEqualObjects([textField.styles objectForKey:@"tooltip_label_text_color"], @"#999999");
    XCTAssertEqualObjects([textField.styles objectForKey:@"tooltip_background_color"], @"#CCCCCC");
    XCTAssertEqualObjects([textField.styles objectForKey:@"clear_button_color"], @"#CCCCCC");
    XCTAssertEqualObjects([textField.styles objectForKey:@"minus_button_color"], @"#FF0000");
    XCTAssertEqualObjects([textField.styles objectForKey:@"plus_button_color"], @"#FF3333");


    // Group Header Styles
    NSArray *groups = [dataSource groups];
    __block FORMGroup *group = nil;
    [groups enumerateObjectsUsingBlock:^(FORMGroup *formGroup, NSUInteger idx, BOOL *stop) {
        if ([formGroup.groupID isEqualToString:@"buttons"]) {
            group = formGroup;
        }
    }];

    XCTAssertNotNil(group);

    [dataSource fieldCell:nil updatedWithField:textField];
    XCTAssertNotNil(group.styles);
    XCTAssertEqualObjects([group.styles objectForKey:@"font"], @"AvenirNext-DemiBold");
    XCTAssertEqualObjects([group.styles objectForKey:@"font_size"], @"17.0");
    XCTAssertEqualObjects([group.styles objectForKey:@"text_color"], @"#000000");
    XCTAssertEqualObjects([group.styles objectForKey:@"background_color"], @"#FFFFFF");
}

- (void)testPreCollapsedGroups{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"collapsed-groups.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    XCTAssertEqual([dataSource.collapsedGroups count], 1);
}

- (void)testCollapsibleGroups{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"collapsed-groups.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    XCTAssertEqual([dataSource.collapsedGroups count], 1);

    [dataSource collapseAllGroups];
    XCTAssertEqual([dataSource.collapsedGroups count], [dataSource.groups count] - 1);
}

@end
