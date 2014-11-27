#import "HYPClassFactory.h"
#import "NSString+ZENInflections.h"

@implementation HYPClassFactory

+ (Class)classFromString:(NSString *)string withSuffix:(NSString *)suffix
{
    if (!string || string.length == 0) {
        return nil;
    }

    NSString *propertyName = [string zen_camelCase];
    if (!propertyName) return nil;

    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:propertyName];
    NSString *firstLetter = [[mutableString substringToIndex:1] uppercaseString];
    [mutableString replaceCharactersInRange:NSMakeRange(0,1)
                                 withString:firstLetter];

    NSString *classString = [NSString stringWithFormat:@"HYP%@%@", mutableString, suffix];

    return NSClassFromString(classString);
}

@end
