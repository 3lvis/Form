@import Foundation;

#import "FORMField.h"
#import "FORMGroup.h"

static NSString * const FORMHideTooltips = @"FORMHideTooltips";

@interface FORMData : NSObject

@property (nonatomic) NSMutableArray *groups;
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

@property (nonatomic, readonly, copy) NSDictionary *invalidFormFields;

@property (nonatomic, readonly, copy) NSDictionary *requiredFormFields;

- (NSMutableDictionary *)valuesForFormula:(FORMField *)field;

- (FORMGroup *)groupWithID:(NSString *)groupID;

- (FORMSection *)sectionWithID:(NSString *)sectionID;

- (void)sectionWithID:(NSString *)sectionID
           completion:(void (^)(FORMSection *section, NSArray *indexPaths))completion;

- (void)indexForFieldWithID:(NSString *)fieldID
            inSectionWithID:(NSString *)sectionID
                 completion:(void (^)(FORMSection *section, NSInteger index))completion;

- (FORMField *)fieldWithID:(NSString *)fieldID
     includingHiddenFields:(BOOL)includingHiddenFields;

- (void)fieldWithID:(NSString *)fieldID includingHiddenFields:(BOOL)includingHiddenFields
         completion:(void (^)(FORMField *field, NSIndexPath *indexPath))completion;

- (void)removeSection:(FORMSection *)removedSection
     inCollectionView:(UICollectionView *)collectionView;

- (NSArray *)showTargets:(NSArray *)targets;
- (NSArray *)hideTargets:(NSArray *)targets;
- (NSArray *)updateTargets:(NSArray *)targets;
- (NSArray *)enableTargets:(NSArray *)targets;
- (NSArray *)disableTargets:(NSArray *)targets;

- (void)disable;

- (void)enable;

@property (nonatomic, getter=isDisabled, readonly) BOOL disabled;

@property (nonatomic, getter=isEnabled, readonly) BOOL enabled;

@property (nonatomic, readonly) NSInteger numberOfFields;

- (void)insertTemplateSectionWithID:(NSString *)sectionTemplateID
                 intoCollectionView:(UICollectionView *)collectionView
                         usingGroup:(FORMGroup *)group;

- (void)resetRemovedValues;

- (NSArray *)removedSectionsUsingInitialValues:(NSDictionary *)dictionary;

@end
