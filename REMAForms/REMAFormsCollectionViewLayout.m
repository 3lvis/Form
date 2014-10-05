//
//  REMAFormsCollectionViewLayout.m
//  REMAForms
//
//  Created by Elvis Nunez on 10/4/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFormsCollectionViewLayout.h"

#import "REMAFieldset.h"
#import "REMAFormField.h"
#import "REMAFormSection.h"
#import "REMAFormField.h"
#import "UIScreen+HYPLiveBounds.h"
#import "NSIndexPath+REMAAdjacent.h"

static const CGFloat REMAFormMargin = 14.0f;

@interface REMAFormsCollectionViewLayout ()

@property (nonatomic) CGRect previousFrame;
@property (nonatomic, strong) NSArray *fieldsets;

@end

@implementation REMAFormsCollectionViewLayout

#pragma mark - Getters

- (NSArray *)fieldsets
{
    if (_fieldsets) return _fieldsets;

    _fieldsets = [REMAFieldset fieldsets];

    return _fieldsets;
}

#pragma mark - UICollectionViewLayout

- (CGSize)collectionViewContentSize
{
    return self.collectionView.bounds.size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect];

    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }

    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMAFormField *field = [REMAFormField fieldAtIndexPath:indexPath inSection:[self.dataSource formLayoutSection]];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = [self frameForField:field atIndexPath:indexPath];
    self.previousFrame = attributes.frame;

    return attributes;
}

- (NSArray *)indexPathsOfItemsInRect:(CGRect)rect
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    REMAFormSection *section = [self.dataSource formLayoutSection];

    [section.fields enumerateObjectsUsingBlock:^(REMAFormField *field, NSUInteger fieldIndex, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:fieldIndex inSection:[section.position integerValue]]];
    }];

    return indexPaths;
}

- (CGRect)frameForField:(REMAFormField *)field atIndexPath:(NSIndexPath *)indexPath
{
    CGFloat marginX = REMAFormMargin;
    CGFloat initialMarginY = REMAFormMargin;
    CGFloat height = 88.0f;
    CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];
    bounds.size.width -= marginX * 2;
    CGRect frame;
    CGFloat breakpoint = CGRectGetWidth(bounds) - marginX;
    NSIndexPath *previousIndexPath = [indexPath rema_previousIndexPath];

    CGFloat x = marginX;
    CGFloat y = initialMarginY;
    CGFloat width;

    if (previousIndexPath) {
        CGRect previousFieldFrame = self.previousFrame;
        x = floor(previousFieldFrame.origin.x + previousFieldFrame.size.width + marginX);
        y = floor(previousFieldFrame.origin.y);
        width = floor(CGRectGetWidth(bounds) * ([field.size floatValue] / 100.0f) - marginX);

        // insert fields on a new row if with exceeds the total with of the container
        if ((width + x) > CGRectGetWidth(bounds)) {
            y = previousFieldFrame.origin.y + previousFieldFrame.size.height;
            x = marginX;
        }

        // expand width on last field in the row to make it align with previous and next line
        if ((width + x) > breakpoint) {
            width += floor(CGRectGetWidth(bounds) - (width + x + marginX));
        }

        // force line break if field is a part of a different set of rows
        if (!indexPath.row) {
            y = self.previousFrame.origin.y + self.previousFrame.size.height;
            x = marginX;
        }

        frame = CGRectMake(x, y, width, height);
    } else {
        CGFloat width = floor(CGRectGetWidth(bounds) * ([field.size floatValue] / 100.0f) - marginX);
        frame = CGRectMake(x, y, width, height);
    }
    
    return frame;
}

@end
