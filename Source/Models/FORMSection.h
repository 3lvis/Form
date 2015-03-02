@import CoreGraphics;
@import Foundation;

@class FORMGroup;
@class FORMField;

typedef NS_ENUM(NSInteger, FORMSectionType) {
    FORMSectionTypeDefault = 0,
    FORMSectionTypeDynamic
};

@interface FORMSection : NSObject

@property (nonatomic, strong) NSMutableArray *fields;
@property (nonatomic, strong) NSString *sectionID;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) FORMGroup *form;
@property (nonatomic, strong) NSString *typeString;
@property (nonatomic) FORMSectionType type;

@property (nonatomic) BOOL shouldValidate;
@property (nonatomic) BOOL containsSpecialField;
@property (nonatomic) BOOL isLast;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          position:(NSInteger)position
                          disabled:(BOOL)disabled
                 disabledFieldsIDs:(NSArray *)disabledFieldsIDs
                     isLastSection:(BOOL)isLastSection NS_DESIGNATED_INITIALIZER;

+ (void)sectionAndIndexForField:(FORMField *)field
                        inForms:(NSArray *)forms
                     completion:(void (^)(BOOL found,
                                          FORMSection *section,
                                          NSInteger index))completion;

- (NSInteger)indexInForms:(NSArray *)forms;
- (void)removeField:(FORMField *)field inForms:(NSArray *)forms;

@end
