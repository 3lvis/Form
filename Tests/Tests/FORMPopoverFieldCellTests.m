@import XCTest;

#import "FORMPopoverFieldCell.h"

#import "FORMField+Tests.h"

@interface FORMPopoverFieldCellTests : XCTestCase

@end

@implementation FORMPopoverFieldCellTests

- (void)testPopoverSelectionWithDisabledField {
    FORMPopoverFieldCell *cell = [FORMPopoverFieldCell new];
    FORMField *field = [FORMField contractTypeField];

    cell.field = field;
    XCTAssertTrue(cell.fieldValueLabel.userInteractionEnabled);

    field.disabled = YES;
    cell.field = field;
    XCTAssertFalse(cell.fieldValueLabel.userInteractionEnabled);
}

@end
