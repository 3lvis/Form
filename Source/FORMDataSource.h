@import Foundation;
@import UIKit;

#import "FORMCollectionViewLayout.h"

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

@interface FORMDataSource : NSObject <UICollectionViewDataSource, HYPFormsLayoutDataSource>

- (instancetype)initWithJSON:(NSArray *)JSON
              collectionView:(UICollectionView *)collectionView
                      layout:(FORMCollectionViewLayout *)layout
                      values:(NSDictionary *)values
                     disabled:(BOOL)disabled;

@property (nonatomic, strong) NSMutableArray *collapsedForms;
@property (nonatomic, strong, readonly) FORMData *formsManager;

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

@end
