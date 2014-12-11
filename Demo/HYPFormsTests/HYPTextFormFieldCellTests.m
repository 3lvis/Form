@import UIKit;
@import XCTest;

#import "HYPTextFormFieldCell.h"

@interface HYPTextFormFieldCell (Tests)

- (CGRect)labelFrameUsingString:(NSString *)string;

@end

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
