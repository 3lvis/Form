//
//  REMAFielsetsCollectionViewController.m
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFielsetsCollectionViewController.h"
#import "REMAFieldsetHeaderCollectionReusableView.h"
#import "REMAFieldCollectionViewCell.h"

@interface REMAFielsetsCollectionViewController ()

@end

@implementation REMAFielsetsCollectionViewController

static NSString * const REMAFieldReuseIdentifier = @"REMAFieldReuseIdentifier";
static NSString * const REMAFieldsetHeaderReuseIdentifier = @"REMAFieldsetHeaderReuseIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.collectionView registerClass:[REMAFieldCollectionViewCell class] forCellWithReuseIdentifier:REMAFieldReuseIdentifier];
    [self.collectionView registerClass:[REMAFieldsetHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REMAFieldsetHeaderReuseIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMAFieldCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:REMAFieldReuseIdentifier forIndexPath:indexPath];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320, 44);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind != UICollectionElementKindSectionHeader) return nil;

    REMAFieldsetHeaderCollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                withReuseIdentifier:REMAFieldsetHeaderReuseIdentifier
                                                                                                       forIndexPath:indexPath];
    reusableview.headerLabel.text = [NSString stringWithFormat:@"Fieldset #%li", indexPath.section + 1];

    return reusableview;
}

@end
