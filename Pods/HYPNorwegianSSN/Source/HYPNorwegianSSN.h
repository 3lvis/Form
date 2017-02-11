@import Foundation;

@interface HYPNorwegianSSN : NSObject

@property (nonatomic, strong) NSString *SSN;
@property (nonatomic, readonly, getter=isDNumber) BOOL DNumber;
@property (nonatomic, readonly, getter=isFemale) BOOL female;
@property (nonatomic, readonly, getter=isMale)   BOOL male;
@property (nonatomic, readonly, getter=isValid)  BOOL valid;

+ (BOOL)validateWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string;
- (NSDate *)birthdate;
- (NSString *)dateOfBirthString;
- (NSString *)dateOfBirthStringWithCentury;
- (NSNumber *)age;

@end
