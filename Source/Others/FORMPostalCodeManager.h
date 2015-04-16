@import Foundation;

@interface FORMPostalCodeManager : NSObject


/* FORMPostalCodeManager will look for post_codes.json for a list of valid postal codes
   This is the valid structure
   ```json
   [
     {
       "City":"Oslo",
       "Code":"0201"
     }
   ]
   ```
 */
+ (instancetype)sharedManager;

- (BOOL)validatePostalCode:(NSString *)postalCode;

- (NSString *)cityForPostalCode:(NSString *)postalCode;

@end
