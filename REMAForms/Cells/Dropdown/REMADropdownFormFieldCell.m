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

@interface REMADropdownFormFieldCell () <REMATextFormFieldDelegate, REMAFieldValuesTableViewControllerDelegate>

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) REMAFieldValuesTableViewController *fieldValuesController;

@end

@implementation REMADropdownFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame contentViewController:self.fieldValuesController
                 andContentSize:REMADropdownPopoverSize];
    if (!self) return nil;

    [self.contentView addSubview:self.iconImageView];

    return self;
}

#pragma mark - Getters

- (UIImageView *)iconImageView
{
    if (_iconImageView) return _iconImageView;

    _iconImageView = [[UIImageView alloc] initWithFrame:[self frameForIconImageView]];
    _iconImageView.image = [UIImage imageNamed:@"ic_mini_arrow_down"];
    _iconImageView.contentMode = UIViewContentModeRight;
    _iconImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return _iconImageView;
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

    self.iconImageView.frame = [self frameForIconImageView];
}

- (CGRect)frameForIconImageView
{
    CGRect frame = self.textField.frame;
    frame.origin.x = frame.size.width - REMADropdownFormIconWidth;
    frame.size.width = REMADropdownFormIconWidth;

    return frame;
}

#pragma mark - REMAFieldValuesTableViewControllerDelegate

- (void)fieldValuesTableViewController:(REMAFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(REMAFieldValue *)selectedValue
{
    self.field.fieldValue = selectedValue.title;
    [self updateWithField:self.field];
    
    [self.popoverController dismissPopoverAnimated:YES];
}

@end
