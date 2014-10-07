//
//  REMAFielsetsLayout.m
//  REMAForms
//
//  Created by Elvis Nunez on 06/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFielsetsLayout.h"

#import "REMAFielsetsCollectionViewController.h"
#import "REMAFielsetBackgroundView.h"
#import "REMABaseFieldCollectionCell.h"
#import "REMAFieldsetHeaderView.h"

#import "REMAFieldset.h"
#import "REMAFormField.h"

#import "UIScreen+HYPLiveBounds.h"

@interface REMAFielsetsLayout ()

@property (nonatomic) CGFloat previousHeight;
@property (nonatomic) CGFloat previousY;

@end

@implementation REMAFielsetsLayout

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.sectionInset = UIEdgeInsetsMake(REMAFieldsetMarginTop, REMAFieldsetMarginHorizontal, REMAFieldsetMarginBottom, REMAFieldsetMarginHorizontal);
    self.minimumLineSpacing = 0.0f;
    self.minimumInteritemSpacing = 0.0f;

    [self registerClass:[REMAFielsetBackgroundView class] forDecorationViewOfKind:REMAFieldsetBackgroundKind];

    return self;
}

#pragma mark - Private Methods

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if (![elementKind isEqualToString:REMAFieldsetBackgroundKind]) {
        return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
    }

    NSArray *fieldsets = nil;

    if ([self.dataSource respondsToSelector:@selector(fieldsets)]) {
        fieldsets = [self.dataSource fieldsets];
    } else {
        abort();
    }

    NSArray *collapsedFieldsets = nil;

    if ([self.dataSource respondsToSelector:@selector(collapsedFieldsets)]) {
        collapsedFieldsets = [self.dataSource collapsedFieldsets];
    } else {
        collapsedFieldsets = [NSArray array];
    }

    REMAFieldset *fieldset = fieldsets[indexPath.section];
    NSArray *fields = nil;

    if ([collapsedFieldsets containsObject:@(indexPath.section)]) {
        fields = [NSArray array];
    } else {
        fields = fieldset.fields;
    }

    CGFloat bottomMargin = REMAFieldsetHeaderContentMargin;
    CGFloat height = REMAFieldsetMarginTop + REMAFieldsetMarginBottom;
    CGFloat size = 0.0f;

    for (REMAFormField *field in fields) {
        if (field.sectionSeparator) {
            height += REMAFieldCellItemSmallHeight;
        } else {
            size += [field.size floatValue];

            if (size >= 100.0f) {
                height += REMAFieldCellItemHeight;
                size = 0;
            }
        }
    }

    CGFloat y = self.previousHeight + self.previousY + REMAFieldsetHeaderHeight;

    self.previousHeight = height;
    self.previousY = y;

    if (fields.count == 0) y = 0.0f;

    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind
                                                                                                               withIndexPath:indexPath];
    attributes.frame = CGRectMake(REMAFielsetBackgroundViewMargin, y, self.collectionViewContentSize.width - (REMAFielsetBackgroundViewMargin * 2), height - bottomMargin);
    attributes.zIndex = -1;

    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    self.previousHeight = 0.0f;
    self.previousY = 0.0f;

    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];

    for (UICollectionViewLayoutAttributes *element in attributes) {
        if ([element.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];
            CGRect frame = element.frame;
            frame.origin.x = REMAFieldsetHeaderContentMargin;
            frame.size.width = CGRectGetWidth(bounds) - (2 * REMAFieldsetHeaderContentMargin);
            element.frame = frame;
        }
    }

    NSInteger sectionsCount = [self.collectionView numberOfSections];

    for (NSInteger section = 0; section < sectionsCount; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        [attributes addObject:[self layoutAttributesForDecorationViewOfKind:REMAFieldsetBackgroundKind
                                                                atIndexPath:indexPath]];
    }

    return attributes;
}

@end
