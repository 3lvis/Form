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
#import "REMAFieldsetHeaderView.h"

#import "REMAFieldset.h"
#import "REMAFormField.h"

@interface REMAFielsetsLayout ()

@property (nonatomic) CGFloat previousHeight;
@property (nonatomic) CGFloat previousY;

@end

@implementation REMAFielsetsLayout

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.sectionInset = UIEdgeInsetsMake(REMAFieldsetMarginTop, REMAFieldsetMargin, REMAFieldsetMarginBottom, REMAFieldsetMargin);
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
    NSLog(@"fieldset: %@", fieldset.title);
    
    NSArray *fields = fieldset.fields;
    NSLog(@"fields: %ld", (long)fields.count);

    CGFloat bottomMargin = 10.0f;
    CGFloat height = REMAFieldsetMarginTop + REMAFieldsetMarginBottom;
    CGFloat size = 0.0f;

    for (REMAFormField *field in fields) {
        if (field.sectionSeparator) {
            height += 5.0f;
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

    NSLog(@"y: %f", y);
    NSLog(@"height: %f (%f)", height - (REMAFieldsetMarginTop + REMAFieldsetMarginBottom), height);
    NSLog(@" ");


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

    NSInteger sectionsCount = [self.collectionView numberOfSections];

    for (NSInteger section = 0; section < sectionsCount; section++) {
        [attributes addObject:[self layoutAttributesForDecorationViewOfKind:REMAFieldsetBackgroundKind atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]]];
    }

    return attributes;
}

@end
