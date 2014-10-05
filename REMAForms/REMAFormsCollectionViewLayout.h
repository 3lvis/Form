//
//  REMAFormsCollectionViewLayout.h
//  REMAForms
//
//  Created by Elvis Nunez on 10/4/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

@class REMAFormSection;

@protocol REMAFormsCollectionViewLayoutDataSource;

@interface REMAFormsCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id <REMAFormsCollectionViewLayoutDataSource> dataSource;

@end

@protocol REMAFormsCollectionViewLayoutDataSource <NSObject>

- (REMAFormSection *)formLayoutSection;

@end
