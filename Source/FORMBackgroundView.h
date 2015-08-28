@import UIKit;

static const NSInteger FORMBackgroundViewMargin = 15.0f;
static NSString * const FORMBackgroundReuseIdentifier = @"FORMBackgroundReuseIdentifier";
static NSString * const FORMBackgroundKind = @"FORMBackgroundKind";

@interface FORMBackgroundView : UICollectionReusableView

@property (nonatomic, copy) NSDictionary *styles;
@property (nonatomic, copy) UIColor *groupColor;

- (void)setGroupBackgroundColor:(UIColor *)color UI_APPEARANCE_SELECTOR;

@end
