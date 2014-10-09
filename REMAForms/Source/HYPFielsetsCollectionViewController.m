//
//  HYPFielsetsCollectionViewController.m

//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFielsetsCollectionViewController.h"

#import "HYPFieldsetHeaderView.h"
#import "HYPFielsetBackgroundView.h"
#import "HYPFielsetsLayout.h"
#import "HYPFielsetsCollectionViewDataSource.h"

#import "HYPBaseFormFieldCell.h"

#import "HYPFieldset.h"
#import "HYPFormField.h"

#import "UIColor+ANDYHex.h"
#import "UIScreen+HYPLiveBounds.h"

@interface HYPFielsetsCollectionViewController () <HYPFieldsetHeaderViewDelegate>

@property (nonatomic, strong) HYPFielsetsCollectionViewDataSource *dataSource;

@end

@implementation HYPFielsetsCollectionViewController

#pragma mark - Initialization

- (instancetype)initWithCollectionViewLayout:(HYPFielsetsLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (!self) return nil;

    layout.dataSource = self.dataSource;

    return self;
}

#pragma mark - Getters

- (HYPFielsetsCollectionViewDataSource *)dataSource
{
    if (_dataSource) return _dataSource;

    _dataSource = [[HYPFielsetsCollectionViewDataSource alloc] initWithCollectionView:self.collectionView];

    _dataSource.configureCellBlock = ^(HYPBaseFormFieldCell *cell,
                                       NSIndexPath *indexPath,
                                       HYPFormField *field) {
        cell.field = field;

        if (field.sectionSeparator) {
            cell.backgroundColor = [UIColor colorFromHex:@"C6C6C6"];
        } else {
            cell.backgroundColor = [UIColor clearColor];
        }
    };

    __weak id weakSelf = self;
    _dataSource.configureHeaderViewBlock = ^(HYPFieldsetHeaderView *headerView,
                                             NSString *kind,
                                             NSIndexPath *indexPath,
                                             HYPFieldset *fieldset) {
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
}

#pragma mark - HYPFieldsetHeaderViewDelegate

- (void)fieldsetHeaderViewWasPressed:(HYPFieldsetHeaderView *)headerView
{
    [self.dataSource collapseFieldsInSection:headerView.section collectionView:self.collectionView];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];
    return CGSizeMake(CGRectGetWidth(bounds), HYPFieldsetHeaderHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource sizeForItemAtIndexPath:indexPath];
}

#pragma mark - Rotation Handling

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    [self.collectionViewLayout invalidateLayout];
}

@end
