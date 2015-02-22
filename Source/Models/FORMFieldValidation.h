@import Foundation;
@import CoreGraphics;

@interface FORMFieldValidation : NSObject

@property (nonatomic, getter = isRequired) BOOL required;
@property (nonatomic) NSUInteger minimumLength;
@property (nonatomic) NSInteger maximumLength;
@property (nonatomic) NSString *format;
@property (nonatomic) CGFloat minimumValue;
@property (nonatomic) CGFloat maximumValue;

@end
