@import XCTest;

#import "HYPFormsManager.h"
#import "HYPFormField.h"
#import "HYPFormSection.h"
#import "HYPFormsLayout.h"
#import "HYPFormsCollectionViewDataSource.h"
#import "NSJSONSerialization+ANDYJSONFile.h"

@interface HYPFormFieldTests : XCTestCase

@end

@implementation HYPFormFieldTests

- (void)testInitWithDictionary
{
    HYPFormField *field = [[HYPFormField alloc] initWithDictionary:@{@"id": @"first_name",
                                                                     @"title": @"First name",
                                                                     @"type": @"name",
                                                                     @"size": @{@"width": @30,
                                                                                @"height": @1},
                                                                     @"validations": @{@"required": @YES,
                                                                                       @"min_length": @2}
                                                                     }
                                                          position:0
                                                          disabled:NO
                                                 disabledFieldsIDs:nil];

    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.position, @0);
    XCTAssertEqualObjects(field.fieldID, @"first_name");
    XCTAssertEqualObjects(field.title, @"First name");
    XCTAssertEqualObjects(field.typeString, @"name");
    XCTAssertTrue(field.type == HYPFormFieldTypeText);
    XCTAssertTrue(CGSizeEqualToSize(field.size, CGSizeMake(30, 1)));
    XCTAssertFalse(field.disabled);
    XCTAssertNotNil(field.validations);

    field = [[HYPFormField alloc] initWithDictionary:@{@"id": @"start_date",
                                                       @"title": @"Start date",
                                                       @"type": @"date",
                                                       @"size": @{@"width": @10,
                                                                  @"height": @4}
                                                       }
                                            position:1
                                            disabled:NO
                                   disabledFieldsIDs:@[@"start_date"]];

    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.position, @1);
    XCTAssertEqualObjects(field.fieldID, @"start_date");
    XCTAssertEqualObjects(field.title, @"Start date");
    XCTAssertEqualObjects(field.typeString, @"date");
    XCTAssertTrue(field.type == HYPFormFieldTypeDate);
    XCTAssertTrue(CGSizeEqualToSize(field.size, CGSizeMake(10, 4)));
    XCTAssertTrue(field.disabled);
    XCTAssertNil(field.validations);
}

- (void)testFieldWithID
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];

    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON
                                                       initialValues:@{@"first_name" : @"Elvis",
                                                                       @"last_name" : @"Nunez"}
                                                    disabledFieldIDs:nil
                                                            disabled:NO];

    HYPFormField *field = [manager fieldWithID:@"first_name" includingHiddenFields:YES];
    XCTAssertEqualObjects(field.fieldID, @"first_name");

    [manager indexForFieldWithID:field.fieldID
                 inSectionWithID:field.section.sectionID
                      completion:^(HYPFormSection *section, NSInteger index) {
                          if (section) [section.fields removeObjectAtIndex:index];
                      }];

    field = [manager fieldWithID:@"first_name" includingHiddenFields:YES];

    XCTAssertNil(field);
}

@end
