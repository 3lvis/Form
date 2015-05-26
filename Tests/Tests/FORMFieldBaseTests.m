@import XCTest;

#import "FORMFieldBase.h"
#import "NSDate+HYPString.h"

@interface FORMFieldBaseTests : XCTestCase

@end

@implementation FORMFieldBaseTests

- (void)testInitWithDictionary {
    FORMFieldBase *fieldBase = [[FORMFieldBase alloc] initWithDictionary:@{@"title": @"First name",
                                                                           @"info": @"Display name",
                                                                           @"minimum_date":@"2000-01-01T00:00:00.002Z",
                                                                           @"maximum_date":@"2015-01-01T00:00:00.002Z",
                                                                           @"validations": @{@"required": @YES,
                                                                                             @"min_length": @2},
                                                                           @"formula": @"first_name last_name"
                                                                           }];
    XCTAssertNotNil(fieldBase);
    XCTAssertEqualObjects(fieldBase.title, @"First name");
    XCTAssertEqualObjects(fieldBase.info, @"Display name");
    XCTAssertEqualObjects([fieldBase.minimumDate hyp_dateString], @"2000-01-01");
    XCTAssertEqualObjects([fieldBase.maximumDate hyp_dateString], @"2015-01-01");
    XCTAssertNotNil(fieldBase.validation);
    XCTAssertEqualObjects(fieldBase.formula, @"first_name last_name");
}

@end
