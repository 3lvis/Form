#import "FORMSeparatorView.h"
#import "UIColor+Hex.h"

@implementation FORMSeparatorView


#pragma mark - Styling

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    NSString *style = [self.styles valueForKey:@"separator_color"];
    if ([style length] > 0) {
        backgroundColor = [UIColor colorFromHex:style];
    }
    
    self.backgroundColor = backgroundColor;
}

- (void)setHeight:(CGFloat)height {
    NSString *style = [self.styles valueForKey:@"height"];
    if ([style length] > 0) {
        height = [style floatValue];
    }
    CGRect previousFrame = self.frame;
    
    previousFrame.size.height = height;
    self.frame = previousFrame;
}

@end
