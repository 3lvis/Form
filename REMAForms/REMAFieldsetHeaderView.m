//
//  REMAFieldsetHeaderCollectionReusableView.m
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFieldsetHeaderView.h"

@interface REMAFieldsetHeaderView ()

@end

@implementation REMAFieldsetHeaderView

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundColor = [UIColor whiteColor];

    [self addSubview:self.headerLabel];

    return self;
}

#pragma mark - Getters

- (UILabel *)headerLabel
{
    if (_headerLabel) return _headerLabel;

    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(bounds) - (REMAFieldsetTitleMargin * 2);

    _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(REMAFieldsetTitleMargin, 0.0f, width, REMAFieldsetHeaderHeight)];
    _headerLabel.backgroundColor = [UIColor whiteColor];
    _headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    return _headerLabel;
}

@end
