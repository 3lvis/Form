#import "NSString+HYPContainsString.h"

@implementation NSString (HYPContainsString)

- (BOOL)hyp_containsString:(NSString *)string
{
    BOOL containsString = NO;

    if ([self respondsToSelector:@selector(containsString:)]) {
        containsString = [self containsString:string];
    } else {
        containsString = ([self rangeOfString:string].location != NSNotFound);
    }

    return containsString;
}

@end
