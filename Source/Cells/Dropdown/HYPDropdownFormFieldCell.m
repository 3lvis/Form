//
//  HYPDropdownFormFieldCell.m

//
//  Created by Elvis Nunez on 08/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPDropdownFormFieldCell.h"

#import "HYPFieldValue.h"
#import "HYPFieldValuesTableViewController.h"

static const CGSize HYPDropdownPopoverSize = { .width = 320.0f, .height = 240.0f };

@interface HYPDropdownFormFieldCell () <HYPTextFormFieldDelegate, HYPFieldValuesTableViewControllerDelegate>

@property (nonatomic, strong) HYPFieldValuesTableViewController *fieldValuesController;

@end

@implementation HYPDropdownFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame contentViewController:self.fieldValuesController
                 andContentSize:HYPDropdownPopoverSize];
    if (!self) return nil;

    self.iconImageView.image = [UIImage imageNamed:@"ic_mini_arrow_down"];

    return self;
}

#pragma mark - Getters

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

    if (!field.fieldValue) {
        self.textField.rawText = nil;
        return;
    }

    if ([field.fieldValue isKindOfClass:[HYPFieldValue class]]) {
        HYPFieldValue *fieldValue = (HYPFieldValue *)field.fieldValue;
        self.textField.rawText = fieldValue.title;
    } else {

        for (HYPFieldValue *fieldValue in field.values) {
            if ([fieldValue identifierIsEqualTo:field.fieldValue]) {
                field.fieldValue = fieldValue;
                self.textField.rawText = fieldValue.title;
                break;
            }
        }
    }
}

- (void)validate
{
    [self.textField setValid:[self.field validate]];
}

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(HYPFormField *)field
{
    self.fieldValuesController.field = self.field;
}

#pragma mark - HYPFieldValuesTableViewControllerDelegate

- (void)fieldValuesTableViewController:(HYPFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(HYPFieldValue *)selectedValue
{
    self.field.fieldValue = selectedValue;

    [self updateWithField:self.field];

    [self validate];

    [self.popoverController dismissPopoverAnimated:YES];

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

@end
