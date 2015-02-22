@import XCTest;

#import "FORMPopoverFieldCell.h"

#import "HYPFormField+Tests.h"

@interface HYPPopoverFormFieldCellTests : XCTestCase

@end

@implementation HYPPopoverFormFieldCellTests

- (void)testPopoverSelectionWithDisabledField
{
    FORMPopoverFieldCell *cell = [[FORMPopoverFieldCell alloc] init];
    FORMField *field = [FORMField contractTypeField];

    cell.field = field;
    XCTAssertTrue(cell.fieldValueLabel.userInteractionEnabled);

    field.disabled = YES;
    cell.field = field;
    XCTAssertFalse(cell.fieldValueLabel.userInteractionEnabled);
}

@end
