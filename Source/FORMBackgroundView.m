#import "FORMBackgroundView.h"
#import "UIColor+Hex.h"

@interface FORMBackgroundView ()

@end

@implementation FORMBackgroundView

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    UIRectCorner corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;

    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        byRoundingCorners:corners
                                                              cornerRadii:CGSizeMake(5.0f, 5.0f)];
    [rectanglePath closePath];

    [[UIColor whiteColor] setFill];
    [rectanglePath fill];
}

- (void)setGroupBackgroundColor:(UIColor *)backgroundColor {
    NSString *style = [self.styles valueForKey:@"background_color"];
    if ([style length] > 0) {
        backgroundColor = [UIColor colorFromHex:style];
    }
    
    self.backgroundColor = backgroundColor;
}

@end
