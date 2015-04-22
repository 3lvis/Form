@import UIKit;
@import Foundation;

@class FORMSection;
@class FORMFieldValue;
@class FORMFieldValidation;

#import "FORMValidator.h"
#import "FORMFieldElement.h"

@interface FORMField : FORMFieldElement

@property (nonatomic) NSString *fieldID;

@property (nonatomic) NSArray *values;
@property (nonatomic, getter=isDisabled) BOOL disabled;
@property (nonatomic) BOOL initiallyDisabled;

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

- (FORMFieldValue *)selectFieldValueWithValueID:(id)fieldValueID;

- (NSUInteger)indexInSectionUsingGroups:(NSArray *)groups;

- (NSArray *)safeTargets;

- (FORMValidationResultType)validate;
- (id)rawFieldValue;
- (id)inputValidator;
- (id)formatter;
- (NSNumber *)sectionPosition;

@end
