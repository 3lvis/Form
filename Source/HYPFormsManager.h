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

- (NSArray *)invalidFormFields;

- (NSDictionary *)requiredFormFields;

- (NSMutableDictionary *)valuesForFormula:(HYPFormField *)field;

- (HYPFormField *)fieldWithID:(NSString *)fieldID;

- (HYPFormField *)fieldWithID:(NSString *)fieldID includingHiddenFields:(BOOL)includingHiddenFields;

- (void)fieldWithID:(NSString *)fieldID
         completion:(void (^)(HYPFormField *field, NSIndexPath *indexPath))completion;

@end
