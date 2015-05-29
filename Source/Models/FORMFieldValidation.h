@import Foundation;
@import CoreGraphics;

@interface FORMFieldValidation : NSObject

@property (nonatomic, copy) NSString *compareRule;
@property (nonatomic, copy) NSString *compareToFieldID;
@property (nonatomic, copy) NSString *format;
@property (nonatomic) NSNumber *maximumLength;
@property (nonatomic) NSNumber *minimumLength;
@property (nonatomic) NSNumber *maximumValue;
@property (nonatomic) NSNumber *minimumValue;
@property (nonatomic) NSNumber *required;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

- (BOOL)isRequired;

@end
