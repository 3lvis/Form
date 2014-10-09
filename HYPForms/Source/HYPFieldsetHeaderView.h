//
//  HYPFieldsetHeaderCollectionReusableView.h

//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

static const CGFloat HYPFieldsetHeaderContentMargin = 10.0f;
static const CGFloat HYPFieldsetTitleMargin = 20.0f;
static const CGFloat HYPFieldsetHeaderHeight = 55.0f;

static NSString * const HYPFieldsetHeaderReuseIdentifier = @"HYPFieldsetHeaderReuseIdentifier";

@protocol HYPFieldsetHeaderViewDelegate;

@interface HYPFieldsetHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic) NSInteger section;

@property (nonatomic, weak) id <HYPFieldsetHeaderViewDelegate> delegate;

@end

@protocol HYPFieldsetHeaderViewDelegate <NSObject>

- (void)fieldsetHeaderViewWasPressed:(HYPFieldsetHeaderView *)headerView;

@end