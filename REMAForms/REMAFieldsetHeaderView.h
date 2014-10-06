//
//  REMAFieldsetHeaderCollectionReusableView.h
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

static const CGFloat REMAFieldsetHeaderContentMargin = 10.0f;
static const CGFloat REMAFieldsetTitleMargin = 20.0f;
static const CGFloat REMAFieldsetHeaderHeight = 55.0f;

static NSString * const REMAFieldsetHeaderReuseIdentifier = @"REMAFieldsetHeaderReuseIdentifier";

@protocol REMAFieldsetHeaderViewDelegate;

@interface REMAFieldsetHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic) NSInteger section;

@property (nonatomic, weak) id <REMAFieldsetHeaderViewDelegate> delegate;

@end

@protocol REMAFieldsetHeaderViewDelegate <NSObject>

- (void)fieldsetHeaderViewWasPressed:(REMAFieldsetHeaderView *)headerView;

@end