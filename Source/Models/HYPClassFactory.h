@import Foundation;

@interface HYPClassFactory : NSObject

+ (Class)classFromString:(NSString *)string withSuffix:(NSString *)suffix;

@end
