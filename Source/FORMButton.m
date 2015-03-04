#import "FORMButton.h"

#import "UIButton+ANDYHighlighted.h"

@implementation FORMButton

- (void)setTitleLabelFont:(UIFont *)titleLabelFont
{
    self.titleLabel.font = titleLabelFont;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor
{
    self.highlightedTitleColor = highlightedTitleColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor
{
    self.highlightedBackgroundColor = highlightedBackgroundColor;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    self.titleColor = titleColor;
}

@end
