#import "HYPFloatFormatter.h"

@implementation HYPFloatFormatter

- (NSString *)formatString:(NSString *)string reverse:(BOOL)reverse
{
    string = [super formatString:string reverse:reverse];
    if (!string) return nil;

    if (reverse) {
        return [string stringByReplacingOccurrencesOfString:@"," withString:@"."];
    } else {
        return [string stringByReplacingOccurrencesOfString:@"." withString:@","];
    }
}

@end
