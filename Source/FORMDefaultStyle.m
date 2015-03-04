#import "FORMDefaultStyle.h"

#import "FORMTextField.h"

@implementation FORMDefaultStyle

+ (void)applyStyle
{
    [[FORMTextField appearance] setTextColor:[UIColor redColor]];
    [[FORMTextField appearance] setBackgroundColor:[UIColor yellowColor]];
}

@end
