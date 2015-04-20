//
//  FORMEmailFormatterTests.m
//  Tests
//
//  Created by Vadym Markov on 20/04/15.
//  Copyright (c) 2015 Hyper. All rights reserved.
//

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
