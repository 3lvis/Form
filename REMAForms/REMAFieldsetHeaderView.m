//
//  REMAFieldsetHeaderCollectionReusableView.m
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFieldsetHeaderView.h"

#import "UIColor+ANDYHex.h"
#import "UIScreen+HYPLiveBounds.h"

@interface REMAFieldsetHeaderView ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation REMAFieldsetHeaderView

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundColor = [UIColor colorFromHex:@"DAE2EA"];
    self.opaque = YES;

    [self addSubview:self.contentView];
    [self.contentView addSubview:self.headerLabel];

    return self;
}

#pragma mark - Getters

- (UIView *)contentView
{
    if (_contentView) return _contentView;

    CGRect frame = self.bounds;
    frame.origin.x = REMAFieldsetHeaderContentMargin;
    frame.size.width = frame.size.width - (REMAFieldsetHeaderContentMargin * 2);

    _contentView = [[UIView alloc] initWithFrame:frame];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    return _contentView;
}

- (UILabel *)headerLabel
{
    if (_headerLabel) return _headerLabel;

    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(bounds) - (REMAFieldsetTitleMargin * 2);

    _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(REMAFieldsetTitleMargin, 0.0f, width, REMAFieldsetHeaderHeight)];
    _headerLabel.backgroundColor = [UIColor whiteColor];
    _headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _headerLabel.font = [UIFont fontWithName:@"DIN-Medium" size:17.0];
    _headerLabel.textColor = [UIColor colorFromHex:@"455C73"];
    _headerLabel.opaque = YES;

    return _headerLabel;
}

@end
