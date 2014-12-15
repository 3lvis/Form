@import CoreGraphics;
@import Foundation;

@class HYPForm;
@class HYPFormField;

@interface HYPFormSection : NSObject

@property (nonatomic, strong) NSMutableArray *fields;
@property (nonatomic, strong) NSString *sectionID;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) HYPForm *form;

@property (nonatomic) BOOL shouldValidate;
@property (nonatomic) BOOL containsSpecialField;
@property (nonatomic) BOOL isLast;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          position:(NSInteger)position
                          disabled:(BOOL)disabled
                 disabledFieldsIDs:(NSArray *)disabledFieldsIDs
                     isLastSection:(BOOL)isLastSection NS_DESIGNATED_INITIALIZER;

+ (void)sectionAndIndexForField:(HYPFormField *)field
                        inForms:(NSArray *)forms
                     completion:(void (^)(BOOL found,
                                          HYPFormSection *section,
                                          NSInteger index))completion;

- (NSInteger)indexInForms:(NSArray *)forms;
- (void)removeField:(HYPFormField *)field inForms:(NSArray *)forms;

@end
