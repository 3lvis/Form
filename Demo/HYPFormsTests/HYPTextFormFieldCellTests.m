@import UIKit;

#import <XCTest/XCTest.h>
#import "HYPTextFormFieldCell.h"
#import "HYPTextFormFieldCell+Tests.h"

@interface HYPTextFormFieldCellTests : XCTestCase

@end

@implementation HYPTextFormFieldCellTests

- (void)testWidthCalculation
{
    HYPTextFormFieldCell *cell = [[HYPTextFormFieldCell alloc] init];
    CGRect rect = [cell labelFrameUsingString:@"bork"];
    XCTAssertEqual(rect.size.width, 90.0f);
    XCTAssertEqual(rect.size.height, 55.0f);

    rect = [cell labelFrameUsingString:@"bork\nbork\nboork"];
    XCTAssertEqual(rect.size.width, 90.0f);
    XCTAssertEqual(rect.size.height, 77.0f);

    rect = [cell labelFrameUsingString:@"bork\nborkborkborkbork\nboork"];
    XCTAssertEqual(rect.size.width, 128.0f);
    XCTAssertEqual(rect.size.height, 77.0f);
}

@end
