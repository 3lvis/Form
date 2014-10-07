//
//  REMAFielsetsCollectionViewDataSource.m
//  REMAForms
//
//  Created by Elvis Nunez on 10/6/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFielsetsCollectionViewDataSource.h"

#import "REMAFielsetsCollectionViewController.h"
#import "REMAFielsetBackgroundView.h"

#import "REMATextFieldCollectionCell.h"
#import "REMADropdownFieldCollectionCell.h"
#import "REMADateFieldCollectionCell.h"

#import "UIColor+ANDYHex.h"
#import "UIScreen+HYPLiveBounds.h"

@implementation REMAFielsetsCollectionViewDataSource

#pragma mark - Initializers

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [super init];
    if (!self) return nil;

    collectionView.dataSource = self;

    [collectionView registerClass:[REMATextFieldCollectionCell class]
       forCellWithReuseIdentifier:REMATextFieldCellIdentifier];

    [collectionView registerClass:[REMADropdownFieldCollectionCell class]
       forCellWithReuseIdentifier:REMADropdownFieldCellIdentifier];

    [collectionView registerClass:[REMADateFieldCollectionCell class]
       forCellWithReuseIdentifier:REMADateFieldCellIdentifier];

    [collectionView registerClass:[REMAFieldsetHeaderView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:REMAFieldsetHeaderReuseIdentifier];

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
    REMAFieldset *fieldset = self.fieldsets[indexPath.section];
    NSArray *fields = fieldset.fields;
    REMAFormField *field = fields[indexPath.row];

    NSString *identifier;

    switch (field.type) {
        case REMAFormFieldTypeDate:
            identifier = REMADateFieldCellIdentifier;
            break;
        case REMAFormFieldTypeSelect:
            identifier = REMADropdownFieldCellIdentifier;
            break;

        case REMAFormFieldTypeDefault:
        case REMAFormFieldTypeNone:
        case REMAFormFieldTypeFloat:
        case REMAFormFieldTypeNumber:
        case REMAFormFieldTypePicture:
            identifier = REMATextFieldCellIdentifier;
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
        REMAFieldsetHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                  withReuseIdentifier:REMAFieldsetHeaderReuseIdentifier
                                                                                         forIndexPath:indexPath];

        REMAFieldset *fieldset = self.fieldsets[indexPath.section];
        headerView.section = indexPath.section;

        if (self.configureHeaderViewBlock) {
            self.configureHeaderViewBlock(headerView, kind, indexPath, fieldset);
        }

        return headerView;
    }

    REMAFielsetBackgroundView *backgroundView = [collectionView dequeueReusableSupplementaryViewOfKind:REMAFieldsetBackgroundKind
                                                                                   withReuseIdentifier:REMAFieldsetBackgroundReuseIdentifier
                                                                                          forIndexPath:indexPath];

    return backgroundView;
}

#pragma mark - Public methods

- (void)collapseFieldsInSection:(NSInteger)section collectionView:(UICollectionView *)collectionView
{
    BOOL headerIsCollapsed = ([self.collapsedFieldsets containsObject:@(section)]);

    NSMutableArray *indexPaths = [NSMutableArray array];
    REMAFieldset *fieldset = self.fieldsets[section];

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
    REMAFieldset *fieldset = self.fieldsets[indexPath.section];

    NSArray *fields = fieldset.fields;

    CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];
    CGFloat deviceWidth = CGRectGetWidth(bounds) - (REMAFieldsetMarginHorizontal * 2);
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
