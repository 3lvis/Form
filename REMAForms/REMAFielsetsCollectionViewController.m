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

@interface REMAFielsetsCollectionViewController () <REMAFielsetsLayoutDataSource>

@property (nonatomic, strong) NSArray *fieldsets;

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

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

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

    if (field.sectionSeparator) {
        cell.contentView.backgroundColor = [UIColor brownColor];
    } else {
        cell.contentView.backgroundColor = [UIColor redColor];
    }

    cell.text = field.title;

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    return CGSizeMake(CGRectGetWidth(bounds), REMAFieldsetHeaderHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        REMAFieldsetHeaderView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                  withReuseIdentifier:REMAFieldsetHeaderReuseIdentifier
                                                                                         forIndexPath:indexPath];
        reusableview.headerLabel.text = [NSString stringWithFormat:@"Fieldset #%li", indexPath.section + 1];

        return reusableview;
    }

    REMAFielsetBackgroundView *backgroundView = [self.collectionView dequeueReusableSupplementaryViewOfKind:REMAFieldsetBackgroundKind withReuseIdentifier:REMAFieldsetBackgroundReuseIdentifier forIndexPath:indexPath];

    return backgroundView;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
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

    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat deviceWidth = CGRectGetWidth(bounds) - (REMAFieldsetMargin * 2);
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;

    REMAFormField *field = fields[indexPath.row];
    if (field.sectionSeparator) {
        width = deviceWidth;
        height = 5.0f;
    } else {
        width = floor(deviceWidth * ([field.size floatValue] / 100.0f));
        height = REMAFieldCellItemHeight;
    }

    return CGSizeMake(width, height);
}

@end
