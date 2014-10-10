//
//  HYPFielsetsCollectionViewController.h

//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

static const NSInteger HYPFormMarginHorizontal = 20.0f;
static const NSInteger HYPFormMarginTop = 10.0f;
static const NSInteger HYPFormMarginBottom = 30.0f;

@interface HYPFormsCollectionViewController : UICollectionViewController

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
