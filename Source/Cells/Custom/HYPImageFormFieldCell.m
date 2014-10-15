//
//  HYPImageFormFieldCell.m
//  HYPForms
//
//  Created by Elvis Nunez on 10/15/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPImageFormFieldCell.h"

#import "UIColor+ANDYHex.h"

@implementation HYPImageFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.contentView.backgroundColor = [UIColor colorFromHex:@"F5F5F8"];

    self.contentView.layer.borderWidth = 1.0f;
    self.contentView.layer.borderColor = [UIColor colorFromHex:@"D5D5D8"].CGColor;
    self.contentView.layer.cornerRadius = 5.0f;

    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.contentView.frame = CGRectMake(10.0f, 0.0f, 100.0f, 40.0f);
}

@end
