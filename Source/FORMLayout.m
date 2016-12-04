#import "FORMLayout.h"
#import "FORMLayoutAttributes.h"
#import "FORMBackgroundView.h"
#import "FORMBaseFieldCell.h"
#import "FORMGroupHeaderView.h"
#import "FORMGroup.h"
#import "FORMField.h"
#import "FORMSection.h"

@interface UICollectionViewLayoutAttributes (HYPLeftAligned)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset;

@end

@implementation UICollectionViewLayoutAttributes (HYPLeftAligned)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset {
    CGRect frame = self.frame;
    frame.origin.x = sectionInset.left;
    self.frame = frame;
}

@end

@protocol UICollectionViewDelegateLeftAlignedLayout <UICollectionViewDelegateFlowLayout>

@end

@interface FORMLayout ()

@end

@implementation FORMLayout

+ (Class)layoutAttributesClass {
    return [FORMLayoutAttributes class];
}

#pragma mark - Initializers

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    CGRect bounds = self.collectionView.bounds;

    self.sectionInset = UIEdgeInsetsMake(FORMMarginTop, FORMMarginHorizontal, FORMMarginBottom, FORMMarginHorizontal);
    self.minimumLineSpacing = 0.0f;
    self.minimumInteritemSpacing = 0.0f;
    self.headerReferenceSize = CGSizeMake(CGRectGetWidth(bounds), FORMHeaderHeight);

    return self;
}

#pragma mark - Overridden Methods

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect bounds = self.collectionView.bounds;
    UICollectionViewLayoutAttributes *attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];

    BOOL isFirstItemInSection = (indexPath.item == 0);
    CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - self.sectionInset.left - self.sectionInset.right;

    if (isFirstItemInSection) {
        [attributes leftAlignFrameWithSectionInset:self.sectionInset];

        return attributes;
    } else {
        NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1
                                                             inSection:indexPath.section];
        CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
        CGRect stretchedCurrentFrame = CGRectMake(self.sectionInset.left,
                                                  attributes.frame.origin.y,
                                                  layoutWidth,
                                                  attributes.frame.size.height);

        BOOL isFirstItemInRow = !CGRectIntersectsRect(previousFrame, stretchedCurrentFrame);

        if (isFirstItemInRow) {
            [attributes leftAlignFrameWithSectionInset:self.sectionInset];

            return attributes;
        } else {
            CGRect frame = attributes.frame;
            CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;

            frame.origin.x = previousFrameRightPoint + self.minimumInteritemSpacing;

            BOOL isOutOfBounds = ((frame.origin.x + frame.size.width) > bounds.size.width);
            if (isOutOfBounds) {
                frame.origin.x = self.sectionInset.left + self.minimumInteritemSpacing;
            }

            attributes.frame = frame;

            return attributes;
        }
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
    if (![elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [super layoutAttributesForDecorationViewOfKind:elementKind
                                                  atIndexPath:indexPath];
    } else {
        UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind
                                                                                             atIndexPath:indexPath];

        CGRect bounds = self.collectionView.bounds;
        CGRect frame = attributes.frame;

        frame.origin.x = FORMHeaderContentMargin;
        frame.size.width = CGRectGetWidth(bounds) - (2 * FORMHeaderContentMargin);
        attributes.frame = frame;

        return attributes;
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind
                                                                  atIndexPath:(NSIndexPath *)indexPath {

    NSArray *groups = [self.dataSource groups];
    FORMGroup *group = [groups objectAtIndex:indexPath.section];
    
    NSString *viewOfKind = [NSString stringWithFormat:@"%@-%@", FORMBackgroundKind, group.groupID];
    
    if (![elementKind isEqualToString:viewOfKind]) {
        return [super layoutAttributesForDecorationViewOfKind:elementKind
                                                  atIndexPath:indexPath];
    } else {
        FORMLayoutAttributes *attributes = [FORMLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind
                                                                                           withIndexPath:indexPath];
        UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                  atIndexPath:indexPath];

        NSMutableArray *fields = [self fieldsAtSection:indexPath.section];
        CGFloat height = 0.0f;

        if (fields.count > 0) {
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:fields.count - 1
                                                             inSection:indexPath.section];
            UICollectionViewLayoutAttributes *attributes = [[super layoutAttributesForItemAtIndexPath:lastIndexPath] copy];
            height = attributes.frame.origin.y + attributes.frame.size.height - (self.sectionInset.bottom);
        }

        if (indexPath.section > 0 && height > 0) {
            NSArray *previousFields = [self fieldsAtSection:indexPath.section - 1];
            if (previousFields.count > 0) {
                NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:previousFields.count - 1
                                                                     inSection:indexPath.section - 1];
                UICollectionViewLayoutAttributes *previousAttribute = [[super layoutAttributesForItemAtIndexPath:previousIndexPath] copy];
                height -= previousAttribute.frame.origin.y + previousAttribute.frame.size.height + self.sectionInset.bottom;
            } else {
                NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:previousFields.count - 1
                                                                     inSection:indexPath.section - 1];
                UICollectionViewLayoutAttributes *previousHeaderAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                          atIndexPath:previousIndexPath];
                height -= previousHeaderAttributes.frame.origin.y + previousHeaderAttributes.frame.size.height + self.sectionInset.bottom + self.sectionInset.top;
            }
        }

        CGFloat width = self.collectionViewContentSize.width - (FORMBackgroundViewMargin * 2);

        attributes.frame = CGRectMake(FORMBackgroundViewMargin,
                                      CGRectGetMaxY(headerAttributes.frame),
                                      width, height -
                                      FORMHeaderContentMargin);
        attributes.zIndex = -1;

        return attributes;
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *attributes = [NSMutableArray new];

    for (UICollectionViewLayoutAttributes *element in originalAttributes) {
        if (element.representedElementKind) {
            NSIndexPath *indexPath = element.indexPath;
            [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:element.representedElementKind
                                                                       atIndexPath:indexPath]];
        } else {
            NSIndexPath *indexPath = element.indexPath;
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }

    NSInteger sectionsCount = [self.collectionView numberOfSections];

    for (NSInteger section = 0; section < sectionsCount; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        FORMGroup *group = [[self.dataSource groups] objectAtIndex:section];
        
        NSString *viewOfKind = [NSString stringWithFormat:@"%@-%@", FORMBackgroundKind, group.groupID];
        FORMLayoutAttributes *layoutAttributes = (FORMLayoutAttributes *)[self layoutAttributesForDecorationViewOfKind:viewOfKind
                                                                atIndexPath:indexPath];

        layoutAttributes.styles = group.styles;

        [attributes addObject:layoutAttributes];
    }

    return attributes;
}

#pragma mark - Private Methods

- (NSMutableArray *)fieldsAtSection:(NSInteger)section {
    NSArray *groups = nil;

    if ([self.dataSource respondsToSelector:@selector(groups)]) {
        groups = [self.dataSource groups];
        for (FORMGroup *group in groups) {
            NSString *viewOfKind = [NSString stringWithFormat:@"%@-%@", FORMBackgroundKind, group.groupID];
            [self registerClass:[FORMBackgroundView class] forDecorationViewOfKind:viewOfKind];
        }
    } else {
        abort();
    }

    NSArray *collapsedGroups = nil;

    if ([self.dataSource respondsToSelector:@selector(collapsedGroups)]) {
        collapsedGroups = [self.dataSource collapsedGroups];
    } else {
        abort();
    }

    FORMGroup *group = groups[section];
    NSMutableArray *fields = nil;

    if ([collapsedGroups containsObject:@(section)]) {
        fields = [NSMutableArray new];
    } else {
        fields = [NSMutableArray arrayWithArray:group.fields];
    }

    return fields;
}

@end
