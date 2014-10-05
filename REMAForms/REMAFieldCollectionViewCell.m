//
//  REMAFieldCollectionViewCell.m
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFieldCollectionViewCell.h"

@interface REMAFieldCollectionViewCell ()

@property (nonatomic, strong) UILabel *fieldLabel;

@end

@implementation REMAFieldCollectionViewCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.fieldLabel];

    self.contentView.layer.borderWidth = 1.0f;
    self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;

    return self;
}

#pragma mark - Setters

- (void)setText:(NSString *)text
{
    _text = text;

    self.fieldLabel.text = text;
}

#pragma mark - Getters

- (UILabel *)fieldLabel
{
    if (_fieldLabel) return _fieldLabel;

    _fieldLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _fieldLabel.backgroundColor = [UIColor grayColor];
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
