//
//  REMAFieldCollectionViewCell.m
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFieldCollectionViewCell.h"

#import "UIColor+ANDYHex.h"

@interface REMAFieldCollectionViewCell ()

@end

@implementation REMAFieldCollectionViewCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.fieldLabel];

    return self;
}

#pragma mark - Getters

- (UILabel *)fieldLabel
{
    if (_fieldLabel) return _fieldLabel;

    _fieldLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _fieldLabel.backgroundColor = [UIColor colorFromHex:@"C0EAFF"];
    _fieldLabel.textColor = [UIColor blueColor];

    return _fieldLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat margin = REMAFieldCellMargin;
    CGRect frame = self.contentView.frame;
    frame.origin.x = margin;
    frame.size.width = CGRectGetWidth(frame) - 2 * margin;
    self.fieldLabel.frame = frame;
}

@end
