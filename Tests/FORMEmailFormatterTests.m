@import XCTest;

#import "FORMEmailFormatter.h"

@interface FORMEmailFormatterTests : XCTestCase

@end

@implementation FORMEmailFormatterTests

- (void)testFormatString {
    FORMEmailFormatter *formatter = [FORMEmailFormatter new];
    XCTAssertEqualObjects(@"test@example.com", [formatter formatString:@"t,e,st@example.com" reverse:NO]);
}

@end
