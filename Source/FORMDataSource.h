@import Foundation;
@import UIKit;

#import "FORMBaseFieldCell.h"
#import "FORMData.h"
#import "FORMField.h"
#import "FORMFieldValue.h"
#import "FORMGroup.h"
#import "FORMGroupHeaderView.h"
#import "FORMLayout.h"
#import "FORMSection.h"
#import "FORMTarget.h"

typedef void (^FORMConfigureCellBlock)(id cell,
                                       NSIndexPath *indexPath,
                                       FORMField *field);

typedef void (^FORMConfigureHeaderViewBlock)(FORMGroupHeaderView *headerView,
                                             NSString *kind,
                                             NSIndexPath *indexPath,
                                             FORMGroup *group);

typedef UICollectionReusableView * (^FORMConfigureGroupHeaderForItemAtIndexPathBlock)(FORMGroup *group,
                                                                                      UICollectionView *collectionView,
                                                                                      NSIndexPath *indexPath);

typedef UICollectionViewCell * (^FORMConfigureCellForItemAtIndexPathBlock)(FORMField *field,
                                                                           UICollectionView *collectionView,
                                                                           NSIndexPath *indexPath);

typedef void (^FORMFieldFieldUpdatedBlock)(id cell,
                                           FORMField *field);

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
 * Provides a configuration block to optionally return a group header for a specific @c NSIndexPath
 */

@property (nonatomic, copy) FORMConfigureGroupHeaderForItemAtIndexPathBlock configureGroupHeaderAtIndexPathBlock;

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
 * Collapse group with group id
 * @param group A group id
 */
- (void)collapseGroup:(NSInteger)group;

/*!
 * Collapse all groups
 */
- (void)collapseAllGroups;

/*!
 * Collapse all groups in collection view
 */
- (void)collapseAllGroupsForCollectionView:(UICollectionView *)collectionView;

/*!
 * @discussion A method to check if the Form is disabled.
 * @return @c YES if the Form is disabled.
 */
@property (nonatomic, getter=isDisabled, readonly) BOOL disabled;

/*!
 * @discussion A method to check if the Form is enabled.
 * @return @c YES if the Form is enabled.
 */
@property (nonatomic, getter=isEnabled, readonly) BOOL enabled;

/*!
 * @discussion Processes a collection of targets, they could be show, hide, update, enable or disable.
 * @param targets A collection of targets
 */
- (void)processTargets:(NSArray *)targets;

/*!
 * @discussion A method to retrieve invalid fields.
 * @return A dictionary of invalid fields where the key is the @c fieldID and the value the @c FORMField.
 */
@property (nonatomic, readonly, copy) NSDictionary *invalidFields;

/*!
 * @discussion A method to retrieve required fields.
 * @return A dictionary of required fields where the key is the @c fieldID and the value the @c FORMField.
 */
@property (nonatomic, readonly, copy) NSDictionary *requiredFields;

/*!
 * @return @YES if all the fields are valid
 */
@property (nonatomic, getter=isValid, readonly) BOOL valid;

/*!
 * Resets the values of all the fields
 */
- (void)reset;

/*!
 * Runs @c validate in all the fields, if the field is invalid it will show as red
 */
- (void)validate;

/*!
 * @discussion The values for all the fields
 * @return A dictionary of field values where @c key is the @c fieldID and the @c value is the field value
 */
@property (nonatomic, readonly, copy) NSDictionary *values;

/*!
 * @discussion Returns values for the removed fields (doesn't contain collapsed fields, just removed ones)
 * @return A dictionary of removed values where @c key is the @c fieldID and the @c value is the field value
 */
@property (nonatomic, readonly, copy) NSDictionary *removedValues;

/*!
 * @discussion Replaces the field values
 * @param dictionary A dictionary of field value where @c key is the @c fieldID and the @c value is the field value
 */
- (void)updateValuesWithDictionary:(NSDictionary *)dictionary;

/*!
 * @discussion Reloads the form using the values from the @c dictionary, triggering targets and reloading
 * the updated cells
 * @param dictionary A dictionary of field value where @c key is the @c fieldID and the @c value is the field value
 */
- (void)reloadWithDictionary:(NSDictionary *)dictionary;

/*!
 * @discussion Reloads the form using the values from the @c dictionary, triggering targets and reloading
 * the updated cells, it also adds, updates and removes the provided values for dynamic sections
 * @param dictionary A dictionary of field value where @c key is the @c fieldID and the @c value is the field value
 */
- (void)resetDynamicSectionsWithDictionary:(NSDictionary *)dictionary;

/*!
 * @return  Returns the number of fields in Form
 */
@property (nonatomic, readonly) NSInteger numberOfFields;

/*!
 * @param fieldID The identifier for the field
 * @param includingHiddenFields A flag for whether look for hidden or collapsed fields or not
 * @return The found @ FORMField, will return @c nil if the field is not found
 */
- (FORMField *)fieldWithID:(NSString *)fieldID
     includingHiddenFields:(BOOL)includingHiddenFields;

/*!
 * @param indexPath The @c indexPath for the @c FORMField
 * @throw It will throw an exception if the indexPath is out of bounds
 * @return The found @ FORMField at the specific @c indexPath
 */
- (FORMField *)fieldAtIndexPath:(NSIndexPath *)indexPath;

/*!
 * @discussion A method to find a @c field with its specific @c indexPath
 * @param fieldID The identifier for the field
 * @param includingHiddenFields A flag for whether look for hidden or collapsed fields or not
 */
- (void)fieldWithID:(NSString *)fieldID
includingHiddenFields:(BOOL)includingHiddenFields
         completion:(void (^)(FORMField *field,
                              NSIndexPath *indexPath))completion;

/*!
 * @discussion A method to find an @c index for a @c field in a specific @c section
 * @param fieldID The identifier for the field
 * @param sectionID The identifier for the section
 */
- (void)indexForFieldWithID:(NSString *)fieldID
            inSectionWithID:(NSString *)sectionID
                 completion:(void (^)(FORMSection *section,
                                      NSInteger index))completion;

/*!
 * @param sectionID The identifier for the section.
 * @return The found @c section, returns @c nil if the section is not found
 */
- (FORMSection *)sectionWithID:(NSString *)sectionID;

/*!
 * @discussion A method to find a @c section with and an array of @c indexPaths
 * for all the fields in the section
 * @param sectionID The identifier for the section.
 */
- (void)sectionWithID:(NSString *)sectionID
           completion:(void (^)(FORMSection *section,
                                NSArray *indexPaths))completion;

/*!
 * @return The size for the @c field at the given @c indexPath
 */
- (CGSize)sizeForFieldAtIndexPath:(NSIndexPath *)indexPath;

/*!
 * @discussion Safely reloads the fields at the given indexPaths
 * @param indexPaths A collection of indexPaths to reload
 */
- (void)reloadFieldsAtIndexPaths:(NSArray *)indexPaths;

/*!
 * @discussion Check if group is collapsed
 * @param group A group id
 */
- (BOOL)groupIsCollapsed:(NSInteger)group;

@end
