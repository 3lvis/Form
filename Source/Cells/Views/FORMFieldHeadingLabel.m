#import "FORMFieldHeadingLabel.h"

#import "UIColor+Hex.h"
#import "UIFont+FORMStyles.h"
#import "UIColor+FORMColors.h"

@implementation FORMFieldHeadingLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.font = [UIFont FORMSmallSize];
    self.textColor = [UIColor FORMCoreBlue];

    return self;
}

@end
