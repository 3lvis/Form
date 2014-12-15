#import "HYPFormsLayout.h"

#import "HYPFormBackgroundView.h"
#import "HYPBaseFormFieldCell.h"
#import "HYPFormHeaderView.h"

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
    frame.origin.x = HYPFormHeaderContentMargin;
    frame.size.width = CGRectGetWidth(bounds) - (2 * HYPFormHeaderContentMargin);
    attributes.frame = frame;

    return attributes;
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
        abort();
    }

    HYPForm *form = forms[section];
    NSMutableArray *fields = nil;

    if ([collapsedForms containsObject:@(section)]) {
        fields = [NSMutableArray array];
    } else {
        fields = [NSMutableArray arrayWithArray:form.fields];
    }

    return fields;
}

- (CGFloat)heightForFields:(NSArray *)fields
{
    CGFloat height = HYPFormMarginTop + HYPFormMarginBottom;
    CGFloat width = 0.0f;
    HYPFormField *lastField = [fields lastObject];

    for (HYPFormField *field in fields) {
        if (field.sectionSeparator) {
            height += HYPFieldCellItemSmallHeight;

            BOOL previousSectionIsNotFullWidth = (width > 0.0f && width < 100.0f);

            if (previousSectionIsNotFullWidth) height += HYPFieldCellItemHeight;

            width = 0.0f;
        } else {
            width += field.size.width;

            if (width >= 100.0f) {
                if (field.type == HYPFormFieldTypeCustom) {
                    height += field.size.height * HYPFieldCellItemHeight;
                } else {
                    height += HYPFieldCellItemHeight;
                }
                width = 0.0f;
            }
        }

        BOOL isLastFieldAndNotFullWidth = (width > 0.0f &&
                                           width < 100.0f &&
                                           [field isEqual:lastField]);

        if (isLastFieldAndNotFullWidth) height += HYPFieldCellItemHeight;
    }

    return height;
}

@end
