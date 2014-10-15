//
//  HYPDropdownFormFieldCell.m

//
//  Created by Elvis Nunez on 08/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPDropdownFormFieldCell.h"

#import "HYPFieldValue.h"
#import "HYPFieldValuesTableViewController.h"

static const CGFloat HYPDropdownFormIconWidth = 38.0f;
static const CGSize HYPDropdownPopoverSize = { .width = 320.0f, .height = 240.0f };

@interface HYPDropdownFormFieldCell () <HYPTextFormFieldDelegate, HYPFieldValuesTableViewControllerDelegate>

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) HYPFieldValuesTableViewController *fieldValuesController;

@end

@implementation HYPDropdownFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame contentViewController:self.fieldValuesController
                 andContentSize:HYPDropdownPopoverSize];
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

- (HYPFieldValuesTableViewController *)fieldValuesController
{
    if (_fieldValuesController) return _fieldValuesController;

    _fieldValuesController = [[HYPFieldValuesTableViewController alloc] init];
    _fieldValuesController.delegate = self;

    return _fieldValuesController;
}

#pragma mark - Private headers

- (void)updateWithField:(HYPFormField *)field
{
    [super updateWithField:field];

    if ([field.fieldValue isKindOfClass:[HYPFieldValue class]]) {
        HYPFieldValue *fieldValue = (HYPFieldValue *)field.fieldValue;
        self.textField.rawText = fieldValue.title;
    } else {

        for (HYPFieldValue *fieldValue in field.values) {
            if ([fieldValue.id isEqualToString:field.rawFieldValue]) {
                self.textField.rawText = fieldValue.title;
                break;
            }
        }
    }

    [self performSelector:@selector(goNutsWithField:) withObject:field afterDelay:0.5];
}

- (void)goNutsWithField:(HYPFormField *)field
{
    if (self.field.fieldValue && [self.field.fieldValue isKindOfClass:[NSString class]]) {
        if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
            for (HYPFieldValue *fieldValue in self.field.values) {
                if ([fieldValue.id isEqualToString:self.field.fieldValue]) {
                    self.field.fieldValue = fieldValue;
                    [self.delegate fieldCell:self updatedWithField:self.field];
                    break;
                }
            }
        }
    }
}

- (void)validate
{
    NSLog(@"validation in progress");
}

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(HYPFormField *)field
{
    self.fieldValuesController.field = self.field;
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
    frame.origin.x = frame.size.width - HYPDropdownFormIconWidth;
    frame.size.width = HYPDropdownFormIconWidth;

    return frame;
}

#pragma mark - HYPFieldValuesTableViewControllerDelegate

- (void)fieldValuesTableViewController:(HYPFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(HYPFieldValue *)selectedValue
{
    self.field.fieldValue = selectedValue;
    [self updateWithField:self.field];

    [self.popoverController dismissPopoverAnimated:YES];

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

@end
