@import UIKit;

@interface FORMLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, strong) NSDictionary *styles;

+ (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind
                                                                  atIndexPath:(NSIndexPath *)indexPath
                                                                   withStyles:(NSDictionary *)styles;
@end