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

- (void)enable;
- (void)disable;
- (BOOL)isDisabled;
- (BOOL)isEnabled;

- (void)processTargets:(NSArray *)targets;

- (NSArray *)invalidFields;
- (NSDictionary *)requiredFields;
- (BOOL)isValid;
- (void)reset;
- (void)validate;

- (NSDictionary *)values;
- (NSDictionary *)removedValues;
- (void)updateValuesWithDictionary:(NSDictionary *)dictionary;
- (void)reloadWithDictionary:(NSDictionary *)dictionary;
- (void)resetDynamicSectionsWithDictionary:(NSDictionary *)dictionary;

- (NSInteger)numberOfFields;
- (FORMSection *)sectionWithID:(NSString *)sectionID;
- (FORMField *)fieldWithID:(NSString *)fieldID
     includingHiddenFields:(BOOL)includingHiddenFields;
- (void)sectionWithID:(NSString *)sectionID
           completion:(void (^)(FORMSection *section, NSArray *indexPaths))completion;
- (void)indexForFieldWithID:(NSString *)fieldID
            inSectionWithID:(NSString *)sectionID
                 completion:(void (^)(FORMSection *section, NSInteger index))completion;
- (void)fieldWithID:(NSString *)fieldID includingHiddenFields:(BOOL)includingHiddenFields
         completion:(void (^)(FORMField *field, NSIndexPath *indexPath))completion;
- (FORMField *)formFieldAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths;

// Deprecated

- (NSArray *)invalidFormFields __attribute__((deprecated("Use invalidFields instead")));;
- (NSDictionary *)requiredFormFields __attribute__((deprecated("Use requiredFields instead")));;
- (BOOL)formFieldsAreValid __attribute__((deprecated("Use isValid instead")));;
- (void)resetForms __attribute__((deprecated("Use reset instead")));;
- (void)validateForms __attribute__((deprecated("Use validate instead")));;
- (void)processTarget:(FORMTarget *)target __attribute__((deprecated("Use processTargets instead")));;;

@end
