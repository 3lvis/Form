@import UIKit;
@import XCTest;

#import "FORMTextField.h"
#import "FORMField+Tests.h"
#import "FORMField.h"

@interface FORMTextFieldTests : XCTestCase

@property (nonatomic, strong) UIColor* invalidColor;
@property (nonatomic, strong) UIColor* validColor;
@property (nonatomic, strong) UIColor* disabledColor;

@end

@implementation FORMTextFieldTests

- (void)testNotValidWithEnabledField {
    FORMTextField *field = [self formField];
    field.enabled = YES;
    field.valid = NO;

    XCTAssertTrue(CGColorEqualToColor(field.backgroundColor.CGColor, self.invalidColor.CGColor));
    XCTAssertTrue(CGColorEqualToColor(field.layer.borderColor, self.invalidColor.CGColor));
}

- (void)testNotValidWithDisabledField {
    FORMTextField *field = [self formField];
    field.enabled = NO;
    field.valid = NO;

    XCTAssertTrue(CGColorEqualToColor(field.backgroundColor.CGColor, self.invalidColor.CGColor));
    XCTAssertTrue(CGColorEqualToColor(field.layer.borderColor, self.invalidColor.CGColor));
}

- (void)testValidWithEnabledField {
    FORMTextField *field = [self formField];
    field.enabled = YES;
    field.valid = YES;

    XCTAssertTrue(CGColorEqualToColor(field.backgroundColor.CGColor, self.validColor.CGColor));
    XCTAssertTrue(CGColorEqualToColor(field.layer.borderColor, self.validColor.CGColor));
}

- (void)testValidWithDisabledField {
    FORMTextField *field = [self formField];
    field.enabled = NO;
    field.valid = YES;

    XCTAssertTrue(CGColorEqualToColor(field.backgroundColor.CGColor, self.disabledColor.CGColor));
    XCTAssertTrue(CGColorEqualToColor(field.layer.borderColor, self.disabledColor.CGColor));
}

#pragma mark - Helpers

- (UIColor*)invalidColor
{
    if (!_invalidColor) {
        _invalidColor = [UIColor redColor];
    }
    return _invalidColor;
}

- (UIColor*)validColor
{
    if (!_validColor) {
        _validColor = [UIColor greenColor];
    }
    return _validColor;
}

- (UIColor*)disabledColor
{
    if (!_disabledColor) {
        _disabledColor = [UIColor grayColor];
    }
    return _disabledColor;
}


- (FORMTextField *)formField {
    FORMTextField *field = [FORMTextField new];
    field.typeString = @"float";
    field.type = FORMFieldTypeFloat;
    [field setInvalidBackgroundColor:self.invalidColor];
    [field setInvalidBorderColor:self.invalidColor];
    [field setDisabledBackgroundColor:self.disabledColor];
    [field setDisabledBorderColor:self.disabledColor];
    [field setValidBackgroundColor:self.validColor];
    [field setValidBorderColor:self.validColor];

    return field;
}

@end
