//
//  REMAFielsetsCollectionViewController.m
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFielsetsCollectionViewController.h"

#import "REMAFieldsetHeaderView.h"
#import "REMAFieldCollectionViewCell.h"
#import "REMAFielsetBackgroundView.h"
#import "REMAFielsetsLayout.h"
#import "REMAFielsetsCollectionViewDataSource.h"

#import "REMAFieldset.h"
#import "REMAFormField.h"

#import "UIColor+ANDYHex.h"
#import "UIScreen+HYPLiveBounds.h"

@interface REMAFielsetsCollectionViewController () <REMAFieldsetHeaderViewDelegate>

@property (nonatomic, strong) REMAFielsetsCollectionViewDataSource *dataSource;

@end

@implementation REMAFielsetsCollectionViewController

#pragma mark - Initialization

- (instancetype)initWithCollectionViewLayout:(REMAFielsetsLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (!self) return nil;

    layout.dataSource = self.dataSource;
    self.collectionView.dataSource = self.dataSource;

    return self;
}

#pragma mark - Delegate

- (REMAFielsetsCollectionViewDataSource *)dataSource
{
    if (_dataSource) return _dataSource;

    _dataSource = [[REMAFielsetsCollectionViewDataSource alloc] init];

    _dataSource.configureCellBlock = ^(REMAFieldCollectionViewCell *cell, NSIndexPath *indexPath, REMAFormField *field) {
        cell.fieldLabel.text = field.title;

        if (field.sectionSeparator) {
            cell.fieldLabel.backgroundColor = [UIColor colorFromHex:@"C6C6C6"];
        } else {
            cell.fieldLabel.backgroundColor = [UIColor colorFromHex:@"C0EAFF"];
        }
    };

    __weak id weakSelf = self;
    _dataSource.configureHeaderViewBlock = ^(REMAFieldsetHeaderView *headerView, NSString *kind, NSIndexPath *indexPath, REMAFieldset *fieldset) {
        headerView.headerLabel.text = fieldset.title;
        headerView.delegate = weakSelf;
    };

    return _dataSource;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);

    self.collectionView.backgroundColor = [UIColor colorFromHex:@"DAE2EA"];

    [self.collectionView registerClass:[REMAFieldCollectionViewCell class] forCellWithReuseIdentifier:REMAFieldReuseIdentifier];

    [self.collectionView registerClass:[REMAFieldsetHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:REMAFieldsetHeaderReuseIdentifier];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];
    return CGSizeMake(CGRectGetWidth(bounds), REMAFieldsetHeaderHeight);
}

#pragma mark - Rotation Handling

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    [self.collectionViewLayout invalidateLayout];
}


#pragma mark - REMAFieldsetHeaderViewDelegate

- (void)fieldsetHeaderViewWasPressed:(REMAFieldsetHeaderView *)headerView
{
    BOOL headerIsCollapsed = ([self.dataSource.collapsedFieldsets containsObject:@(headerView.section)]);

    NSMutableArray *indexPaths = [NSMutableArray array];
    REMAFieldset *fieldset = self.dataSource.fieldsets[headerView.section];

    for (NSInteger i = 0; i < fieldset.fields.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:headerView.section];
        [indexPaths addObject:indexPath];
    }

    if (headerIsCollapsed) {
        [self.dataSource.collapsedFieldsets removeObject:@(headerView.section)];
        [self.collectionViewLayout invalidateLayout];
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
    } else {
        [self.dataSource.collapsedFieldsets addObject:@(headerView.section)];
        [self.collectionViewLayout invalidateLayout];
        [self.collectionView deleteItemsAtIndexPaths:indexPaths];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMAFieldset *fieldset = self.dataSource.fieldsets[indexPath.section];

    NSArray *fields = fieldset.fields;

    CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];
    CGFloat deviceWidth = CGRectGetWidth(bounds) - (REMAFieldsetMargin * 2);
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;

    REMAFormField *field = fields[indexPath.row];
    if (field.sectionSeparator) {
        width = deviceWidth;
        height = REMAFieldCellItemSmallHeight;
    } else {
        width = floor(deviceWidth * ([field.size floatValue] / 100.0f));
        height = REMAFieldCellItemHeight;
    }

    return CGSizeMake(width, height);
}

@end
