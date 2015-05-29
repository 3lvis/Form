@import XCTest;

#import "FORMData.h"
#import "FORMField.h"
#import "FORMSection.h"
#import "FORMLayout.h"
#import "FORMDataSource.h"
#import "NSJSONSerialization+ANDYJSONFile.h"
#import "NSDate+HYPString.h"
#import "FORMNameInputValidator.h"
#import "FORMPhoneNumberInputValidator.h"

@interface FORMFieldTests : XCTestCase

@end

@implementation FORMFieldTests

- (void)testInitWithDictionary {
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    FORMField *field = [[FORMField alloc] initWithDictionary:@{@"id": @"first_name",
                                                               @"title": @"First name",
                                                               @"value": @"John Malkobitch",
                                                               @"type": @"name",
                                                               @"size": @{@"width": @30,
                                                                          @"height": @1},
                                                               @"hidden": @YES,
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
    XCTAssertEqualObjects(field.fieldValue.value, @"John Malkobitch");
    XCTAssertEqualObjects(field.typeString, @"name");
    XCTAssertTrue(field.type == FORMFieldTypeText);
    XCTAssertTrue(CGSizeEqualToSize(field.size, CGSizeMake(30, 1)));
    XCTAssertFalse(field.isDisabled);
    XCTAssertTrue(field.isHidden);
    XCTAssertNotNil(field.validation);

    field = [[FORMField alloc] initWithDictionary:@{@"id": @"start_date",
                                                    @"title": @"Start date",
                                                    @"type": @"date",
                                                    @"minimum_date":@"2000-01-01T00:00:00.002Z",
                                                    @"maximum_date":@"2015-01-01T00:00:00.002Z",
                                                    @"value":@"2014-01-01T00:00:00.002Z",
                                                    @"size": @{@"width": @10,
                                                               @"height": @4}
                                                    }
                                         position:1
                                         disabled:NO
                                disabledFieldsIDs:@[@"start_date"]];
    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.typeString, @"date");
    XCTAssertTrue(field.type == FORMFieldTypeDate);

    XCTAssertEqualObjects([field.minimumDate hyp_dateString], @"2000-01-01");
    XCTAssertEqualObjects([field.maximumDate hyp_dateString], @"2015-01-01");
    XCTAssertEqualObjects([field.fieldValue.value hyp_dateString], @"2014-01-01");

    XCTAssertTrue(CGSizeEqualToSize(field.size, CGSizeMake(10, 4)));
    XCTAssertTrue(field.isDisabled);
    XCTAssertNil(field.validation);
    XCTAssertFalse(field.isHidden);

    field = [[FORMField alloc] initWithDictionary:@{@"id": @"start_time",
                                                    @"title": @"Start time",
                                                    @"type": @"time",
                                                    @"minimum_date":@"2000-01-01T00:00:00.002Z",
                                                    @"maximum_date":@"2015-01-01T00:00:00.002Z",
                                                    @"value":@"2014-01-01T00:00:00.002Z",
                                                    @"size": @{@"width": @10,
                                                               @"height": @4}
                                                    }
                                         position:1
                                         disabled:NO
                                disabledFieldsIDs:@[@"start_time"]];
    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.typeString, @"time");
    XCTAssertTrue(field.type == FORMFieldTypeTime);

    XCTAssertEqualObjects([field.minimumDate hyp_dateString], @"2000-01-01");
    XCTAssertEqualObjects([field.maximumDate hyp_dateString], @"2015-01-01");
    XCTAssertEqualObjects([field.fieldValue.value hyp_dateString], @"2014-01-01");

    XCTAssertTrue(CGSizeEqualToSize(field.size, CGSizeMake(10, 4)));
    XCTAssertTrue(field.isDisabled);
    XCTAssertNil(field.validation);
    XCTAssertFalse(field.isHidden);


    field = [[FORMField alloc] initWithDictionary:@{@"id": @"dateAndTime",
                                                    @"title": @"Date and Time",
                                                    @"type": @"date_time",
                                                    @"minimum_date":@"2002-01-01T00:00:00.002Z",
                                                    @"maximum_date":@"2013-01-01T00:00:00.002Z",
                                                    @"value":@"2011-01-01T00:00:00.002Z",
                                                    @"size": @{@"width": @15,
                                                               @"height": @2}
                                                    }
                                         position:1
                                         disabled:NO
                                disabledFieldsIDs:@[@"other_field"]];
    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.typeString, @"date_time");
    XCTAssertTrue(field.type == FORMFieldTypeDateTime);

    XCTAssertEqualObjects([field.minimumDate hyp_dateString], @"2002-01-01");
    XCTAssertEqualObjects([field.maximumDate hyp_dateString], @"2013-01-01");
    XCTAssertEqualObjects([field.fieldValue.value hyp_dateString], @"2011-01-01");

    XCTAssertTrue(CGSizeEqualToSize(field.size, CGSizeMake(15, 2)));
    XCTAssertFalse(field.isDisabled);
    XCTAssertNil(field.validation);
    XCTAssertFalse(field.isHidden);
}

- (void)testInputValidator {
    FORMField *field;

    field = [[FORMField alloc] initWithDictionary:@{@"id" : @"text",
                                                    @"type" : @"text"}
                                         position:0
                                         disabled:NO
                                disabledFieldsIDs:nil];

    XCTAssertNil(field.inputValidator);

    field = [[FORMField alloc] initWithDictionary:@{@"id" : @"name",
                                                    @"type" : @"text"}
                                         position:0
                                         disabled:NO
                                disabledFieldsIDs:nil];

    XCTAssertEqualObjects([field.inputValidator class], [FORMNameInputValidator class]);

    field = [[FORMField alloc] initWithDictionary:@{@"id" : @"phone_number",
                                                    @"type" : @"text",
                                                    @"input_type" : @"number"}
                                         position:0
                                         disabled:NO
                                disabledFieldsIDs:nil];

    XCTAssertEqualObjects([field.inputValidator class], [FORMPhoneNumberInputValidator class]);

    field = [[FORMField alloc] initWithDictionary:@{@"id" : @"contact[0].phone_number",
                                                    @"type" : @"text",
                                                    @"input_type" : @"number"}
                                         position:0
                                         disabled:NO
                                disabledFieldsIDs:nil];

    XCTAssertEqualObjects([field.inputValidator class], [FORMNumberInputValidator class]);
}

- (void)testEmptyValue {
    FORMField *field = [[FORMField alloc] initWithDictionary:@{@"id" : @"text",
                                                               @"type" : @"text"}
                                                    position:0
                                                    disabled:NO
                                           disabledFieldsIDs:nil];
    field.fieldValue = [field fieldValueWithRawValue:@"Test"];
    XCTAssertEqualObjects(field.fieldValue.value, @"Test");

    field.fieldValue = [field fieldValueWithRawValue:@""];
    XCTAssertNil(field.fieldValue.value);
}

@end
