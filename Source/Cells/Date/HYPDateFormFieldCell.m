//
//  HYPDateFormFieldCell.m

//
//  Created by Elvis Nunez on 08/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPDateFormFieldCell.h"

#import "HYPFormTimeViewController.h"

static const CGSize HYPDatePopoverSize = { 320.0f, 216.0f };

@interface HYPDateFormFieldCell () <HYPTextFormFieldDelegate, HYPFormTimeViewControllerDelegate,
UIPopoverControllerDelegate>

@property (nonatomic, strong) HYPTextFormField *textField;

@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) HYPFormTimeViewController *timeViewController;

@end

@implementation HYPDateFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame contentViewController:self.timeViewController
                 andContentSize:HYPDatePopoverSize];
    if (!self) return nil;

    return self;
}

#pragma mark - Getters

- (HYPFormTimeViewController *)timeViewController
{
    if (_timeViewController) return _timeViewController;

    _timeViewController = [[HYPFormTimeViewController alloc] initWithDate:[NSDate date]];
    _timeViewController.delegate = self;
    _timeViewController.birthdayPicker = YES;

    return _timeViewController;
}

#pragma mark - Private headers

- (void)updateWithField:(HYPFormField *)field
{
    [super updateWithField:field];

    if (field.fieldValue) {
        self.textField.rawText = [NSDateFormatter localizedStringFromDate:field.fieldValue
                                                                    dateStyle:NSDateFormatterMediumStyle
                                                                    timeStyle:NSDateFormatterNoStyle];
    }
}

- (void)validate
{
    [self.textField setValid:[self.field validate]];
}

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(HYPFormField *)field
{
    if (self.field.fieldValue) {
        self.timeViewController.date = self.field.fieldValue;
    }
}

#pragma mark - HYPTimeViewControllerDelegate

- (void)timeController:(HYPFormTimeViewController *)timeController didChangedDate:(NSDate *)date
{
    self.field.fieldValue = date;

    [self updateWithField:self.field];

    [self validate];

    [self.popoverController dismissPopoverAnimated:YES];

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

@end
