#import "FORMEmailFormatter.h"

@implementation FORMEmailFormatter

- (NSString *)formatString:(NSString *)string reverse:(BOOL)reverse {
    string = [super formatString:string reverse:reverse];
    if (!string) {
        return nil;
    }

    return [string stringByReplacingOccurrencesOfString:@"," withString:@""];
}

@end
