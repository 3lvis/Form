@import XCTest;

#import "FORMGroup.h"

@interface FORMTests : XCTestCase

@end

@implementation FORMTests

- (void)testInitWithDictionary
{
    FORMGroup *form = [[FORMGroup alloc] initWithDictionary:@{@"id": @"some_form",
                                                              @"title": @"Some form"}
                                                   position:0
                                                   disabled:NO
                                          disabledFieldsIDs:nil];

    XCTAssertNotNil(form);
    XCTAssertEqualObjects(form.formID, @"some_form");
    XCTAssertEqualObjects(form.title, @"Some form");
    XCTAssertEqualObjects(form.position, @0);

    form = [[FORMGroup alloc] initWithDictionary:@{@"id": @"other_form",
                                                   @"title": @"Other form"}
                                        position:1
                                        disabled:NO
                               disabledFieldsIDs:nil];

    XCTAssertNotNil(form);
    XCTAssertEqualObjects(form.formID, @"other_form");
    XCTAssertEqualObjects(form.title, @"Other form");
    XCTAssertEqualObjects(form.position, @1);
}

@end
