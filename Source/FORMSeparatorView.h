@import UIKit;

@interface FORMSeparatorView : UIView

@property (nonatomic, copy) NSDictionary *styles;

- (void)setBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setHeight:(CGFloat)height UI_APPEARANCE_SELECTOR;

@end
