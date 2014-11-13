@import Foundation;

@interface HYPPostalCodeManager : NSObject

+ (instancetype)sharedManager;
+ (id)JSONObjectWithContentsOfFile:(NSString*)fileName;

- (BOOL)validatePostalCode:(NSString *)postalCode;
- (NSString *)cityForPostalCode:(NSString *)postalCode;

@end
