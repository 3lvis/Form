@import UIKit;
@import Foundation;

@class FORMFieldValidation;

@interface FORMFieldBase : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *info;
@property (nonatomic) NSDate *minimumDate;
@property (nonatomic) NSDate *maximumDate;
@property (nonatomic) id value;

@property (nonatomic) FORMFieldValidation *validation;
@property (nonatomic) NSString *formula;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
