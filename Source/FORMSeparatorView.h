@import UIKit;

@interface FORMSeparatorView : UIView

@property (nonatomic, copy) NSDictionary *styles;

- (void)setSeparatorColor:(UIColor *)color UI_APPEARANCE_SELECTOR;
- (void)setHeight:(CGFloat)height UI_APPEARANCE_SELECTOR;

@end
