//
//  HYPTimeViewController.m
//  RemaDrifts
//
//  Created by Elvis Nunez on 1/22/13.
//  Copyright (c) 2013 Hyper. All rights reserved.
//

#import "HYPTimeViewController.h"

#import "NSString+ANDYSizes.h"
#import "UIFont+Styles.h"
#import "UIColor+Colors.h"

#import "REMADateFormFieldCell.h"

static CGFloat const REMAActionTitleLabelY = 10.0f;
static CGFloat const REMAActionTitleLabelHeight = 40.0f;

static CGFloat const REMAActionMessageTextViewX = 10.0f;
static CGFloat const REMAActionMessageTextViewY = 20.0f;

static CGFloat const REMAActionButtonX = 10.0f;
static CGFloat const REMAActionButtonHeight = 45.0f;

static CGFloat const REMAViewVerticalSpacing = 10.0f;

@interface HYPTimeViewController ()

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, copy) HYPTimeViewActionBlock actionBlock;

@property (nonatomic, copy) NSString *actionTitle;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *messageTextView;

@end

@implementation HYPTimeViewController

#pragma mark - Initialization

- (id)initWithDate:(NSDate *)date
{
    self = [super init];
    if (!self) return nil;

    _date = date;

    return self;
}

- (id)initWithDate:(NSDate *)date title:(NSString *)title message:(NSString *)message
       actionTitle:(NSString *)actionTitle actionBlock:(HYPTimeViewActionBlock)actionBlock
{
    self = [self initWithDate:date];
    if (!self) return nil;

    _actionTitle = actionTitle;

    self.title = title;

    _message = message;

    _actionBlock = actionBlock;

    return self;
}

#pragma mark - Getters

- (UILabel *)titleLabel
{
    if (_titleLabel) return _titleLabel;

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, REMAActionTitleLabelY,
                                                                  REMADatePopoverSize.width,
                                                                  REMAActionTitleLabelHeight)];
    _titleLabel.font = [UIFont REMAMediumSizeBolder];
    _titleLabel.textColor = [UIColor remaDarkBlue];
    _titleLabel.text = self.title;
    _titleLabel.backgroundColor = [UIColor remaLightGray];
    _titleLabel.textAlignment = NSTextAlignmentCenter;

    return _titleLabel;
}

- (UITextView *)messageTextView
{
    if (_messageTextView) return _messageTextView;

    UIFont *font = [UIFont REMATextFieldFont];
    CGFloat xOffset = REMAActionMessageTextViewX;
    CGFloat yOffset = REMAActionMessageTextViewY;
    CGFloat height = [NSString heightForString:self.message width:REMADatePopoverSize.width - (xOffset * 2.0f) font:font] + yOffset;
    CGFloat y = (self.title) ? CGRectGetMaxY(self.titleLabel.frame) : 0.0f;

    _messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(xOffset, y, REMADatePopoverSize.width - (xOffset * 2.0f), height)];
    _messageTextView.font = font;
    _messageTextView.textColor = [UIColor remaDarkBlue];
    _messageTextView.text = self.message;
    _messageTextView.scrollEnabled = NO;
    _messageTextView.backgroundColor = [UIColor remaLightGray];

    return _messageTextView;
}

- (UIDatePicker *)datePicker
{
    if (_datePicker) return _datePicker;

    CGFloat y = (self.message) ? CGRectGetMaxY(self.messageTextView.frame) : 0.0f;

    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, y, REMADatePopoverSize.width,
                                                                 REMADatePopoverSize.height)];

    return _datePicker;
}

- (UIButton *)actionButton
{
    if (_actionButton) return _actionButton;

    CGFloat height = REMAActionButtonHeight;
    CGFloat offset = REMAActionButtonX;
    CGFloat y = 0.0f;

    if (self.date) {
        y = CGRectGetMaxY(self.datePicker.frame);
    } else if (self.message) {
        y = CGRectGetMaxY(self.messageTextView.frame);
    } else if (self.title) {
        y = CGRectGetMaxY(self.titleLabel.frame);
    }

    _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(offset, y,
                                                               REMADatePopoverSize.width - (offset * 2.0f), height)];
    [_actionButton setTitle:self.actionTitle forState:UIControlStateNormal];
    _actionButton.backgroundColor = [UIColor remaRed];
    [_actionButton addTarget:self action:@selector(actionButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _actionButton.layer.cornerRadius = 5.0f;
    _actionButton.titleLabel.font = [UIFont REMALargeSizeBold];

    return _actionButton;
}

#pragma mark - Setters

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;

    self.datePicker.date = currentDate;
}

- (void)setActionButtonColor:(UIColor *)actionButtonColor
{
    _actionButtonColor = actionButtonColor;

    self.actionButton.backgroundColor = actionButtonColor;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.date) {
        [self.view addSubview:self.datePicker];

        [self.datePicker setBackgroundColor:[UIColor clearColor]];

        if (self.birthdayPicker) {
            [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        } else {
            [self.datePicker setMinimumDate:[NSDate date]];
        }

        [self.datePicker setDate:self.date];

        [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }

    if (self.actionBlock) {
        [self.view addSubview:self.actionButton];
    }

    if (self.title) {
        [self.view addSubview:self.titleLabel];
    }

    if (self.message) {
        [self.view addSubview:self.messageTextView];
    }
}

#pragma mark - Actions

- (void)dateChanged:(UIDatePicker *)datePicker
{
    self.date = datePicker.date;

    if ([self.delegate respondsToSelector:@selector(timeController:didChangedDate:)]) {
        [self.delegate timeController:self didChangedDate:datePicker.date];
    }
}

- (void)actionButtonPressed
{
    if (self.actionBlock) {
        self.actionBlock(self.date);
    }
}

#pragma mark - Public Methods

- (CGFloat)calculatedHeight
{
    CGFloat height = 0.0f;

    if (self.titleLabel) {
        height += REMAActionTitleLabelHeight + REMAActionTitleLabelY;
        height += REMAViewVerticalSpacing;
    }

    if (self.message) {
        UIFont *font = [UIFont REMATextFieldFont];
        CGFloat xOffset = REMAActionMessageTextViewX;
        CGFloat yOffset = REMAActionMessageTextViewY;
        height += [NSString heightForString:self.message
                                      width:REMADatePopoverSize.width - (xOffset * 2.0f) font:font] + yOffset;
        height += REMAViewVerticalSpacing;
    }

    if (self.date) {
        height += CGRectGetHeight(self.datePicker.frame);
    }

    if (self.actionBlock) {
        height += REMAActionButtonHeight;
    }

    return height;
}

@end
