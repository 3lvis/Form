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

@property (nonatomic, strong) NSString *fieldID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic) CGSize size;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) id fieldValue;
@property (nonatomic, strong) NSString *typeString;
@property (nonatomic) FORMFieldType type;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, getter=isDisabled) BOOL disabled;
@property (nonatomic) BOOL initiallyDisabled;
@property (nonatomic) NSDate *minimumDate;
@property (nonatomic) NSDate *maximumDate;

@property (nonatomic, strong) FORMFieldValidation *validation;
@property (nonatomic, strong) NSString *formula;
@property (nonatomic, strong) NSArray *targets;

@property (nonatomic, strong) FORMSection *section;

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

- (NSUInteger)indexInSectionUsingForms:(NSArray *)forms;

- (NSArray *)safeTargets;

- (FORMValidationResultType)validate;
- (id)rawFieldValue;
- (id)inputValidator;
- (id)formatter;
- (NSNumber *)sectionPosition;

@end
