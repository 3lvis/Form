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

#import "REMAFieldset.h"
#import "REMAFormField.h"

#import "UIColor+ANDYHex.h"
#import "UIScreen+HYPLiveBounds.h"

@interface REMAFielsetsCollectionViewController () <REMAFielsetsLayoutDataSource, REMAFieldsetHeaderViewDelegate>

@property (nonatomic, strong) NSArray *fieldsets;
@property (nonatomic, strong) NSMutableArray *collapsedFieldsets;

@end

@implementation REMAFielsetsCollectionViewController

- (instancetype)initWithCollectionViewLayout:(REMAFielsetsLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (!self) return nil;

    layout.dataSource = self;

    return self;
}

#pragma mark - Getters

- (NSArray *)fieldsets
{
    if (_fieldsets) return _fieldsets;

    _fieldsets = [REMAFieldset fieldsets];

    return _fieldsets;
}

- (NSMutableArray *)collapsedFieldsets
{
    if (_collapsedFieldsets) return _collapsedFieldsets;

    _collapsedFieldsets = [NSMutableArray array];

    return _collapsedFieldsets;
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.fieldsets.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    REMAFieldset *fieldset = self.fieldsets[section];
    if ([self.collapsedFieldsets containsObject:@(section)]) {
        return 0;
    }
    
    return [fieldset numberOfFields];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMAFieldCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:REMAFieldReuseIdentifier
                                                                                  forIndexPath:indexPath];

    REMAFieldset *fieldset = self.fieldsets[indexPath.section];
    NSArray *fields = fieldset.fields;
    REMAFormField *field = fields[indexPath.row];

    cell.fieldLabel.text = field.title;

    if (field.sectionSeparator) {
        cell.fieldLabel.backgroundColor = [UIColor colorFromHex:@"C6C6C6"];
    } else {
        cell.fieldLabel.backgroundColor = [UIColor colorFromHex:@"C0EAFF"];
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];
    return CGSizeMake(CGRectGetWidth(bounds), REMAFieldsetHeaderHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        REMAFieldsetHeaderView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                  withReuseIdentifier:REMAFieldsetHeaderReuseIdentifier
                                                                                         forIndexPath:indexPath];

        REMAFieldset *fieldset = self.fieldsets[indexPath.section];
        reusableview.section = indexPath.section;
        reusableview.headerLabel.text = fieldset.title;
        reusableview.delegate = self;

        return reusableview;
    }

    REMAFielsetBackgroundView *backgroundView = [self.collectionView dequeueReusableSupplementaryViewOfKind:REMAFieldsetBackgroundKind withReuseIdentifier:REMAFieldsetBackgroundReuseIdentifier forIndexPath:indexPath];

    return backgroundView;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                 duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    [self.collectionViewLayout invalidateLayout];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMAFieldset *fieldset = self.fieldsets[indexPath.section];

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

#pragma mark - REMAFieldsetHeaderViewDelegate

- (void)fieldsetHeaderViewWasPressed:(REMAFieldsetHeaderView *)headerView
{
    BOOL headerIsCollapsed = ([self.collapsedFieldsets containsObject:@(headerView.section)]);

    NSMutableArray *indexPaths = [NSMutableArray array];
    REMAFieldset *fieldset = self.fieldsets[headerView.section];

    for (NSInteger i = 0; i < fieldset.fields.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:headerView.section];
        [indexPaths addObject:indexPath];
    }

    if (headerIsCollapsed) {
        [self.collapsedFieldsets removeObject:@(headerView.section)];
        [self.collectionViewLayout invalidateLayout];
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
    } else {
        [self.collapsedFieldsets addObject:@(headerView.section)];
        [self.collectionViewLayout invalidateLayout];
        [self.collectionView deleteItemsAtIndexPaths:indexPaths];
    }
}

@end
