//
//  HYPFormsLayout.m

//
//  Created by Elvis Nunez on 06/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFormsLayout.h"

#import "HYPFormBackgroundView.h"
#import "HYPBaseFormFieldCell.h"
#import "HYPFormHeaderView.h"

#import "HYPForm.h"
#import "HYPFormField.h"

#import "UIScreen+HYPLiveBounds.h"

@interface HYPFormsLayout ()

@property (nonatomic) CGFloat previousHeight;
@property (nonatomic) CGFloat previousY;

@end

@implementation HYPFormsLayout

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.sectionInset = UIEdgeInsetsMake(HYPFormMarginTop, HYPFormMarginHorizontal, HYPFormMarginBottom, HYPFormMarginHorizontal);
    self.minimumLineSpacing = 0.0f;
    self.minimumInteritemSpacing = 0.0f;

    [self registerClass:[HYPFormBackgroundView class] forDecorationViewOfKind:HYPFormBackgroundKind];

    return self;
}

#pragma mark - Private Methods

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if (![elementKind isEqualToString:HYPFormBackgroundKind]) {
        return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
    }

    NSArray *forms = nil;

    if ([self.dataSource respondsToSelector:@selector(forms)]) {
        forms = [self.dataSource forms];
    } else {
        abort();
    }

    NSArray *collapsedForms = nil;

    if ([self.dataSource respondsToSelector:@selector(collapsedForms)]) {
        collapsedForms = [self.dataSource collapsedForms];
    } else {
        collapsedForms = [NSArray array];
    }

    HYPForm *form = forms[indexPath.section];
    NSArray *fields = nil;

    if ([collapsedForms containsObject:@(indexPath.section)]) {
        fields = [NSArray array];
    } else {
        fields = form.fields;
    }

    CGFloat bottomMargin = HYPFormHeaderContentMargin;
    CGFloat height = HYPFormMarginTop + HYPFormMarginBottom;
    CGFloat size = 0.0f;

    for (HYPFormField *field in fields) {
        if (field.sectionSeparator) {
            height += HYPFieldCellItemSmallHeight;
        } else {
            size += [field.size floatValue];

            if (size >= 100.0f) {
                height += HYPFieldCellItemHeight;
                size = 0;
            }
        }
    }

    CGFloat y = self.previousHeight + self.previousY + HYPFormHeaderHeight;

    self.previousHeight = height;
    self.previousY = y;

    if (fields.count == 0) y = 0.0f;

    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind
                                                                                                               withIndexPath:indexPath];
    attributes.frame = CGRectMake(HYPFormBackgroundViewMargin, y, self.collectionViewContentSize.width - (HYPFormBackgroundViewMargin * 2), height - bottomMargin);
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
            frame.origin.x = HYPFormHeaderContentMargin;
            frame.size.width = CGRectGetWidth(bounds) - (2 * HYPFormHeaderContentMargin);
            element.frame = frame;
        }
    }

    NSInteger sectionsCount = [self.collectionView numberOfSections];

    for (NSInteger section = 0; section < sectionsCount; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        [attributes addObject:[self layoutAttributesForDecorationViewOfKind:HYPFormBackgroundKind
                                                                atIndexPath:indexPath]];
    }

    return attributes;
}

@end
