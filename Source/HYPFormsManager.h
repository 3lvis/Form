@import Foundation;

@interface HYPFormsManager : NSObject

@property (nonatomic, strong) NSMutableArray *forms;
@property (nonatomic, strong) NSMutableDictionary *deletedFields;
@property (nonatomic, strong) NSMutableDictionary *deletedSections;
@property (nonatomic, strong) NSArray *disabledFieldsIDs;

- (instancetype)initWithInitialValues:(NSDictionary *)initialValues
                     disabledFieldIDs:(NSArray *)disabledFieldIDs;

@end
