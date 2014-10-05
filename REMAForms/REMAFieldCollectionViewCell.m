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

    [self setNeedsDisplay];
}

#pragma mark - Getters

- (UILabel *)fieldLabel
{
    if (!_fieldLabel) return _fieldLabel;

    _fieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 60.0f)];
    _fieldLabel.backgroundColor = [UIColor grayColor];
    _fieldLabel.textColor = [UIColor blueColor];
    _fieldLabel.numberOfLines = 10;

    return _fieldLabel;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    CGSize labelSize = attributedText.size;

    self.fieldLabel.frame = CGRectMake(0.0f, 0.0f, labelSize.width, labelSize.height);

    return labelSize;
}

@end
