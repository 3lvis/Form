//
//  HYPFielsetsCollectionViewDataSource.m

//
//  Created by Elvis Nunez on 10/6/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFielsetsCollectionViewDataSource.h"

#import "HYPFielsetsCollectionViewController.h"
#import "HYPFielsetBackgroundView.h"

#import "HYPTextFormFieldCell.h"
#import "HYPDropdownFormFieldCell.h"
#import "HYPDateFormFieldCell.h"

#import "UIColor+ANDYHex.h"
#import "UIScreen+HYPLiveBounds.h"

@implementation HYPFielsetsCollectionViewDataSource

#pragma mark - Initializers

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [super init];
    if (!self) return nil;

    collectionView.dataSource = self;

    [collectionView registerClass:[HYPTextFormFieldCell class]
       forCellWithReuseIdentifier:HYPTextFormFieldCellIdentifier];

    [collectionView registerClass:[HYPDropdownFormFieldCell class]
       forCellWithReuseIdentifier:HYPDropdownFormFieldCellIdentifier];

    [collectionView registerClass:[HYPDateFormFieldCell class]
       forCellWithReuseIdentifier:HYPDateFormFieldCellIdentifier];

    [collectionView registerClass:[HYPFieldsetHeaderView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:HYPFieldsetHeaderReuseIdentifier];

    return self;
}

#pragma mark - Getters

- (NSArray *)fieldsets
{
    if (_fieldsets) return _fieldsets;

    _fieldsets = [HYPFieldset fieldsets];

    return _fieldsets;
}

- (NSMutableArray *)collapsedFieldsets
{
    if (_collapsedFieldsets) return _collapsedFieldsets;

    _collapsedFieldsets = [NSMutableArray array];

    return _collapsedFieldsets;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.fieldsets.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    HYPFieldset *fieldset = self.fieldsets[section];
    if ([self.collapsedFieldsets containsObject:@(section)]) {
        return 0;
    }

    return [fieldset numberOfFields];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYPFieldset *fieldset = self.fieldsets[indexPath.section];
    NSArray *fields = fieldset.fields;
    HYPFormField *field = fields[indexPath.row];

    NSString *identifier;

    switch (field.type) {
        case HYPFormFieldTypeDate:
            identifier = HYPDateFormFieldCellIdentifier;
            break;
        case HYPFormFieldTypeSelect:
            identifier = HYPDropdownFormFieldCellIdentifier;
            break;

        case HYPFormFieldTypeDefault:
        case HYPFormFieldTypeNone:
        case HYPFormFieldTypeFloat:
        case HYPFormFieldTypeNumber:
        case HYPFormFieldTypePicture:
            identifier = HYPTextFormFieldCellIdentifier;
            break;
    }
    
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                        forIndexPath:indexPath];

    if (self.configureCellBlock) {
        self.configureCellBlock(cell, indexPath, field);
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        HYPFieldsetHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                  withReuseIdentifier:HYPFieldsetHeaderReuseIdentifier
                                                                                         forIndexPath:indexPath];

        HYPFieldset *fieldset = self.fieldsets[indexPath.section];
        headerView.section = indexPath.section;

        if (self.configureHeaderViewBlock) {
            self.configureHeaderViewBlock(headerView, kind, indexPath, fieldset);
        }

        return headerView;
    }

    HYPFielsetBackgroundView *backgroundView = [collectionView dequeueReusableSupplementaryViewOfKind:HYPFieldsetBackgroundKind
                                                                                   withReuseIdentifier:HYPFieldsetBackgroundReuseIdentifier
                                                                                          forIndexPath:indexPath];

    return backgroundView;
}

#pragma mark - Public methods

- (void)collapseFieldsInSection:(NSInteger)section collectionView:(UICollectionView *)collectionView
{
    BOOL headerIsCollapsed = ([self.collapsedFieldsets containsObject:@(section)]);

    NSMutableArray *indexPaths = [NSMutableArray array];
    HYPFieldset *fieldset = self.fieldsets[section];

    for (NSInteger i = 0; i < fieldset.fields.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }

    if (headerIsCollapsed) {
        [self.collapsedFieldsets removeObject:@(section)];
        [collectionView insertItemsAtIndexPaths:indexPaths];
        [collectionView.collectionViewLayout invalidateLayout];
    } else {
        [self.collapsedFieldsets addObject:@(section)];
        [collectionView deleteItemsAtIndexPaths:indexPaths];
        [collectionView.collectionViewLayout invalidateLayout];
    }
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYPFieldset *fieldset = self.fieldsets[indexPath.section];

    NSArray *fields = fieldset.fields;

    CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];
    CGFloat deviceWidth = CGRectGetWidth(bounds) - (HYPFieldsetMarginHorizontal * 2);
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;

    HYPFormField *field = fields[indexPath.row];
    if (field.sectionSeparator) {
        width = deviceWidth;
        height = HYPFieldCellItemSmallHeight;
    } else {
        width = floor(deviceWidth * ([field.size floatValue] / 100.0f));
        height = HYPFieldCellItemHeight;
    }

    return CGSizeMake(width, height);
}

@end
