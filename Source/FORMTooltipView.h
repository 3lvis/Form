@import UIKit;

@interface FORMTooltipView : UIView

@property (nonatomic) CGFloat arrowOffset;
@property (nonatomic) UIPopoverArrowDirection arrowDirection;

+ (void)setContentInset:(CGFloat)contentInset;

+ (void)setTintColor:(UIColor *)tintColor;

+ (void)setShadowEnabled:(BOOL)shadowEnabled;

+ (void)setArrowBase:(CGFloat)arrowBase;

+ (CGFloat)arrowHeight;

+ (void)setArrowHeight:(CGFloat)arrowHeight;

+ (void)setBackgroundImageCornerRadius:(CGFloat)cornerRadius;

+ (void)setBackgroundImage:(UIImage *)background top:(UIImage *)top right:(UIImage *)right bottom:(UIImage *)bottom left:(UIImage *)left;

+ (void)rebuildArrowImages;

@end
