@import XCTest;

#import "HYPFormsManager.h"

#import "NSJSONSerialization+ANDYJSONFile.h"

@interface HYPFormsManagerTests : XCTestCase

@end

@implementation HYPFormsManagerTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInitialization
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[HYPFormsManagerTests class]]];

    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON initialValues:nil disabledFieldIDs:nil];
    XCTAssertNotNil(manager);
}

- (void)testFormsGeneration
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[HYPFormsManagerTests class]]];

    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON initialValues:nil disabledFieldIDs:nil];

    XCTAssertNotNil(manager.forms);

    XCTAssertTrue(manager.forms.count > 0);
}

@end
