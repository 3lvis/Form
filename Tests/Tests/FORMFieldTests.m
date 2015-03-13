@import XCTest;

#import "FORMData.h"
#import "FORMField.h"
#import "FORMSection.h"
#import "FORMLayout.h"
#import "FORMDataSource.h"
#import "NSJSONSerialization+ANDYJSONFile.h"

@interface FORMFieldTests : XCTestCase

@end

@implementation FORMFieldTests

- (void)testInitWithDictionary
{
    FORMField *field = [[FORMField alloc] initWithDictionary:@{@"id": @"first_name",
                                                               @"title": @"First name",
                                                               @"value": @"John Malkobitch",
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
    XCTAssertTrue(field.type == FORMFieldTypeText);
    XCTAssertTrue(CGSizeEqualToSize(field.size, CGSizeMake(30, 1)));
    XCTAssertFalse(field.disabled);
    XCTAssertNotNil(field.validation);

    field = [[FORMField alloc] initWithDictionary:@{@"id": @"start_date",
                                                    @"title": @"Start date",
                                                    @"type": @"date",
                                                    @"size": @{@"width": @10,
                                                               @"height": @4}
                                                    }
                                         position:1
                                         disabled:NO
                                disabledFieldsIDs:@[@"start_date"]];
    XCTAssertNotNil(field);
    XCTAssertEqualObjects(field.typeString, @"date");
    XCTAssertTrue(field.type == FORMFieldTypeDate);
    XCTAssertTrue(CGSizeEqualToSize(field.size, CGSizeMake(10, 4)));
    XCTAssertTrue(field.disabled);
    XCTAssertNil(field.validation);
}

@end
