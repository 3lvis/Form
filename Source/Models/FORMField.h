@import UIKit;
@import Foundation;

@class FORMSection;
@class FORMFieldValue;
@class FORMFieldValidation;

#import "FORMValidator.h"

typedef NS_ENUM(NSInteger, FORMFieldType) {
    FORMFieldTypeText = 0,
    FORMFieldTypeSelect,
    FORMFieldTypeDate,
    FORMFieldTypeFloat,
    FORMFieldTypeNumber,
    FORMFieldTypeButton,
    FORMFieldTypeCustom
};

@interface FORMField : NSObject

@property (nonatomic) NSString *fieldID;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *info;
@property (nonatomic) CGSize size;
@property (nonatomic) NSNumber *position;
@property (nonatomic) id value;
@property (nonatomic) NSString *typeString;
@property (nonatomic) NSString *inputTypeString;
@property (nonatomic) FORMFieldType type;
@property (nonatomic) NSArray *values;
@property (nonatomic, getter=isDisabled) BOOL disabled;
@property (nonatomic) BOOL initiallyDisabled;
@property (nonatomic) NSDate *minimumDate;
@property (nonatomic) NSDate *maximumDate;

@property (nonatomic) FORMFieldValidation *validation;
@property (nonatomic) NSString *formula;
@property (nonatomic) NSArray *targets;

@property (nonatomic) FORMSection *section;

@property (nonatomic) BOOL valid;
@property (nonatomic) FORMValidationResultType validationType;
@property (nonatomic) BOOL sectionSeparator;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          position:(NSInteger)position
                          disabled:(BOOL)disabled
                 disabledFieldsIDs:(NSArray *)disabledFieldsIDs NS_DESIGNATED_INITIALIZER;

+ (FORMField *)fieldAtIndexPath:(NSIndexPath *)indexPath inSection:(FORMSection *)section;

- (FORMFieldType)typeFromTypeString:(NSString *)typeString;

- (FORMFieldValue *)selectFieldValueWithValueID:(id)fieldValueID;

- (NSUInteger)indexInSectionUsingGroups:(NSArray *)groups;

- (NSArray *)safeTargets;

- (FORMValidationResultType)validate;
- (id)rawFieldValue;
- (id)inputValidator;
- (id)formatter;
- (NSNumber *)sectionPosition;

@end
