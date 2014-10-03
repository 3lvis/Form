//
//  REMAFieldsetHeaderCollectionReusableView.m
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFieldsetHeaderCollectionReusableView.h"

@interface REMAFieldsetHeaderCollectionReusableView ()

@end

@implementation REMAFieldsetHeaderCollectionReusableView

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

    _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    _headerLabel.backgroundColor = [UIColor greenColor];

    return _headerLabel;
}

@end
