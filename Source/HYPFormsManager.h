@import Foundation;

@interface HYPFormsManager : NSObject

@property (nonatomic, strong) NSMutableArray *forms;
@property (nonatomic, strong) NSMutableDictionary *hiddenFields;
@property (nonatomic, strong) NSMutableDictionary *hiddenSections;

- (void)generateFormsWithJSON:(NSArray *)JSON
                initialValues:(NSDictionary *)initialValues
            disabledFieldsIDs:(NSArray *)disabledFieldsIDs
                     disabled:(BOOL)disabled
                   completion:(void (^)(NSMutableArray *forms, NSMutableDictionary *hiddenFields, NSMutableDictionary *hiddenSections))completion;

@end
