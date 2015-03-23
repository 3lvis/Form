@import Foundation;

#import "FORMField.h"
#import "FORMGroup.h"

@interface FORMData : NSObject

@property (nonatomic) NSMutableArray *forms;
@property (nonatomic) NSMutableDictionary *hiddenFieldsAndFieldIDsDictionary;
@property (nonatomic) NSMutableDictionary *hiddenSections;
@property (nonatomic) NSArray *disabledFieldsIDs;
@property (nonatomic) NSMutableDictionary *values;
@property (nonatomic) NSMutableDictionary *removedValues;
@property (nonatomic) NSMutableDictionary *sectionTemplatesDictionary;
@property (nonatomic) NSMutableDictionary *fieldTemplatesDictionary;

- (instancetype)initWithJSON:(id)JSON
               initialValues:(NSDictionary *)initialValues
            disabledFieldIDs:(NSArray *)disabledFieldIDs
                    disabled:(BOOL)disabled NS_DESIGNATED_INITIALIZER;

- (NSArray *)invalidFormFields;

- (NSDictionary *)requiredFormFields;

- (NSMutableDictionary *)valuesForFormula:(FORMField *)field;

- (FORMSection *)sectionWithID:(NSString *)sectionID;

- (void)sectionWithID:(NSString *)sectionID
           completion:(void (^)(FORMSection *section, NSArray *indexPaths))completion;

- (void)indexForFieldWithID:(NSString *)fieldID
            inSectionWithID:(NSString *)sectionID
                 completion:(void (^)(FORMSection *section, NSInteger index))completion;

- (FORMField *)fieldWithID:(NSString *)fieldID includingHiddenFields:(BOOL)includingHiddenFields;

- (void)fieldWithID:(NSString *)fieldID includingHiddenFields:(BOOL)includingHiddenFields
         completion:(void (^)(FORMField *field, NSIndexPath *indexPath))completion;

- (NSArray *)showTargets:(NSArray *)targets;
- (NSArray *)hideTargets:(NSArray *)targets;
- (NSArray *)updateTargets:(NSArray *)targets;
- (NSArray *)enableTargets:(NSArray *)targets;
- (NSArray *)disableTargets:(NSArray *)targets;

- (void)disable;

- (void)enable;

- (BOOL)isDisabled;

- (BOOL)isEnabled;

- (NSInteger)numberOfFields;

- (void)insertTemplateSectionWithID:(NSString *)sectionTemplateID intoCollectionView:(UICollectionView *)collectionView usingForm:(FORMGroup *)form;

- (void)resetRemovedValues;

@end
