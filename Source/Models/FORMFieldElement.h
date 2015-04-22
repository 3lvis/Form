@import UIKit;
@import Foundation;

@class FORMFieldValidation;

@interface FORMFieldElement : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *info;
@property (nonatomic) BOOL hidden;
@property (nonatomic) CGSize size;
@property (nonatomic) NSNumber *position;
@property (nonatomic) id value;
@property (nonatomic) NSDate *minimumDate;
@property (nonatomic) NSDate *maximumDate;

@property (nonatomic) FORMFieldValidation *validation;
@property (nonatomic) NSString *formula;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@end
