//
//  HYPFormsCollectionViewController.m
//  HYPForms
//
//  Created by Elvis Nunez on 10/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFormsCollectionViewController.h"

#import "UIScreen+HYPLiveBounds.h"

#import "HYPFormHeaderView.h"

@implementation HYPFormsCollectionViewController

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];
    return CGSizeMake(CGRectGetWidth(bounds), HYPFormHeaderHeight);
}

#pragma mark - Rotation Handling

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    [self.collectionViewLayout invalidateLayout];
}

@end
