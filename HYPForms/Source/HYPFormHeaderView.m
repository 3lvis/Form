//
//  HYPFormHeaderView.m

//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFormHeaderView.h"

#import "UIColor+ANDYHex.h"
#import "UIScreen+HYPLiveBounds.h"

@interface HYPFormHeaderView ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation HYPFormHeaderView

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:self.headerLabel];

    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 0.2;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(headerTappedAction)];
    [self addGestureRecognizer:tapGestureRecognizer];

    return self;
}

#pragma mark - Getters

- (UILabel *)headerLabel
{
    if (_headerLabel) return _headerLabel;

    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(bounds) - (HYPFormTitleMargin * 2);

    _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(HYPFormTitleMargin, 0.0f, width, HYPFormHeaderHeight)];
    _headerLabel.backgroundColor = [UIColor clearColor];
    _headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _headerLabel.font = [UIFont fontWithName:@"DIN-Medium" size:17.0];
    _headerLabel.textColor = [UIColor colorFromHex:@"455C73"];

    return _headerLabel;
}

#pragma mark - Actions

- (void)headerTappedAction
{
    if ([self.delegate respondsToSelector:@selector(formHeaderViewWasPressed:)]) {
        [self.delegate formHeaderViewWasPressed:self];
    }
}

@end
