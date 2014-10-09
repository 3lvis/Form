//
//  REMAFielsetsLayout.h

//
//  Created by Elvis Nunez on 06/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

@protocol REMAFielsetsLayoutDataSource;

@interface REMAFielsetsLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id <REMAFielsetsLayoutDataSource> dataSource;

@end

@protocol REMAFielsetsLayoutDataSource <NSObject>

- (NSArray *)fieldsets;
- (NSArray *)collapsedFieldsets;

@end
