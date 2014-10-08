//
//  REMADropdownFormFieldCell.m
//  REMAForms
//
//  Created by Elvis Nunez on 08/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMADropdownFormFieldCell.h"

#import "REMAFieldValue.h"
#import "REMAFieldValuesTableViewController.h"

static const CGFloat REMADropdownFormIconWidth = 38.0f;
static const CGSize REMADropdownPopoverSize = { .width = 320.0f, .height = 240.0f };

@interface REMADropdownFormFieldCell () <REMATextFormFieldDelegate, REMAFieldValuesTableViewControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) REMATextFormField *textField;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIPopoverController *valuesPopover;
@property (nonatomic, strong) REMAFieldValuesTableViewController *fieldValuesController;

@end

@implementation REMADropdownFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.iconImageView];

    return self;
}

#pragma mark - Getters

- (REMATextFormField *)textField
{
    if (_textField) return _textField;

    _textField = [[REMATextFormField alloc] initWithFrame:[self frameForTextField]];
    _textField.formFieldDelegate = self;

    return _textField;
}

- (UIImageView *)iconImageView
{
    if (_iconImageView) return _iconImageView;

    _iconImageView = [[UIImageView alloc] initWithFrame:[self frameForIconImageView]];
    _iconImageView.image = [UIImage imageNamed:@"ic_mini_arrow_down"];
    _iconImageView.contentMode = UIViewContentModeRight;
    _iconImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return _iconImageView;
}

- (UIPopoverController *)valuesPopover
{
    if (_valuesPopover) return _valuesPopover;

    _valuesPopover = [[UIPopoverController alloc] initWithContentViewController:self.fieldValuesController];
    _valuesPopover.delegate = self;
    _valuesPopover.popoverContentSize = REMADropdownPopoverSize;
    _valuesPopover.backgroundColor = [UIColor whiteColor];

    return _valuesPopover;
}

- (REMAFieldValuesTableViewController *)fieldValuesController
{
    if (_fieldValuesController) return _fieldValuesController;

    _fieldValuesController = [[REMAFieldValuesTableViewController alloc] init];
    _fieldValuesController.delegate = self;

    return _fieldValuesController;
}

#pragma mark - Private headers

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.textField.enabled = !disabled;
}

- (void)updateWithField:(REMAFormField *)field
{
    self.textField.hidden = (field.sectionSeparator);
    self.textField.validator = [self.field validator];
    self.textField.formatter = [self.field formatter];
    self.textField.rawText = field.fieldValue;
    self.textField.typeString = field.typeString;

    self.fieldValuesController.field = field;
}

- (void)validate
{
    NSLog(@"validation in progress");
}

#pragma mark - Private methods

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.textField.frame = [self frameForTextField];
    self.iconImageView.frame = [self frameForIconImageView];
}

- (CGRect)frameForTextField
{
    CGFloat marginX = REMATextFormFieldCellMarginX;
    CGFloat marginTop = REMATextFormFieldCellTextFieldMarginTop;
    CGFloat marginBotton = REMATextFormFieldCellTextFieldMarginBottom;

    CGFloat width = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = CGRectGetHeight(self.frame) - marginTop - marginBotton;
    CGRect frame = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

- (CGRect)frameForIconImageView
{
    CGRect frame = [self frameForTextField];
    frame.origin.x = frame.size.width - REMADropdownFormIconWidth;
    frame.size.width = REMADropdownFormIconWidth;

    return frame;
}

#pragma mark - REMATextFormFieldDelegate

- (void)textFormFieldDidBeginEditing:(REMATextFormField *)textField
{
    self.fieldValuesController.field = self.field;

    [self.valuesPopover presentPopoverFromRect:self.bounds
                                        inView:self
                      permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown
                                      animated:YES];
}

#pragma mark - REMAFieldValuesTableViewControllerDelegate

- (void)fieldValuesTableViewController:(REMAFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(REMAFieldValue *)selectedValue
{
    self.field.fieldValue = selectedValue.title;
    [self updateWithField:self.field];
    
    [self.valuesPopover dismissPopoverAnimated:YES];
}

@end
