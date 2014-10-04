//
//  REMAFormsCollectionViewLayout.m
//  REMAForms
//
//  Created by Elvis Nunez on 10/4/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFormsCollectionViewLayout.h"

@interface REMAFormsCollectionViewLayout ()

@property (nonatomic, copy) NSArray *items;

@end

@implementation REMAFormsCollectionViewLayout

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (!self) return nil;

    self.estimatedItemSize = CGSizeMake(100.0f, 60.0f);
    _items = items;

    return self;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.items[indexPath.row];
    return [text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f]}];
}

@end