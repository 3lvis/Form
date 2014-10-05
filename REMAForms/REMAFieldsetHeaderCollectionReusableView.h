//
//  REMAFieldsetHeaderCollectionReusableView.h
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

static const NSInteger REMAFieldsetTitleMargin = 20.0f;
static const NSInteger REMAFieldsetHeaderHeight = 50.0f;

@interface REMAFieldsetHeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *headerLabel;

@end
