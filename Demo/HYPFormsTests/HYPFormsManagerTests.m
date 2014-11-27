@import XCTest;

#import "HYPFormsManager.h"

#import "NSJSONSerialization+ANDYJSONFile.h"

@interface HYPFormsManagerTests : XCTestCase

@end

@implementation HYPFormsManagerTests

- (void)testInitialization
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];

    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON initialValues:nil disabledFieldIDs:nil disabled:NO];

    XCTAssertNotNil(manager);
}

- (void)testFormsGeneration
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];

    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON initialValues:nil disabledFieldIDs:nil disabled:NO];

    XCTAssertNotNil(manager.forms);

    XCTAssertTrue(manager.forms.count > 0);
}

@end
