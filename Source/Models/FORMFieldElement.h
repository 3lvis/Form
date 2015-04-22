@import UIKit;
@import Foundation;

@class FORMFieldValidation;

typedef NS_ENUM(NSInteger, FORMFieldType) {
    FORMFieldTypeText = 0,
    FORMFieldTypeSelect,
    FORMFieldTypeDate,
    FORMFieldTypeDateTime,
    FORMFieldTypeTime,
    FORMFieldTypeFloat,
    FORMFieldTypeNumber,
    FORMFieldTypeButton,
    FORMFieldTypeCustom
};

@interface FORMFieldElement : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *info;
@property (nonatomic) NSString *typeString;
@property (nonatomic) NSString *inputTypeString;
@property (nonatomic) FORMFieldType type;
@property (nonatomic) BOOL hidden;
@property (nonatomic) CGSize size;
@property (nonatomic) NSNumber *position;
@property (nonatomic) id value;
@property (nonatomic) NSDate *minimumDate;
@property (nonatomic) NSDate *maximumDate;


@property (nonatomic) FORMFieldValidation *validation;
@property (nonatomic) NSString *formula;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (FORMFieldType)typeFromTypeString:(NSString *)typeString;

@end
