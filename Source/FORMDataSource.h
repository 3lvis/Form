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

typedef void (^FORMConfigureCellBlock)(id cell, NSIndexPath *indexPath, FORMField *field);
typedef void (^FORMConfigureHeaderViewBlock)(FORMGroupHeaderView *headerView, NSString *kind, NSIndexPath *indexPath, FORMGroup *form);
typedef UICollectionViewCell * (^FORMConfigureCellForItemAtIndexPathBlock)(FORMField *field, UICollectionView *collectionView, NSIndexPath *indexPath);

typedef void (^FORMFieldFieldUpdatedBlock)(id cell, FORMField *field);

@interface FORMDataSource : NSObject <UICollectionViewDataSource, FORMLayoutDataSource>

/*!
 * @discussion Creates an instance of @c FORMDataSource.
 * @param JSON A serialized @c JSON that contains a collection of fields.
 * @param collectionView The used collectionView, usually from a @c UICollectionViewController.
 * @param layout An instance of @c FORMLayout.
 * @param values The initial values to be used when generating the fields.
 * @param disabled A flag to set whether the Form will be enabled or not.
 * @return An instance of @c FORMDataSource.
 */
- (instancetype)initWithJSON:(id)JSON
              collectionView:(UICollectionView *)collectionView
                      layout:(FORMLayout *)layout
                      values:(NSDictionary *)values
                    disabled:(BOOL)disabled;

/*!
 * Provides a configuration block to optionally set up subclasses of @c FORMBaseFieldCell
 * the default behaviour just sets the field property to the cell.
 */
@property (nonatomic, copy) FORMConfigureCellBlock configureCellBlock;

/*!
 * Provides a configuration block to optionally modify the group header view an instance of @c FORMGroupHeaderView
 * the default behaviour just sets the title and the delegate.
 */
@property (nonatomic, copy) FORMConfigureHeaderViewBlock configureHeaderViewBlock;

/*!
 * Provides a configuration block to optionally return a cell for a specific @c NSIndexPath
 * very useful when providing custom cells.
 */
@property (nonatomic, copy) FORMConfigureCellForItemAtIndexPathBlock configureCellForItemAtIndexPathBlock;

/*!
 * Provides a block that gets called every time a field gets updated
 */
@property (nonatomic, copy) FORMFieldFieldUpdatedBlock fieldUpdatedBlock;

/*!
 * Sets the Form into an editable mode.
 */
- (void)enable;

/*!
 * Sets the Form into a read-only mode.
 */
- (void)disable;

/*!
 * @discussion A method to check if the Form is disabled.
 * @return @c YES if the Form is disabled.
 */
- (BOOL)isDisabled;

/*!
 * @discussion A method to check if the Form is enabled.
 * @return @c YES if the Form is enabled.
 */
- (BOOL)isEnabled;

/*!
 * @discussion Processes a collection of targets, they could be show, hide, update, enable or disable.
 * @param targets A collection of targets
 */
- (void)processTargets:(NSArray *)targets;

/*!
 * @discussion A method to retrieve invalid fields
 * @return An array of invalid fields
 */
- (NSArray *)invalidFields;

/*!
 * @discussion A method to retrieve required fields.
 * @return A dictionary of required fields where the key is the @c fieldID and the value the @c FORMField
 */
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
