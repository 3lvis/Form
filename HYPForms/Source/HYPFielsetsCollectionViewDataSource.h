//
//  HYPFielsetsCollectionViewDataSource.h

//
//  Created by Elvis Nunez on 10/6/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "HYPFielsetsLayout.h"

#import "HYPBaseFormFieldCell.h"
#import "HYPFieldsetHeaderView.h"

#import "HYPFormField.h"
#import "HYPFieldset.h"

typedef void (^HYPFieldConfigureCellBlock)(id cell, NSIndexPath *indexPath, HYPFormField *field);
typedef void (^HYPFieldConfigureHeaderViewBlock)(HYPFieldsetHeaderView *headerView, NSString *kind, NSIndexPath *indexPath, HYPFieldset *fieldset);

@interface HYPFielsetsCollectionViewDataSource : NSObject <HYPFielsetsLayoutDataSource, UICollectionViewDataSource>

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

@property (nonatomic, strong) NSArray *fieldsets;
@property (nonatomic, strong) NSMutableArray *collapsedFieldsets;

@property (nonatomic, copy) HYPFieldConfigureCellBlock configureCellBlock;
@property (nonatomic, copy) HYPFieldConfigureHeaderViewBlock configureHeaderViewBlock;

- (void)collapseFieldsInSection:(NSInteger)section collectionView:(UICollectionView *)collectionView;
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
