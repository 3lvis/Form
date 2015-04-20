@import XCTest;

#import "FORMEmailFormatter.h"

@interface FORMEmailFormatterTests : XCTestCase

@end

@implementation FORMEmailFormatterTests

- (void)testFormatString {
    FORMEmailFormatter *formatter = [FORMEmailFormatter new];
    NSString *inputString = @"t,e,st@example.com";
    XCTAssertTrue([@"test@example.com" isEqualToString:[formatter formatString:inputString reverse:NO]]);
}

@end
