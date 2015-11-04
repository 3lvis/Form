#import "FORMSeparatorView.h"
@import Hex;

static NSString * const FORMSeparatorColorKey = @"separator_color";
static NSString * const FORMSeparatorHeightKey = @"height";

@implementation FORMSeparatorView


#pragma mark - Styling

- (void)setSeparatorColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:FORMSeparatorColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    
    self.backgroundColor = color;
}

- (void)setHeight:(CGFloat)height {
    NSString *style = [self.styles valueForKey:FORMSeparatorHeightKey];
    if ([style length] > 0) {
        height = [style floatValue];
    }
    CGRect previousFrame = self.frame;
    
    previousFrame.size.height = height;
    self.frame = previousFrame;
}

@end
