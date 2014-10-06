//
//  REMADropdownField.m
//  Mine Ansatte
//
//  Created by Christoffer Winterkvist on 7/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMADropdownField.h"
#import "REMABaseTableViewCell.h"
#import "REMAFieldValuesTableViewController.h"

@interface REMADropdownField () <UIPopoverControllerDelegate, REMAFieldValuesTableViewControllerDelegate>

@property (nonatomic, strong) UIPopoverController *valuesPopover;
@property (nonatomic, strong) REMAFieldValuesTableViewController *fieldValuesController;
@property (nonatomic) CGFloat rowHeight;

@end

@implementation REMADropdownField

static const CGSize REMADropdownPopoverSize = { .width = 320.0f, .height = 240.0f };

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self setUpIconImageViewWithFrame:frame];

    return self;
}

#pragma mark - Getters

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

    _fieldValuesController = [[REMAFieldValuesTableViewController alloc] initWithValues:self.values andSelectedValue:self.selectedValue];
    _fieldValuesController.delegate = self;

    return _fieldValuesController;
}

#pragma mark - Setters

- (void)setValues:(NSArray *)values
{
    _values = values;

    self.fieldValuesController.values = values;
    [self.fieldValuesController.tableView reloadData];

    CGSize size = self.valuesPopover.popoverContentSize;
    NSInteger cellCount = ((values.count < REMADropdownMaxCellCount) ? values.count : REMADropdownMaxCellCount);
    size.height = REMADropdownFieldCellHeight * cellCount;
    self.valuesPopover.popoverContentSize = size;
}

- (void)setSelectedValue:(REMAFieldValue *)fieldValue
{
    _selectedValue = fieldValue;

    self.text = fieldValue.title;

    if ([self.delegate respondsToSelector:@selector(textField:didUpdateWithContent:)]) {
        [self.delegate textField:self didUpdateWithContent:fieldValue.title];
    }
}

- (void)setDisabled:(BOOL)disabled
{
    [super setDisabled:disabled];

    self.iconImageView.hidden = disabled;
}

#pragma mark - Setup

- (void)setUpIconImageViewWithFrame:(CGRect)frame
{
    CGRect iconFrame = frame;
    iconFrame.origin.x -= 10;
    self.iconImageView.image = [UIImage imageNamed:@"ic_mini_arrow_down"];
    self.iconImageView.frame = iconFrame;
    self.iconImageView.contentMode = UIViewContentModeRight;
    self.iconImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - Popover Delegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    self.active = NO;

    return YES;
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self handleTouch];

    return NO;
}

#pragma mark - Touch gestures

- (void)handleTouch
{
    if (self.isDisabled) {
        return;
    }

    BOOL stateIsActive = !self.isActive;

    self.active = stateIsActive;

    if (stateIsActive) {
        [self.valuesPopover presentPopoverFromRect:self.frame
                                            inView:self
                          permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown
                                          animated:YES];
    }

    [self setNeedsDisplay];
}

#pragma mark - REMAFieldValuesTableViewControllerDelegate

- (void)fieldValuesTableViewController:(REMAFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(REMAFieldValue *)selectedValue
{
    self.selectedValue = selectedValue;

    [self.valuesPopover dismissPopoverAnimated:YES];

    self.active = NO;
}

#pragma mark - Public methods

- (REMAFieldValue *)selectValue:(NSString *)value
{
    for (REMAFieldValue *fieldValue in self.values) {
        if ([fieldValue.title isEqualToString:value]) {
            return fieldValue;
        }
    }

    return nil;
}

@end
