#import "HYPFormFieldHeadingLabel.h"

#import "UIColor+ANDYHex.h"
#import "UIFont+HYPFormsStyles.h"

@implementation HYPFormFieldHeadingLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.font = [UIFont HYPFormsSmallSize];
    self.textColor = [UIColor colorFromHex:@"28649C"];

    return self;
}

@end
