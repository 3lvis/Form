@import XCTest;

#import "HYPFormSection.h"

@interface HYPFormSectionTests : XCTestCase

@end

@implementation HYPFormSectionTests

- (void)testInitWithDictionary
{
    NSDictionary *dictionary = @{@"id": @"section"};

    HYPFormSection *section = [[HYPFormSection alloc] initWithDictionary:dictionary
                                                                position:0
                                                                disabled:YES
                                                       disabledFieldsIDs:nil
                                                           isLastSection:NO];

    XCTAssertNotNil(section);
    XCTAssertEqualObjects(section.sectionID, @"section");
    XCTAssertEqualObjects(section.position, @0);
    XCTAssertTrue(section.fields.count == 1);

    NSDictionary *lastSectionDictionary = @{@"id": @"something"};

    HYPFormSection *lastSection = [[HYPFormSection alloc] initWithDictionary:lastSectionDictionary
                                                                    position:0
                                                                    disabled:YES
                                                           disabledFieldsIDs:nil
                                                               isLastSection:YES];

    XCTAssertNotNil(lastSection);
    XCTAssertEqualObjects(lastSection.sectionID, @"something");
    XCTAssertEqualObjects(lastSection.position, @0);
    XCTAssertTrue(lastSection.fields.count == 0);
}

@end
