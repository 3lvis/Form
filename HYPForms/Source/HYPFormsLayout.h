//
//  HYPFielsetsLayout.h

//
//  Created by Elvis Nunez on 06/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

@protocol HYPFielsetsLayoutDataSource;

@interface HYPFormsLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id <HYPFielsetsLayoutDataSource> dataSource;

@end

@protocol HYPFielsetsLayoutDataSource <NSObject>

- (NSArray *)forms;
- (NSArray *)collapsedForms;

@end
