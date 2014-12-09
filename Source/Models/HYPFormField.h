@import UIKit;
@import Foundation;

@class HYPFormSection;
@class HYPFieldValue;
@class HYPFieldValidation;

typedef NS_ENUM(NSInteger, HYPFormFieldType) {
    HYPFormFieldTypeText = 0,
    HYPFormFieldTypeSelect,
    HYPFormFieldTypeDate,
    HYPFormFieldTypeFloat,
    HYPFormFieldTypeNumber,
    HYPFormFieldTypeCustom
};

@interface HYPFormField : NSObject

@property (nonatomic, strong) NSString *fieldID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic) CGSize size;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) id fieldValue;
@property (nonatomic, strong) NSString *typeString;
@property (nonatomic) HYPFormFieldType type;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic) BOOL disabled;
@property (nonatomic, copy) NSDate *minimumDate;
@property (nonatomic, copy) NSDate *maximumDate;

@property (nonatomic, strong) NSDictionary *validations;
@property (nonatomic, strong) NSString *formula;
@property (nonatomic, strong) NSArray *targets;

@property (nonatomic, strong) HYPFormSection *section;

@property (nonatomic) BOOL valid;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic) BOOL sectionSeparator;

+ (HYPFormField *)fieldAtIndexPath:(NSIndexPath *)indexPath inSection:(HYPFormSection *)section;

- (HYPFormFieldType)typeFromTypeString:(NSString *)typeString;

- (HYPFieldValue *)fieldValueWithID:(id)fieldValueID;

- (NSUInteger)indexInSectionUsingForms:(NSArray *)forms;

- (NSArray *)safeTargets;

- (void)sectionAndIndexInForms:(NSArray *)forms
                    completion:(void (^)(BOOL found, HYPFormSection *section, NSInteger index))completion;

- (BOOL)validate;
- (id)rawFieldValue;
- (id)inputValidator;
- (id)formatter;

@end
