@import Foundation;

@class FORMField;

@interface FORMGroup : NSObject

@property (nonatomic, strong) NSString *formID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSNumber *position;

@property (nonatomic) BOOL shouldValidate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          position:(NSInteger)position
                          disabled:(BOOL)disabled
                 disabledFieldsIDs:(NSArray *)disabledFieldsIDs NS_DESIGNATED_INITIALIZER;

- (NSArray *)fields;

- (NSInteger)numberOfFields;
- (NSInteger)numberOfFields:(NSMutableDictionary *)deletedSections;

- (void)printFieldValues;

@end
