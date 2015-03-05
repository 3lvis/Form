@import Foundation;
@import CoreGraphics;

@interface FORMFieldValidation : NSObject

@property (nonatomic, getter = isRequired) BOOL required;
@property (nonatomic, strong) NSNumber *minimumLength;
@property (nonatomic, strong) NSNumber *maximumLength;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, strong) NSNumber *minimumValue;
@property (nonatomic, strong) NSNumber *maximumValue;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@end
