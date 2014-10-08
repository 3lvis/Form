//
//  REMADateFormFieldCell.m
//  REMAForms
//
//  Created by Elvis Nunez on 08/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMADateFormFieldCell.h"

#import "HYPTimeViewController.h"

static NSString * const REMADateFieldFormat = @"yyyy-MM-dd";

static const CGSize REMADatePopoverSize = { 320.0f, 216.0f };

@interface REMADateFormFieldCell () <REMATextFormFieldDelegate, HYPTimeViewControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) REMATextFormField *textField;

@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) HYPTimeViewController *timeViewController;

@end

@implementation REMADateFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.textField];

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

- (UIPopoverController *)popoverController
{
    if (_popoverController) return _popoverController;

    _popoverController = [[UIPopoverController alloc] initWithContentViewController:self.timeViewController];
    _popoverController.delegate = self;
    _popoverController.popoverContentSize = REMADatePopoverSize;
    _popoverController.backgroundColor = [UIColor whiteColor];

    return _popoverController;
}

- (HYPTimeViewController *)timeViewController
{
    if (_timeViewController) return _timeViewController;

    _timeViewController = [[HYPTimeViewController alloc] initWithDate:[NSDate date]];
    _timeViewController.delegate = self;
    _timeViewController.birthdayPicker = YES;

    return _timeViewController;
}

#pragma mark - Private headers

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.textField.enabled = !disabled;
}

- (void)updateWithField:(REMAFormField *)field
{
    if (field.fieldValue) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = REMADateFieldFormat;
        self.textField.rawText = [formatter stringFromDate:field.fieldValue];
    }

    self.textField.hidden = (field.sectionSeparator);
    self.textField.validator = [self.field validator];
    self.textField.formatter = [self.field formatter];
    self.textField.typeString = field.typeString;
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

#pragma mark - REMATextFormFieldDelegate

- (void)textFormFieldDidBeginEditing:(REMATextFormField *)textField
{
    if (self.field.fieldValue) {
        self.timeViewController.currentDate = self.field.fieldValue;
    }

    if (!self.popoverController.isPopoverVisible) {
        [self.popoverController presentPopoverFromRect:self.bounds
                                            inView:self
                          permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown
                                          animated:YES];
    }
}

#pragma mark - HYPTimeViewControllerDelegate

- (void)timeController:(HYPTimeViewController *)timeController didChangedDate:(NSDate *)date
{
    self.field.fieldValue = date;

    [self updateWithField:self.field];

    [self.popoverController dismissPopoverAnimated:YES];
}

@end
