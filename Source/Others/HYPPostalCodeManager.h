@import Foundation;

@interface HYPPostalCodeManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)validatePostalCode:(NSString *)postalCode;
- (NSString *)cityForPostalCode:(NSString *)postalCode;

@end
