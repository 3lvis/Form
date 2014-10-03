//
//  REMAFieldCollectionViewCell.m
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFieldCollectionViewCell.h"

@implementation REMAFieldCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.contentView.backgroundColor = [UIColor redColor];

    return self;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    UICollectionViewLayoutAttributes *attributes = [[UICollectionViewLayoutAttributes alloc] init];
    attributes.size = CGSizeMake(100.0f, 44.0f);

    return attributes;
}

@end
