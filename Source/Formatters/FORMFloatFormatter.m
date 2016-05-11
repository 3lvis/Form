#import "FORMFloatFormatter.h"

@implementation FORMFloatFormatter

- (NSString *)formatString:(NSString *)string reverse:(BOOL)reverse {
    string = [super formatString:string reverse:reverse];
    if (!string) return nil;

    NSString *decimalSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];

    if (reverse || [decimalSeparator isEqualToString:@"."]) {
        return [string stringByReplacingOccurrencesOfString:@"," withString:@"."];
    } else {
        return [string stringByReplacingOccurrencesOfString:@"." withString:@","];
    }
}

@end
