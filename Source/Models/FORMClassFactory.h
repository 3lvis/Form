@import Foundation;

@interface FORMClassFactory : NSObject

+ (Class)classFromString:(NSString *)string withSuffix:(NSString *)suffix;

@end
