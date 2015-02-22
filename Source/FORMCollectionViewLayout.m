#import "FORMCollectionViewLayout.h"

#import "FORMBackgroundView.h"
#import "FORMBaseFieldCell.h"
#import "FORMGroupHeaderView.h"

#import "FORMGroup.h"
#import "FORMField.h"
#import "FORMSection.h"

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

@interface FORMCollectionViewLayout ()

@end

@implementation FORMCollectionViewLayout

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];

    self.sectionInset = UIEdgeInsetsMake(FORMMarginTop, FORMMarginHorizontal, FORMMarginBottom, FORMMarginHorizontal);
    self.minimumLineSpacing = 0.0f;
    self.minimumInteritemSpacing = 0.0f;
    self.headerReferenceSize = CGSizeMake(CGRectGetWidth(bounds), FORMHeaderHeight);

    [self registerClass:[FORMBackgroundView class] forDecorationViewOfKind:FORMBackgroundKind];

    return self;
}

#pragma mark - Overwrited Methods

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];

    BOOL isFirstItemInSection = (indexPath.item == 0);
    CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - self.sectionInset.left - self.sectionInset.right;

    if (isFirstItemInSection) {
        [attributes leftAlignFrameWithSectionInset:self.sectionInset];

        return attributes;
    }

    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;
    CGRect currentFrame = attributes.frame;

    CGRect strecthedCurrentFrame = CGRectMake(self.sectionInset.left,
                                              currentFrame.origin.y,
                                              layoutWidth,
                                              currentFrame.size.height);

    BOOL isFirstItemInRow = !CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);

    if (isFirstItemInRow) {
        [attributes leftAlignFrameWithSectionInset:self.sectionInset];
        return attributes;
    }

    CGRect frame = attributes.frame;
    frame.origin.x = previousFrameRightPoint + self.minimumInteritemSpacing;
    attributes.frame = frame;

    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                                                     atIndexPath:(NSIndexPath *)indexPath
{
    if (![elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
    }

    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind
                                                                                         atIndexPath:indexPath];

    CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];
    CGRect frame = attributes.frame;
    frame.origin.x = FORMHeaderContentMargin;
    frame.size.width = CGRectGetWidth(bounds) - (2 * FORMHeaderContentMargin);
    attributes.frame = frame;

    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind
                                                                  atIndexPath:(NSIndexPath *)indexPath
{
    if (![elementKind isEqualToString:FORMBackgroundKind]) {
        return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
    }

    NSMutableArray *fields = [self fieldsAtSection:indexPath.section];
    CGFloat height = 0.0f;
    if (fields.count > 0) {
        height = [self heightForFields:fields];
    }

    CGFloat width = self.collectionViewContentSize.width - (FORMBackgroundViewMargin * 2);
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind
                                                                                                               withIndexPath:indexPath];
    UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                              atIndexPath:indexPath];
    attributes.frame = CGRectMake(FORMBackgroundViewMargin, CGRectGetMaxY(headerAttributes.frame), width, height - FORMHeaderContentMargin);
    attributes.zIndex = -1;

    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *attributes = [NSMutableArray new];

    for (UICollectionViewLayoutAttributes *element in originalAttributes) {
        if (element.representedElementKind) {
            NSIndexPath *indexPath = element.indexPath;
            [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:element.representedElementKind atIndexPath:indexPath]];
        } else {
            NSIndexPath *indexPath = element.indexPath;
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }

    NSInteger sectionsCount = [self.collectionView numberOfSections];

    for (NSInteger section = 0; section < sectionsCount; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        [attributes addObject:[self layoutAttributesForDecorationViewOfKind:FORMBackgroundKind
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
        abort();
    }

    FORMGroup *form = forms[section];
    NSMutableArray *fields = nil;

    if ([collapsedForms containsObject:@(section)]) {
        fields = [NSMutableArray new];
    } else {
        fields = [NSMutableArray arrayWithArray:form.fields];
    }

    return fields;
}

- (CGFloat)heightForFields:(NSArray *)fields
{
    CGFloat height = FORMMarginTop + FORMMarginBottom;
    CGFloat width = 0.0f;
    FORMField *lastField = [fields lastObject];

    for (FORMField *field in fields) {
        if (field.sectionSeparator) {
            height += FORMFieldCellItemSmallHeight;

            BOOL previousSectionIsNotFullWidth = (width > 0.0f && width < 100.0f);

            if (previousSectionIsNotFullWidth) height += FORMFieldCellItemHeight;

            width = 0.0f;
        } else {
            width += field.size.width;

            if (width >= 100.0f) {
                if (field.type == FORMFieldTypeCustom) {
                    height += field.size.height * FORMFieldCellItemHeight;
                } else {
                    height += FORMFieldCellItemHeight;
                }
                width = 0.0f;
            }
        }

        BOOL isLastFieldAndNotFullWidth = (width > 0.0f &&
                                           width < 100.0f &&
                                           [field isEqual:lastField]);

        if (isLastFieldAndNotFullWidth) height += FORMFieldCellItemHeight;
    }

    return height;
}

@end
