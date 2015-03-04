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

@interface FORMDataSource ()

- (void)fieldCell:(UICollectionViewCell *)fieldCell updatedWithField:(FORMField *)field;

@end

@interface FORMCollectionViewDataSourceTests : XCTestCase

@end

@implementation FORMCollectionViewDataSourceTests

- (void)testIndexInForms
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    [dataSource processTarget:[FORMTarget hideFieldTargetWithID:@"display_name"]];
    [dataSource processTarget:[FORMTarget showFieldTargetWithID:@"display_name"]];
    FORMField *field = [dataSource fieldWithID:@"display_name" includingHiddenFields:YES];
    NSUInteger index = [field indexInSectionUsingForms:dataSource.forms];
    XCTAssertEqual(index, 2);

    [dataSource processTarget:[FORMTarget hideFieldTargetWithID:@"username"]];
    [dataSource processTarget:[FORMTarget showFieldTargetWithID:@"username"]];
    field = [dataSource fieldWithID:@"username" includingHiddenFields:YES];
    index = [field indexInSectionUsingForms:dataSource.forms];
    XCTAssertEqual(index, 2);

    [dataSource processTargets:[FORMTarget hideFieldTargetsWithIDs:@[@"first_name",
                                                                     @"address",
                                                                     @"username"]]];
    [dataSource processTarget:[FORMTarget showFieldTargetWithID:@"username"]];
    field = [dataSource fieldWithID:@"username" includingHiddenFields:YES];
    index = [field indexInSectionUsingForms:dataSource.forms];
    XCTAssertEqual(index, 1);
    [dataSource processTargets:[FORMTarget showFieldTargetsWithIDs:@[@"first_name",
                                                                     @"address"]]];

    [dataSource processTargets:[FORMTarget hideFieldTargetsWithIDs:@[@"last_name",
                                                                     @"address"]]];
    [dataSource processTarget:[FORMTarget showFieldTargetWithID:@"address"]];
    field = [dataSource fieldWithID:@"address" includingHiddenFields:YES];
    index = [field indexInSectionUsingForms:dataSource.forms];
    XCTAssertEqual(index, 0);
    [dataSource processTarget:[FORMTarget showFieldTargetWithID:@"last_name"]];
}

- (void)testEnableAndDisableTargets
{
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
    [dataSource processTarget:disableTarget];
    XCTAssertTrue(targetField.isDisabled);

    FORMTarget *enableTarget = [FORMTarget enableFieldTargetWithID:@"base_salary"];
    [dataSource processTargets:@[enableTarget]];
    XCTAssertFalse(targetField.isDisabled);

    [dataSource disable];
    XCTAssertTrue(targetField.isDisabled);

    [dataSource enable];
    XCTAssertFalse(targetField.isDisabled);
}

- (void)testInitiallyDisabled
{
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

- (void)testUpdatingTargetValue
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMField *targetField = [dataSource fieldWithID:@"display_name" includingHiddenFields:YES];
    XCTAssertNil(targetField.fieldValue);

    FORMTarget *updateTarget = [FORMTarget updateFieldTargetWithID:@"display_name"];
    updateTarget.targetValue = @"John Hyperseed";

    [dataSource processTarget:updateTarget];
    XCTAssertEqualObjects(targetField.fieldValue, @"John Hyperseed");
}

- (void)testDefaultValue
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMField *usernameField = [dataSource fieldWithID:@"username" includingHiddenFields:YES];
    XCTAssertNotNil(usernameField.fieldValue);
}

- (void)testCondition
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMField *displayNameField = [dataSource fieldWithID:@"display_name" includingHiddenFields:YES];
    FORMField *usernameField = [dataSource fieldWithID:@"username" includingHiddenFields:YES];
    FORMFieldValue *fieldValue = usernameField.fieldValue;
    XCTAssertEqualObjects(fieldValue.valueID, @0);

    FORMTarget *updateTarget = [FORMTarget updateFieldTargetWithID:@"display_name"];
    updateTarget.targetValue = @"Mr.Melk";

    updateTarget.condition = @"$username == 2";
    [dataSource processTarget:updateTarget];
    XCTAssertNil(displayNameField.fieldValue);

    updateTarget.condition = @"$username == 0";
    [dataSource processTarget:updateTarget];
    XCTAssertEqualObjects(displayNameField.fieldValue, @"Mr.Melk");
}

- (void)testReloadWithDictionary
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    [dataSource reloadWithDictionary:@{@"first_name" : @"Elvis",
                                       @"last_name" : @"Nunez"}];

    FORMField *field = [dataSource fieldWithID:@"display_name" includingHiddenFields:YES];
    XCTAssertEqualObjects(field.fieldValue, @"Elvis Nunez");
}

- (void)testClearTarget
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMField *firstNameField = [dataSource fieldWithID:@"first_name" includingHiddenFields:YES];
    XCTAssertNotNil(firstNameField);

    firstNameField.fieldValue = @"John";
    XCTAssertNotNil(firstNameField.fieldValue);

    FORMTarget *clearTarget = [FORMTarget clearFieldTargetWithID:@"first_name"];
    [dataSource processTarget:clearTarget];
    XCTAssertNil(firstNameField.fieldValue);
}

- (void)testFormFieldsAreValid
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"field-validations.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];
    XCTAssertFalse([dataSource formFieldsAreValid]);

    [dataSource reloadWithDictionary:@{@"first_name" : @"Supermancito"}];

    XCTAssertTrue([dataSource formFieldsAreValid]);
}

- (void)testAddingAndRemovingDynamicFields
{
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

    section = [dataSource sectionWithID:@"companies[1]"];
    XCTAssertNotNil(section);

    nameField = [dataSource fieldWithID:@"companies[1].name" includingHiddenFields:NO];
    XCTAssertNotNil(nameField);

    phoneNumberField = [dataSource fieldWithID:@"companies[1].phone_number" includingHiddenFields:NO];
    XCTAssertNotNil(phoneNumberField);

    removeField = [dataSource fieldWithID:@"companies[1].remove" includingHiddenFields:NO];
    XCTAssertNotNil(removeField);
}

- (void)testDynamicWithInitialValues
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:@{@"companies[0].name" : @"Facebook",
                                                                        @"companies[0].phone_number" : @"1222333",
                                                                        @"companies[1].name" : @"Google",
                                                                        @"companies[1].phone_number" : @"4555666"}
                                                             disabled:YES];

    FORMSection *section = [dataSource sectionWithID:@"companies[0]"];
    XCTAssertNotNil(section);

    FORMField *field = [dataSource fieldWithID:@"companies[0].name" includingHiddenFields:NO];
    XCTAssertEqualObjects(field.fieldValue, @"Facebook");

    field = [dataSource fieldWithID:@"companies[0].phone_number" includingHiddenFields:NO];
    XCTAssertEqualObjects(field.fieldValue, @"1222333");

    section = [dataSource sectionWithID:@"companies[1]"];
    XCTAssertNotNil(section);

    field = [dataSource fieldWithID:@"companies[1].name" includingHiddenFields:NO];
    XCTAssertEqualObjects(field.fieldValue, @"Google");

    field = [dataSource fieldWithID:@"companies[1].phone_number" includingHiddenFields:NO];
    XCTAssertEqualObjects(field.fieldValue, @"4555666");
}

- (void)testAddingAndRemovingMultipleDynamicSections
{
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

    [dataSource fieldWithID:@"contacts[0].name" includingHiddenFields:NO completion:^(FORMField *field, NSIndexPath *indexPath) {
        fieldIndexPath = indexPath;
    }];

    XCTAssertEqualObjects(fieldIndexPath, [NSIndexPath indexPathForRow:14 inSection:0]);
}

- (void)testUpdatedSectionPositionWhenRemovingDynamicSections
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"dynamic.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:nil
                                                               values:nil
                                                             disabled:YES];

    FORMField *addField = [dataSource fieldWithID:@"companies.add" includingHiddenFields:NO];
    XCTAssertNotNil(addField);

    [dataSource fieldCell:nil updatedWithField:addField];

    FORMField *removeField = [dataSource fieldWithID:@"companies[0].remove" includingHiddenFields:NO];
    XCTAssertNotNil(removeField);

    FORMSection *section = [dataSource sectionWithID:@"companies[0]"];
    XCTAssertNotNil(section);
    XCTAssertEqualObjects(section.position, @1);

    [dataSource fieldCell:nil updatedWithField:removeField];

    section = [dataSource sectionWithID:@"personal-details-1"];
    XCTAssertEqualObjects(section.position, @2);
    XCTAssertNotNil(section);
}

- (void)testDynamicSectionsInvolvingHideTargets
{
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

    FORMField *field = [dataSource fieldWithID:@"contacts[0].name" includingHiddenFields:NO];
    XCTAssertEqualObjects(field.position, @3);
}

@end
