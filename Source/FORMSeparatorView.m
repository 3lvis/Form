#import "FORMSeparatorView.h"
@import Hex;

@implementation FORMSeparatorView


#pragma mark - Styling

- (void)setSeparatorColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:@"separator_color"];
    if ([style length] > 0) {
        color = [UIColor colorFromHex:style];
    }
    
    self.backgroundColor = color;
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
