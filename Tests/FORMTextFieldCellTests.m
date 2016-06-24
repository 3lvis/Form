@import UIKit;
@import XCTest;

#import "FORMTextFieldCell.h"

@interface FORMTextFieldCell (Tests)

- (CGRect)labelFrameUsingString:(NSString *)string;
- (NSString *)rawTextForField:(FORMField *)field;

@end

@interface FORMTextFormFieldCellTests : XCTestCase

@end

@implementation FORMTextFormFieldCellTests

- (void)testWidthCalculation {
    FORMTextFieldCell *cell = [FORMTextFieldCell new];
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

- (void)testRawTextForField {
    FORMTextFieldCell *cell = [FORMTextFieldCell new];
    FORMField *field = [FORMField new];
    field.value = @1;
    field.type = FORMFieldTypeNumber;
    XCTAssertEqualObjects([cell rawTextForField:field], @"1");

    field.value = @1.1;
    field.type = FORMFieldTypeFloat;
    XCTAssertEqualObjects([cell rawTextForField:field], @"1.10");

    field.value = @"1";
    field.type = FORMFieldTypeText;
    XCTAssertEqualObjects([cell rawTextForField:field], @"1");
}

@end
