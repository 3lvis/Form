@import XCTest;

#import "HYPForm.h"

@interface HYPFormTests : XCTestCase

@end

@implementation HYPFormTests

- (void)testInitWithDictionary
{
    NSDictionary *dictionary = @{@"id": @"some_form",
                                 @"title": @"Some form"};

    HYPForm *form = [[HYPForm alloc] initWithDictionary:dictionary
                                               position:0
                                               disabled:NO
                                      disabledFieldsIDs:nil];

    XCTAssertNotNil(form);
    XCTAssertEqualObjects(form.formID, @"some_form");
    XCTAssertEqualObjects(form.title, @"Some form");
    XCTAssertEqualObjects(form.position, @0);

    NSDictionary *otherDictionary = @{@"id": @"other_form",
                                      @"title": @"Other form"};

    HYPForm *otherForm = [[HYPForm alloc] initWithDictionary:otherDictionary
                                                    position:1
                                                    disabled:NO
                                           disabledFieldsIDs:nil];

    XCTAssertNotNil(otherForm);
    XCTAssertEqualObjects(otherForm.formID, @"other_form");
    XCTAssertEqualObjects(otherForm.title, @"Other form");
    XCTAssertEqualObjects(otherForm.position, @1);
}

@end
