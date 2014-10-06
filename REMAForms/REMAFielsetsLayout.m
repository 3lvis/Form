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
#import "REMAFieldCollectionViewCell.h"

#import "REMAFieldset.h"
#import "REMAFormField.h"

@implementation REMAFielsetsLayout

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.sectionInset = UIEdgeInsetsMake(REMAFieldsetMargin, REMAFieldsetMargin, REMAFieldsetMarginBottom, REMAFieldsetMargin);
    self.minimumLineSpacing = 0.0f;
    self.minimumInteritemSpacing = 0.0f;

    [self registerClass:[REMAFielsetBackgroundView class] forDecorationViewOfKind:REMAFieldsetBackgroundKind];

    return self;
}

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

    REMAFieldset *fieldset = fieldsets[indexPath.section];

    NSArray *fields = fieldset.fields;

    CGFloat height = 100.0f;
    NSInteger size = 0.0f;

    for (REMAFormField *field in fields) {
        if (field.sectionSeparator) {
            height += 5.0f;
        } else {
            size += [field.size integerValue];

            if (size == 100) {
                height += REMAFieldCellItemHeight;
                size = 0;
            }
        }
    }

    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind
                                                                                                               withIndexPath:indexPath];

    attributes.frame = CGRectMake(REMAFielsetBackgroundViewMargin, 0.0f, self.collectionViewContentSize.width - (REMAFielsetBackgroundViewMargin * 2), height);
    attributes.zIndex = -1;

    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];

    NSInteger sectionsCount = [self.collectionView numberOfSections];

    for (NSInteger section = 0; section < sectionsCount; section++) {
        [attributes addObject:[self layoutAttributesForDecorationViewOfKind:REMAFieldsetBackgroundKind atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]]];
    }

    return attributes;
}

@end
