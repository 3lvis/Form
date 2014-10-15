//
//  HYPImageFormFieldCell.m
//  HYPForms
//
//  Created by Elvis Nunez on 10/15/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPImageFormFieldCell.h"

@implementation HYPImageFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.contentView.backgroundColor = [UIColor redColor];

    return self;
}

@end
