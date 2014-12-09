@import UIKit;

@interface HYPPopoverBackgroundView : UIPopoverBackgroundView

@property (nonatomic) CGFloat arrowOffset;
@property (nonatomic) UIPopoverArrowDirection arrowDirection;

+ (void)setContentInset:(CGFloat)contentInset;

+ (void)setTintColor:(UIColor *)tintColor;

+ (void)setShadowEnabled:(BOOL)shadowEnabled;

+ (void)setArrowBase:(CGFloat)arrowBase;

+ (void)setArrowHeight:(CGFloat)arrowHeight;

+ (void)setBackgroundImageCornerRadius:(CGFloat)cornerRadius;

+ (void)setBackgroundImage:(UIImage *)background top:(UIImage *)top right:(UIImage *)right bottom:(UIImage *)bottom left:(UIImage *)left;

+ (void)rebuildArrowImages;

@end
