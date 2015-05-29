@import UIKit;
@import Foundation;

@class FORMFieldValidation;
@class FORMFieldValue;
@protocol FORMFieldBaseDataSource;

@interface FORMFieldBase : NSObject

@property (nonatomic) NSString *fieldID;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *info;
@property (nonatomic) NSDate *minimumDate;
@property (nonatomic) NSDate *maximumDate;
@property (nonatomic, weak) id <FORMFieldBaseDataSource> dataSource;

@property (nonatomic) FORMFieldValidation *validation;
@property (nonatomic) NSString *formula;
@property (nonatomic) FORMFieldValue *fieldValue;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@protocol FORMFieldBaseDataSource <NSObject>

- (id)transformedRawValue:(id)rawValue;

@end
