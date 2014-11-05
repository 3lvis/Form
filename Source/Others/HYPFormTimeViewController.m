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

static CGFloat const HYPActionButtonX = 10.0f;
static CGFloat const HYPActionButtonHeight = 45.0f;

@interface HYPFormTimeViewController ()

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *messageTextView;

@end

@implementation HYPFormTimeViewController

#pragma mark - Initialization

- (instancetype)initWithDate:(NSDate *)date
{
    self = [super init];
    if (!self) return nil;

    _date = date;

    return self;
}

#pragma mark - Getters

- (UIDatePicker *)datePicker
{
    if (_datePicker) return _datePicker;

    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 0.0f, HYPDatePopoverSize.width,
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
    }

    _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(offset, y,
                                                               HYPDatePopoverSize.width - (offset * 2.0f), height)];
    [_actionButton setTitle:@"Done" forState:UIControlStateNormal];
    _actionButton.backgroundColor = [UIColor REMACallToAction];
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

    [self.view addSubview:self.actionButton];
}

#pragma mark - Actions

- (void)dateChanged:(UIDatePicker *)datePicker
{
    self.date = datePicker.date;
}

- (void)actionButtonPressed
{
    if ([self.delegate respondsToSelector:@selector(timeController:didChangedDate:)]) {
        [self.delegate timeController:self didChangedDate:self.datePicker.date];
    }
}

@end
