//
//  REMAFieldCollectionViewCell.h
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

static const NSInteger REMAFieldCellMargin = 10.0f;
static const NSInteger REMAFieldCellItemSmallHeight = 1.0f;
static const NSInteger REMAFieldCellItemHeight = 95.0f;

static NSString * const REMAFieldReuseIdentifier = @"REMAFieldReuseIdentifier";

@interface REMAFieldCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *fieldLabel;

@end
