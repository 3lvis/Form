@import XCTest;

#import "FORMSection.h"

@interface FORMSectionTests : XCTestCase

@end

@implementation FORMSectionTests

- (void)testInitWithDictionary {
    FORMSection *section = [[FORMSection alloc] initWithDictionary:@{@"id": @"section"}
                                                          position:0
                                                          disabled:YES
                                                 disabledFieldsIDs:nil
                                                     isLastSection:NO];

    XCTAssertNotNil(section);
    XCTAssertEqualObjects(section.sectionID, @"section");
    XCTAssertEqualObjects(section.position, @0);
    XCTAssertTrue(section.fields.count == 1);

    section = [[FORMSection alloc] initWithDictionary:@{@"id": @"something"}
                                             position:1
                                             disabled:YES
                                    disabledFieldsIDs:nil
                                        isLastSection:YES];

    XCTAssertNotNil(section);
    XCTAssertEqualObjects(section.sectionID, @"something");
    XCTAssertEqualObjects(section.position, @1);
    XCTAssertTrue(section.fields.count == 0);
}

@end
