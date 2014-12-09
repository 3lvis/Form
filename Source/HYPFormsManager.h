@import Foundation;

#import "HYPFormField.h"

@interface HYPFormsManager : NSObject

@property (nonatomic, strong) NSMutableArray *forms;
@property (nonatomic, strong) NSMutableDictionary *hiddenFields;
@property (nonatomic, strong) NSMutableDictionary *hiddenSections;
@property (nonatomic, strong) NSArray *disabledFieldsIDs;
@property (nonatomic, strong) NSMutableDictionary *values;

- (instancetype)initWithJSON:(id)JSON
               initialValues:(NSDictionary *)initialValues
            disabledFieldIDs:(NSArray *)disabledFieldIDs
                    disabled:(BOOL)disabled;

- (instancetype)initWithForms:(NSMutableArray *)forms
                initialValues:(NSDictionary *)initialValues;

- (NSArray *)invalidFormFields;

- (NSDictionary *)requiredFormFields;

- (NSMutableDictionary *)valuesForFormula:(HYPFormField *)field;

- (HYPFormField *)fieldWithID:(NSString *)fieldID
                withIndexPath:(BOOL)withIndexPath;

@end
