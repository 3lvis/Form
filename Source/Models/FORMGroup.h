@import Foundation;

@class FORMField;
@class FORMSection;

@interface FORMGroup : NSObject

@property (nonatomic) NSString *groupID;
@property (nonatomic) NSString *title;
@property (nonatomic) NSMutableArray *sections;
@property (nonatomic) NSNumber *position;

@property (nonatomic) BOOL shouldValidate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          position:(NSInteger)position
                          disabled:(BOOL)disabled
                 disabledFieldsIDs:(NSArray *)disabledFieldsIDs NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly, copy) NSArray *fields;

@property (nonatomic, readonly) NSInteger numberOfFields;
- (NSInteger)numberOfFields:(NSMutableDictionary *)deletedSections;
- (void)removeSection:(FORMSection *)section;
- (void)resetSectionPositions;

@end
