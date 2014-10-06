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

@end
