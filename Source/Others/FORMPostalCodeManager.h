@import Foundation;

@interface FORMPostalCodeManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)validatePostalCode:(NSString *)postalCode;
- (NSString *)cityForPostalCode:(NSString *)postalCode;

@end
