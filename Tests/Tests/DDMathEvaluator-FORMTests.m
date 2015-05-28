@import XCTest;

#import "DDMathEvaluator+FORM.h"

@interface DDMathEvaluator_FORMTests : XCTestCase

@end

@implementation DDMathEvaluator_FORMTests

- (void)testDirectoryFunctionsWithError {
    NSError *error = nil;
    NSDictionary *dictionary = [DDMathEvaluator hyp_directoryFunctionsWithError:&error];
    NSArray *keys = [dictionary.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *comparedKeys = [@[@"present", @"equals", @"missing"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    XCTAssertEqualObjects(keys, comparedKeys);
}

@end
