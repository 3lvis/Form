//
//  HYPFormsCollectionViewDataSource.h

//
//  Created by Elvis Nunez on 10/6/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

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

typedef void (^HYPFieldConfigureCellBlock)(id cell, NSIndexPath *indexPath, HYPFormField *field);
typedef void (^HYPFieldConfigureHeaderViewBlock)(HYPFormHeaderView *headerView, NSString *kind, NSIndexPath *indexPath, HYPForm *form);
typedef void (^HYPFieldConfigureFieldUpdatedBlock)(id cell, HYPFormField *field);

@interface HYPFormsCollectionViewDataSource : NSObject <HYPFormsLayoutDataSource, UICollectionViewDataSource>

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                         andDictionary:(NSDictionary *)dictionary readOnly:(BOOL)readOnly;

@property (nonatomic, strong) NSMutableArray *forms;
@property (nonatomic, strong) NSMutableArray *collapsedForms;
@property (nonatomic, strong) NSMutableDictionary *deletedFields;
@property (nonatomic, strong) NSMutableDictionary *deletedSections;

@property (nonatomic, copy) HYPFieldConfigureCellBlock configureCellBlock;
@property (nonatomic, copy) HYPFieldConfigureHeaderViewBlock configureHeaderViewBlock;
@property (nonatomic, copy) HYPFieldConfigureFieldUpdatedBlock configureFieldUpdatedBlock;

- (BOOL)formFieldsAreValid;
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (HYPFormField *)formFieldAtIndexPath:(NSIndexPath *)indexPath;

- (void)resetForms;
- (void)validateForms;
- (void)disable:(BOOL)disabled;
- (void)processTargets:(NSArray *)targets;
- (void)reloadWithDictionary:(NSDictionary *)dictionary;
- (void)collapseFieldsInSection:(NSInteger)section collectionView:(UICollectionView *)collectionView;
- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths;

@end
