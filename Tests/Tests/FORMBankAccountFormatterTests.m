@import XCTest;

#import "FORMBankAccountNumberFormatter.h"

@interface FORMBankAccountFormatterTests : XCTestCase

@end

@implementation FORMBankAccountFormatterTests

- (void)testFormatString {
    FORMBankAccountNumberFormatter *formatter = [FORMBankAccountNumberFormatter new];
    XCTAssertEqualObjects([formatter formatString:@"00000000000" reverse:NO], @"0000.00.00000");
}

@end
