@import UIKit;
@import Foundation;

@class FORMSection;
@class FORMFieldValue;
@class FORMFieldValidation;

#import "FORMValidator.h"
#import "FORMFieldElement.h"

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

@interface FORMField : FORMFieldElement

@property (nonatomic) NSString *fieldID;
@property (nonatomic) NSString *typeString;
@property (nonatomic) NSString *inputTypeString;
@property (nonatomic) id value;
@property (nonatomic) FORMFieldType type;
@property (nonatomic) NSArray *values;
@property (nonatomic, getter=isDisabled) BOOL disabled;
@property (nonatomic) BOOL initiallyDisabled;
@property (nonatomic) NSNumber *position;

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

- (NSArray *)safeTargets;

- (FORMValidationResultType)validate;
- (id)rawFieldValue;
- (id)inputValidator;
- (id)formatter;
- (NSNumber *)sectionPosition;

@end
