@import Foundation;

@interface HYPValidator : NSObject

- (instancetype)initWithValidations:(NSDictionary *)validations;
- (BOOL)validateFieldValue:(id)fieldValue;
+ (Class)classForKey:(NSString *)key andType:(NSString *)type;

@end
