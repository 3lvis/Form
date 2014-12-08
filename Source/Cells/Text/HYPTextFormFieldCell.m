#import "HYPTextFormFieldCell.h"

#import "HYPPopoverBackgroundView.h"

#import "UIColor+ANDYHex.h"
#import "UIFont+HYPFormsStyles.h"

@interface HYPTextFormFieldCell () <HYPTextFieldDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) HYPTextField *textField;
@property (nonatomic, strong) UIPopoverController *popoverController;

@end

@implementation HYPTextFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.textField];

    return self;
}

#pragma mark - Getters

- (HYPTextField *)textField
{
    if (_textField) return _textField;

    _textField = [[HYPTextField alloc] initWithFrame:[self frameForTextField]];
    _textField.textFieldDelegate = self;

    return _textField;
}

- (CGRect)labelFrame
{
    return CGRectMake(0,0,200, 44);
}

- (UIPopoverController *)popoverController
{
    if (_popoverController) return _popoverController;

    UIViewController *viewController = [[UIViewController alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:[self labelFrame]];

    label.text = self.field.subtitle;
    label.font = [UIFont HYPFormsMediumSizeLight];
    label.textColor = [UIColor colorFromHex:@"97591D"];
    label.textAlignment = NSTextAlignmentCenter;

    [viewController.view addSubview:label];

    [HYPPopoverBackgroundView setTintColor:[UIColor colorWithRed:0.992 green:0.918 blue:0.329 alpha:1]];

    _popoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    _popoverController.delegate = self;
    _popoverController.popoverBackgroundViewClass = [HYPPopoverBackgroundView class];
    _popoverController.popoverContentSize = CGSizeMake(200, 44);
    _popoverController.passthroughViews = @[self.textField];

    return _popoverController;
}

#pragma mark - Private headers

- (BOOL)becomeFirstResponder
{
    [self.textField becomeFirstResponder];

    return [super becomeFirstResponder];
}

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.textField.enabled = !disabled;
}

- (void)updateWithField:(HYPFormField *)field
{
    self.textField.hidden          = (field.sectionSeparator);
    self.textField.inputValidator  = [self.field inputValidator];
    self.textField.formatter       = [self.field formatter];
    self.textField.typeString      = field.typeString;
    self.textField.enabled         = !field.disabled;
    self.textField.valid           = field.valid;
    self.textField.rawText         = [self rawTextForField:field];
}

- (void)validate
{
    [self.textField setValid:[self.field validate]];
}

- (NSString *)rawTextForField:(HYPFormField *)field
{
    if (field.fieldValue && field.type == HYPFormFieldTypeFloat) {

        NSNumber *value = field.fieldValue;

        if ([field.fieldValue isKindOfClass:[NSString class]]) {
            NSMutableString *fieldValue = [field.fieldValue mutableCopy];
            [fieldValue replaceOccurrencesOfString:@","
                                        withString:@"."
                                           options:NSCaseInsensitiveSearch
                                             range:NSMakeRange(0, [fieldValue length])];
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
            value = [formatter numberFromString:fieldValue];
        }

        return [NSString stringWithFormat:@"%.2f", [value floatValue]];
    }

    return field.fieldValue;
}

#pragma mark - Actions

- (void)focusAction
{
    [self.textField becomeFirstResponder];
}

- (void)clearAction
{
    self.field.fieldValue = nil;
    [self updateWithField:self.field];
}

#pragma mark - Private methods

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.textField.frame = [self frameForTextField];
}

- (CGRect)frameForTextField
{
    CGFloat marginX = HYPTextFormFieldCellMarginX;
    CGFloat marginTop = HYPFormFieldCellMarginTop;
    CGFloat marginBotton = HYPFormFieldCellMarginBottom;

    CGFloat width  = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = CGRectGetHeight(self.frame) - marginTop - marginBotton;
    CGRect  frame  = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

- (CGRect)popoverFrame
{
    CGRect frame = self.textField.frame;
    frame.origin.x = (frame.origin.x / 2.0f) - 12.5f;
    frame.origin.y -= 40.0f;

    return frame;
}

#pragma mark - UIPopoverDelegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    [self.textField resignFirstResponder];

    return YES;
}

#pragma mark - HYPTextFieldDelegate

- (void)textFormFieldDidBeginEditing:(HYPTextField *)textField
{
    if (self.field.subtitle) {
        [self.popoverController presentPopoverFromRect:[self popoverFrame] inView:self.textField permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
    }
}

- (void)textFormFieldDidEndEditing:(HYPTextField *)textField
{
    [self validate];

    if (!self.textField.valid) {
        [self.textField setValid:[self.field validate]];
    }

    if (self.popoverController.isPopoverVisible) {
        [self.popoverController dismissPopoverAnimated:YES];
    }
}

- (void)textFormField:(HYPTextField *)textField didUpdateWithText:(NSString *)text
{
    self.field.fieldValue = text;
    [self validate];

    if (!self.textField.valid) {
        [self.textField setValid:[self.field validate]];
    }

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

@end
