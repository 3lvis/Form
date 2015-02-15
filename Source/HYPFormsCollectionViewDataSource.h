@import Foundation;
@import UIKit;

#import "HYPFormsLayout.h"

#import "HYPBaseFormFieldCell.h"
#import "HYPFormHeaderView.h"

#import "HYPFormField.h"
#import "HYPForm.h"
#import "HYPFormSection.h"
#import "HYPFieldValue.h"
#import "HYPFormTarget.h"
#import "HYPFormsManager.h"

typedef void (^HYPFieldConfigureCellBlock)(id cell, NSIndexPath *indexPath, HYPFormField *field);
typedef void (^HYPFieldConfigureHeaderViewBlock)(HYPFormHeaderView *headerView, NSString *kind, NSIndexPath *indexPath, HYPForm *form);
typedef void (^HYPFieldConfigureFieldUpdatedBlock)(id cell, HYPFormField *field);
typedef UICollectionViewCell * (^HYPFieldConfigureCellForItemAtIndexPath)(HYPFormField *field, UICollectionView *collectionView, NSIndexPath *indexPath);

@protocol HYPFormsCollectionViewDataSourceDataSource;

@interface HYPFormsCollectionViewDataSource : NSObject <UICollectionViewDataSource, HYPFormsLayoutDataSource>

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView andFormsManager:(HYPFormsManager *)formsManager;

@property (nonatomic, strong) NSMutableArray *collapsedForms;

@property (nonatomic, copy) HYPFieldConfigureCellBlock configureCellBlock;
@property (nonatomic, copy) HYPFieldConfigureHeaderViewBlock configureHeaderViewBlock;
@property (nonatomic, copy) HYPFieldConfigureFieldUpdatedBlock configureFieldUpdatedBlock;
@property (nonatomic, copy) HYPFieldConfigureCellForItemAtIndexPath configureCellForIndexPath;

- (BOOL)formFieldsAreValid;
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (HYPFormField *)formFieldAtIndexPath:(NSIndexPath *)indexPath;

- (void)resetForms;
- (void)validateForms;

- (void)enable;
- (void)disable;
- (BOOL)isDisabled;
- (BOOL)isEnabled;

- (void)processTarget:(HYPFormTarget *)target;
- (void)processTargets:(NSArray *)targets;

- (void)reloadWithDictionary:(NSDictionary *)dictionary;
- (void)collapseFieldsInSection:(NSInteger)section collectionView:(UICollectionView *)collectionView;

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths;

@end
