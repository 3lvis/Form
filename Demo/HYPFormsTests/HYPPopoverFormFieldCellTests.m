@import XCTest;

#import "HYPPopoverFormFieldCell.h"

#import "HYPFormField+Tests.h"

@interface HYPPopoverFormFieldCellTests : XCTestCase

@end

@implementation HYPPopoverFormFieldCellTests

- (void)testPopoverSelectionWithDisabledField
{
    HYPPopoverFormFieldCell *cell = [[HYPPopoverFormFieldCell alloc] init];
    HYPFormField *field = [HYPFormField contractTypeField];

    cell.field = field;
    XCTAssertTrue(cell.fieldValueLabel.userInteractionEnabled);

    field.disabled = YES;
    cell.field = field;
    XCTAssertFalse(cell.fieldValueLabel.userInteractionEnabled);
}

@end
