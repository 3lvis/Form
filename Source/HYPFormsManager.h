@import Foundation;

@interface HYPFormsManager : NSObject

@property (nonatomic, strong) NSMutableArray *forms;
@property (nonatomic, strong) NSMutableDictionary *deletedFields;
@property (nonatomic, strong) NSMutableDictionary *deletedSections;

- (instancetype)initWithJSON:(id)JSON
               initialValues:(NSDictionary *)initialValues
            disabledFieldIDs:(NSArray *)disabledFieldIDs;

@end
