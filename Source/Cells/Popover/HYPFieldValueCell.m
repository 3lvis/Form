//
//  HYPFieldValueCell.m
//  HYPForms
//
//  Created by Elvis Nuñez on 11/28/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFieldValueCell.h"

#import "HYPFieldValue.h"

#import "UIFont+REMAStyles.h"
#import "UIColor+REMAColors.h"

@implementation HYPFieldValueCell

#pragma mark - Initializers

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    self.textLabel.font = [UIFont REMAMediumSize];
    self.textLabel.textColor = [UIColor REMADarkBlue];
    self.textLabel.highlightedTextColor = [UIColor whiteColor];
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.backgroundColor = [UIColor whiteColor];
    self.separatorInset = UIEdgeInsetsZero;

    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor REMACallToActionPressed];
    self.selectedBackgroundView = selectedBackgroundView;
    self.separatorInset = UIEdgeInsetsZero;

    return self;
}

#pragma mark - Setters

- (void)setFieldValue:(HYPFieldValue *)fieldValue
{
    _fieldValue = fieldValue;

    self.textLabel.text = fieldValue.title;
}

#pragma mark - Overwritables

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
