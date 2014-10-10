//
//  HYPFormsLayout.h

//
//  Created by Elvis Nunez on 06/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

@protocol HYPFormsLayoutDataSource;

static const NSInteger HYPFormMarginHorizontal = 20.0f;
static const NSInteger HYPFormMarginTop = 10.0f;
static const NSInteger HYPFormMarginBottom = 30.0f;

@interface HYPFormsLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id <HYPFormsLayoutDataSource> dataSource;

@end

@protocol HYPFormsLayoutDataSource <NSObject>

- (NSArray *)forms;
- (NSArray *)collapsedForms;

@end
