//
//  HYPFormTimeViewController.m
//  HYPDrifts
//
//  Created by Elvis Nunez on 1/22/13.
//  Copyright (c) 2013 Hyper. All rights reserved.
//

#import "HYPFormTimeViewController.h"

#import "UIColor+REMAColors.h"
#import "UIFont+REMAStyles.m"

static const CGSize HYPDatePopoverSize = { 320.0f, 216.0f };

static CGFloat const HYPActionTitleLabelY = 10.0f;
static CGFloat const HYPActionTitleLabelHeight = 40.0f;

static CGFloat const HYPActionMessageTextViewX = 10.0f;
static CGFloat const HYPActionMessageTextViewY = 20.0f;

static CGFloat const HYPActionButtonX = 10.0f;
static CGFloat const HYPActionButtonHeight = 45.0f;

static CGFloat const HYPViewVerticalSpacing = 10.0f;

@interface HYPFormTimeViewController ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, copy) HYPFormTimeViewActionBlock actionBlock;

@property (nonatomic, copy) NSString *actionTitle;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *messageTextView;

@end

@implementation HYPFormTimeViewController

#pragma mark - Initialization

- (id)initWithDate:(NSDate *)date
{
    self = [super init];
    if (!self) return nil;

    _date = date;

    return self;
}

- (id)initWithDate:(NSDate *)date title:(NSString *)title message:(NSString *)message
       actionTitle:(NSString *)actionTitle actionBlock:(HYPFormTimeViewActionBlock)actionBlock
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

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, HYPActionTitleLabelY,
                                                                  HYPDatePopoverSize.width,
                                                                  HYPActionTitleLabelHeight)];
    _titleLabel.font = [UIFont REMAMediumSizeBolder];
    _titleLabel.textColor = [UIColor REMADarkBlue];
    _titleLabel.text = self.title;
    _titleLabel.backgroundColor = [UIColor REMALightGray];
    _titleLabel.textAlignment = NSTextAlignmentCenter;

    return _titleLabel;
}

- (UITextView *)messageTextView
{
    if (_messageTextView) return _messageTextView;


    UIFont *font = [UIFont REMATextFieldFont];
    CGFloat xOffset = HYPActionMessageTextViewX;
    CGFloat yOffset = HYPActionMessageTextViewY;

    NSDictionary *attributes = @{ NSFontAttributeName : font };
    CGRect rect = [self.message boundingRectWithSize:CGSizeMake(HYPDatePopoverSize.width - (xOffset * 2.0f), CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];
    CGFloat height =CGRectGetHeight(rect) + yOffset;
    CGFloat y = (self.title) ? CGRectGetMaxY(self.titleLabel.frame) : 0.0f;

    _messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(xOffset, y, HYPDatePopoverSize.width - (xOffset * 2.0f), height)];
    _messageTextView.font = font;
    _messageTextView.textColor = [UIColor REMADarkBlue];
    _messageTextView.text = self.message;
    _messageTextView.scrollEnabled = NO;
    _messageTextView.backgroundColor = [UIColor REMALightGray];

    return _messageTextView;
}

- (UIDatePicker *)datePicker
{
    if (_datePicker) return _datePicker;

    CGFloat y = (self.message) ? CGRectGetMaxY(self.messageTextView.frame) : 0.0f;

    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, y, HYPDatePopoverSize.width,
                                                                 HYPDatePopoverSize.height)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor clearColor];
    _datePicker.minimumDate = [NSDate date];
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];

    return _datePicker;
}

- (UIButton *)actionButton
{
    if (_actionButton) return _actionButton;

    CGFloat height = HYPActionButtonHeight;
    CGFloat offset = HYPActionButtonX;
    CGFloat y = 0.0f;

    if (self.date) {
        y = CGRectGetMaxY(self.datePicker.frame);
    } else if (self.message) {
        y = CGRectGetMaxY(self.messageTextView.frame);
    } else if (self.title) {
        y = CGRectGetMaxY(self.titleLabel.frame);
    }

    _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(offset, y,
                                                               HYPDatePopoverSize.width - (offset * 2.0f), height)];
    [_actionButton setTitle:self.actionTitle forState:UIControlStateNormal];
    _actionButton.backgroundColor = [UIColor REMARed];
    [_actionButton addTarget:self action:@selector(actionButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _actionButton.layer.cornerRadius = 5.0f;
    _actionButton.titleLabel.font = [UIFont REMALargeSizeBold];

    return _actionButton;
}

#pragma mark - Setters

- (void)setDate:(NSDate *)date
{
    _date = date;

    self.datePicker.date = date;
}

- (void)setActionButtonColor:(UIColor *)actionButtonColor
{
    _actionButtonColor = actionButtonColor;

    self.actionButton.backgroundColor = actionButtonColor;
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;

    self.datePicker.minimumDate = self.minimumDate;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.date) {
        [self.view addSubview:self.datePicker];

        [self.datePicker setDate:self.date];
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
        height += HYPActionTitleLabelHeight + HYPActionTitleLabelY;
        height += HYPViewVerticalSpacing;
    }

    if (self.message) {
        UIFont *font = [UIFont REMATextFieldFont];
        CGFloat xOffset = HYPActionMessageTextViewX;
        CGFloat yOffset = HYPActionMessageTextViewY;

        NSDictionary *attributes = @{ NSFontAttributeName : font };
        CGRect rect = [self.message boundingRectWithSize:CGSizeMake(HYPDatePopoverSize.width - (xOffset * 2.0f), CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributes
                                                 context:nil];
        height =CGRectGetHeight(rect) + yOffset;

        height += HYPViewVerticalSpacing;
    }

    if (self.date) {
        height += CGRectGetHeight(self.datePicker.frame);
    }

    if (self.actionBlock) {
        height += HYPActionButtonHeight;
    }

    return height;
}

@end
