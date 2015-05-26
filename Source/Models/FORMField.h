@import UIKit;
@import Foundation;

@class FORMSection;
@class FORMFieldValue;
@class FORMFieldValidation;

#import "FORMValidator.h"
#import "FORMFieldBase.h"

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

@interface FORMField : FORMFieldBase

@property (nonatomic) NSString *fieldID;
@property (nonatomic) NSString *typeString;
@property (nonatomic) NSString *inputTypeString;
@property (nonatomic) FORMFieldType type;
@property (nonatomic) NSArray *values;
@property (nonatomic, getter=isDisabled) BOOL disabled;
@property (nonatomic) BOOL initiallyDisabled;
@property (nonatomic) BOOL hidden;
@property (nonatomic) NSNumber *position;
@property (nonatomic) CGSize size;

@property (nonatomic) NSArray *targets;

@property (nonatomic) FORMSection *section;

@property (nonatomic) BOOL valid;
@property (nonatomic) FORMValidationResultType validationResultType;
@property (nonatomic) BOOL sectionSeparator;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          position:(NSInteger)position
                          disabled:(BOOL)disabled
                 disabledFieldsIDs:(NSArray *)disabledFieldsIDs NS_DESIGNATED_INITIALIZER;

+ (FORMField *)fieldAtIndexPath:(NSIndexPath *)indexPath inSection:(FORMSection *)section;

- (FORMFieldType)typeFromTypeString:(NSString *)typeString;

- (FORMFieldValue *)selectFieldValueWithValueID:(id)fieldValueID;

- (NSUInteger)indexInSectionUsingGroups:(NSArray *)groups;

@property (nonatomic, readonly, copy) NSArray *safeTargets;

@property (nonatomic, readonly) FORMValidationResultType validate;
@property (nonatomic, readonly, strong) id rawFieldValue;
@property (nonatomic, readonly, strong) id inputValidator;
@property (nonatomic, readonly, strong) id formatter;
@property (nonatomic, readonly, copy) NSNumber *sectionPosition;

@end
