@import Foundation;

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

@end
