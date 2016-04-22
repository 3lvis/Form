#import "FORMBackgroundView.h"
#import "FORMLayoutAttributes.h"
#import "UIColor+Hex.h"

static NSString * const FORMGroupBackgroundColorKey = @"background_color";

@interface FORMBackgroundView ()

@end

@implementation FORMBackgroundView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    FORMLayoutAttributes *backgroundLayoutAttributes = (FORMLayoutAttributes *)layoutAttributes;
    self.styles = backgroundLayoutAttributes.styles;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    UIRectCorner corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;

    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        byRoundingCorners:corners
                                                              cornerRadii:CGSizeMake(5.0f, 5.0f)];
    [rectanglePath closePath];

    [self.groupColor setFill];
    [rectanglePath fill];
}

- (void)setGroupBackgroundColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:FORMGroupBackgroundColorKey];
    if ([style length] > 0) {
        color = [UIColor form_colorFromHex:style];
    } else {
        color = [UIColor whiteColor];
    }
    
    self.groupColor = color;
}

@end
