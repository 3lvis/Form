@import Foundation;
@import UIKit;

#import "FORMLayout.h"

#import "FORMBaseFieldCell.h"
#import "FORMGroupHeaderView.h"

#import "FORMField.h"
#import "FORMGroup.h"
#import "FORMSection.h"
#import "FORMFieldValue.h"
#import "FORMTarget.h"
#import "FORMData.h"

typedef void (^FORMFieldConfigureCellBlock)(id cell, NSIndexPath *indexPath, FORMField *field);
typedef void (^FORMFieldConfigureHeaderViewBlock)(FORMGroupHeaderView *headerView, NSString *kind, NSIndexPath *indexPath, FORMGroup *form);
typedef void (^FORMFieldConfigureFieldUpdatedBlock)(id cell, FORMField *field);
typedef UICollectionViewCell * (^FORMFieldConfigureCellForItemAtIndexPath)(FORMField *field, UICollectionView *collectionView, NSIndexPath *indexPath);

@interface FORMDataSource : NSObject <UICollectionViewDataSource, FORMLayoutDataSource>

- (instancetype)initWithJSON:(id)JSON
              collectionView:(UICollectionView *)collectionView
                      layout:(FORMLayout *)layout
                      values:(NSDictionary *)values
                    disabled:(BOOL)disabled;

@property (nonatomic, copy) FORMFieldConfigureCellBlock configureCellBlock;
@property (nonatomic, copy) FORMFieldConfigureHeaderViewBlock configureHeaderViewBlock;
@property (nonatomic, copy) FORMFieldConfigureFieldUpdatedBlock configureFieldUpdatedBlock;
@property (nonatomic, copy) FORMFieldConfigureCellForItemAtIndexPath configureCellForIndexPath;

- (BOOL)formFieldsAreValid;
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (FORMField *)formFieldAtIndexPath:(NSIndexPath *)indexPath;

- (void)resetForms;
- (void)validateForms;

- (void)enable;
- (void)disable;
- (BOOL)isDisabled;
- (BOOL)isEnabled;

- (void)processTarget:(FORMTarget *)target;
- (void)processTargets:(NSArray *)targets;

- (void)reloadWithDictionary:(NSDictionary *)dictionary;
- (void)collapseFieldsInSection:(NSInteger)section collectionView:(UICollectionView *)collectionView;

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths;

- (NSArray *)showTargets:(NSArray *)targets;
- (NSArray *)hideTargets:(NSArray *)targets;
- (NSArray *)updateTargets:(NSArray *)targets;
- (NSArray *)enableTargets:(NSArray *)targets;
- (NSArray *)disableTargets:(NSArray *)targets;
- (NSArray *)invalidFormFields;
- (NSDictionary *)requiredFormFields;
- (NSMutableDictionary *)valuesForFormula:(FORMField *)field;
- (FORMSection *)sectionWithID:(NSString *)sectionID;
- (FORMField *)fieldWithID:(NSString *)fieldID includingHiddenFields:(BOOL)includingHiddenFields;
- (NSInteger)numberOfFields;
- (NSArray *)forms;
- (NSDictionary *)values;
- (NSDictionary *)removedValues;
- (void)resetRemovedValues;

- (void)sectionWithID:(NSString *)sectionID
           completion:(void (^)(FORMSection *section, NSArray *indexPaths))completion;
- (void)indexForFieldWithID:(NSString *)fieldID
            inSectionWithID:(NSString *)sectionID
                 completion:(void (^)(FORMSection *section, NSInteger index))completion;
- (void)fieldWithID:(NSString *)fieldID includingHiddenFields:(BOOL)includingHiddenFields
         completion:(void (^)(FORMField *field, NSIndexPath *indexPath))completion;
- (void)updateValuesWithDictionary:(NSDictionary *)dictionary;

// Deprecated

- (NSDictionary *)valuesDictionary __attribute__((deprecated("Use values instead")));

@end
