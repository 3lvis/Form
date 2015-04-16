@import XCTest;

#import "FORMGroup.h"

@interface FORMTests : XCTestCase

@end

@implementation FORMTests

- (void)testInitWithDictionary {
    FORMGroup *group = [[FORMGroup alloc] initWithDictionary:@{@"id": @"some_form",
                                                              @"title": @"Some form"}
                                                   position:0
                                                   disabled:NO
                                          disabledFieldsIDs:nil];

    XCTAssertNotNil(group);
    XCTAssertEqualObjects(group.groupID, @"some_form");
    XCTAssertEqualObjects(group.title, @"Some form");
    XCTAssertEqualObjects(group.position, @0);

    group = [[FORMGroup alloc] initWithDictionary:@{@"id": @"other_form",
                                                   @"title": @"Other form"}
                                        position:1
                                        disabled:NO
                               disabledFieldsIDs:nil];

    XCTAssertNotNil(group);
    XCTAssertEqualObjects(group.groupID, @"other_form");
    XCTAssertEqualObjects(group.title, @"Other form");
    XCTAssertEqualObjects(group.position, @1);
}

@end
