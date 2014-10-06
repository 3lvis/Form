//
//  REMADateField.m
//  Mine Ansatte
//
//  Created by Elvis Nunez on 03/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMADateField.h"
#import "HYPTimeViewController.h"

@interface REMADateField () <UIPopoverControllerDelegate, HYPTimeViewControllerDelegate>

@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) HYPTimeViewController *timeViewController;

@end

@implementation REMADateField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self setUpIconImageViewWithFrame:frame];

    return self;
}

#pragma mark - Getters

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

#pragma mark - Setters

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
}

- (void)setDisabled:(BOOL)disabled
{
    [super setDisabled:disabled];

    self.iconImageView.hidden = disabled;
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self handleTouch];

    return NO;
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

#pragma mark - Touch gestures

- (void)handleTouch
{
    if (self.isDisabled) {
        return;
    }

    BOOL stateIsActive = !self.isActive;

    self.active = stateIsActive;

    if (stateIsActive) {
        [self.popoverController presentPopoverFromRect:self.frame
                                            inView:self
                          permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown
                                          animated:YES];
        if (self.currentDate) {
            self.timeViewController.currentDate = self.currentDate;
        }
    }

    [self setNeedsDisplay];
}

#pragma mark - Popover Delegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    self.active = NO;

    return YES;
}

#pragma mark - HYPTimeViewControllerDelegate

- (void)timeController:(HYPTimeViewController *)timeController didChangedDate:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = REMADateFieldFormat;
    self.text = [formatter stringFromDate:date];

    if ([self.delegate respondsToSelector:@selector(textField:didUpdateWithContent:)]) {
        [self.delegate textField:self didUpdateWithContent:date];
    }
}

@end
