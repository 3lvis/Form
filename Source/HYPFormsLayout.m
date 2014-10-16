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
#import "HYPImageFormFieldCell.h"

#import "HYPForm.h"
#import "HYPFormField.h"
#import "HYPFormSection.h"

#import "UIScreen+HYPLiveBounds.h"

@interface UICollectionViewLayoutAttributes (HYPLeftAligned)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset;

@end

@implementation UICollectionViewLayoutAttributes (HYPLeftAligned)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset
{
    CGRect frame = self.frame;
    frame.origin.x = sectionInset.left;
    self.frame = frame;
}

@end

@protocol UICollectionViewDelegateLeftAlignedLayout <UICollectionViewDelegateFlowLayout>

@end

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

    CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];

    self.sectionInset = UIEdgeInsetsMake(HYPFormMarginTop, HYPFormMarginHorizontal, HYPFormMarginBottom, HYPFormMarginHorizontal);
    self.minimumLineSpacing = 0.0f;
    self.minimumInteritemSpacing = 0.0f;
    self.headerReferenceSize = CGSizeMake(CGRectGetWidth(bounds), HYPFormHeaderHeight);

    [self registerClass:[HYPFormBackgroundView class] forDecorationViewOfKind:HYPFormBackgroundKind];

    return self;
}

#pragma mark - Overwrited Methods

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];

    BOOL isFirstItemInSection = (indexPath.item == 0);
    CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - self.sectionInset.left - self.sectionInset.right;

    if (isFirstItemInSection) {
        [currentItemAttributes leftAlignFrameWithSectionInset:self.sectionInset];

        return currentItemAttributes;
    }

    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;
    CGRect currentFrame = currentItemAttributes.frame;

    CGRect strecthedCurrentFrame = CGRectMake(self.sectionInset.left,
                                              currentFrame.origin.y,
                                              layoutWidth,
                                              currentFrame.size.height);

    BOOL isFirstItemInRow = !CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);

    if (isFirstItemInRow) {
        [currentItemAttributes leftAlignFrameWithSectionInset:self.sectionInset];
        return currentItemAttributes;
    }

    CGRect frame = currentItemAttributes.frame;
    frame.origin.x = previousFrameRightPoint + self.minimumInteritemSpacing;
    currentItemAttributes.frame = frame;

    return currentItemAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind
                                                                  atIndexPath:(NSIndexPath *)indexPath
{
    if (![elementKind isEqualToString:HYPFormBackgroundKind]) {
        return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
    }

    NSMutableArray *fields = [self fieldsAtSection:indexPath.section];

    CGFloat bottomMargin = HYPFormHeaderContentMargin;
    CGFloat height = [self heightForFields:fields];
    CGFloat y = self.previousHeight + self.previousY + HYPFormHeaderHeight;

    self.previousHeight = height;
    self.previousY = y;

    if (fields.count == 0) y = 0.0f;

    CGFloat width = self.collectionViewContentSize.width - (HYPFormBackgroundViewMargin * 2);
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind
                                                                                                               withIndexPath:indexPath];
    attributes.frame = CGRectMake(HYPFormBackgroundViewMargin, y, width, height - bottomMargin);
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
        } else if (!element.representedElementKind) {
            NSIndexPath *indexPath = element.indexPath;
            element.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
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

#pragma mark - Private Methods

- (NSMutableArray *)fieldsAtSection:(NSInteger)section
{
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

    HYPForm *form = forms[section];
    NSMutableArray *fields = nil;

    if ([collapsedForms containsObject:@(section)]) {
        fields = [NSMutableArray array];
    } else {
        fields = [NSMutableArray arrayWithArray:form.fields];

        NSMutableDictionary *deletedFields = [self.dataSource deletedFields];
        for (HYPFormField *deletedField in [deletedFields allValues]) {
            if ([deletedField.section.form.position integerValue] == section) {
                [fields insertObject:deletedField atIndex:[deletedField.position integerValue]];
            }
        }
    }

    return fields;
}

- (CGFloat)heightForFields:(NSArray *)fields
{
    CGFloat height = HYPFormMarginTop + HYPFormMarginBottom;
    CGFloat width = 0.0f;

    for (HYPFormField *field in fields) {
        if (field.sectionSeparator) {
            height += HYPFieldCellItemSmallHeight;
        } else {
            width += [field.size floatValue];

            if (width >= 100.0f) {
                if (field.type == HYPFormFieldTypeImage) {
                    height += HYPImageFormFieldCellItemHeight;
                } else {
                    height += HYPFieldCellItemHeight;
                }
                width = 0;
            }
        }
    }

    if (width > 0) {
        height += HYPFieldCellItemHeight;
    }

    return height;
}

@end
