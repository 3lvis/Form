#import "FORMLayoutAttributes.h"

@implementation FORMLayoutAttributes

+ (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind
                                                                  atIndexPath:(NSIndexPath *)indexPath
                                                                   withStyles:(NSDictionary *)styles {
    
    FORMLayoutAttributes *layoutAttributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind
                                                                              withIndexPath:indexPath];
    
    layoutAttributes.styles = styles;
    return layoutAttributes;
}

@end