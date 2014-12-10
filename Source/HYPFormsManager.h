@import Foundation;

#import "HYPFormField.h"

@interface HYPFormsManager : NSObject

@property (nonatomic, strong) NSMutableArray *forms;
@property (nonatomic, strong) NSMutableDictionary *hiddenFieldsAndFieldIDsDictionary;
@property (nonatomic, strong) NSMutableDictionary *hiddenSections;
@property (nonatomic, strong) NSArray *disabledFieldsIDs;
@property (nonatomic, strong) NSMutableDictionary *values;

- (instancetype)initWithJSON:(id)JSON
               initialValues:(NSDictionary *)initialValues
            disabledFieldIDs:(NSArray *)disabledFieldIDs
                    disabled:(BOOL)disabled;

- (NSArray *)invalidFormFields;

- (NSDictionary *)requiredFormFields;

- (NSMutableDictionary *)valuesForFormula:(HYPFormField *)field;

- (HYPFormSection *)sectionWithID:(NSString *)sectionID;

- (void)sectionWithID:(NSString *)sectionID
           completion:(void (^)(HYPFormSection *section, NSArray *indexPaths))completion;

- (void)indexForFieldWithID:(NSString *)fieldID
            inSectionWithID:(NSString *)sectionID
                 completion:(void (^)(HYPFormSection *section, NSInteger index))completion;

- (HYPFormField *)fieldWithID:(NSString *)fieldID includingHiddenFields:(BOOL)includingHiddenFields;

- (void)fieldWithID:(NSString *)fieldID
         completion:(void (^)(HYPFormField *field, NSIndexPath *indexPath))completion;

@end
