@import XCTest;

#import "FORMFieldElement.h"
#import "NSDate+HYPString.h"

@interface FORMFieldElementTests : XCTestCase

@end

@implementation FORMFieldElementTests

- (void)testInitWithDictionary {
    FORMFieldElement *fieldElement = [[FORMFieldElement alloc] initWithDictionary:@{@"title": @"First name",
                                                                                    @"info": @"Display name",
                                                                                    @"hidden": @NO,
                                                                                    @"size": @{@"width": @30,
                                                                                               @"height": @1},
                                                                                    @"minimum_date":@"2000-01-01T00:00:00.002Z",
                                                                                    @"maximum_date":@"2015-01-01T00:00:00.002Z",
                                                                                    @"validations": @{@"required": @YES,
                                                                                                      @"min_length": @2},
                                                                                    @"formula": @"first_name last_name"
                                                                                    }];
    XCTAssertNotNil(fieldElement);
    XCTAssertEqualObjects(fieldElement.title, @"First name");
    XCTAssertEqualObjects(fieldElement.info, @"Display name");
    XCTAssertFalse(fieldElement.hidden);
    XCTAssertTrue(CGSizeEqualToSize(fieldElement.size, CGSizeMake(30, 1)));
    XCTAssertEqualObjects([fieldElement.minimumDate hyp_dateString], @"2000-01-01");
    XCTAssertEqualObjects([fieldElement.maximumDate hyp_dateString], @"2015-01-01");
    XCTAssertNotNil(fieldElement.validation);
    XCTAssertEqualObjects(fieldElement.formula, @"first_name last_name");
}

@end
