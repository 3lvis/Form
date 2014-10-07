//
//  REMABaseFieldCell.h

//
//  Created by Elvis Nunez on 11/08/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFormField.h"

static const NSInteger REMAFieldCellMargin = 10.0f;
static const NSInteger REMAFieldCellItemSmallHeight = 1.0f;
static const NSInteger REMAFieldCellItemHeight = 100.0f;

@interface REMABaseFieldCollectionCell : UICollectionViewCell

@property (nonatomic, strong) REMAFormField *field;
@property (nonatomic, getter = isCollapsed) BOOL collapsed;
@property (nonatomic, getter = isDisabled) BOOL disabled;

- (void)updateFieldWithCollapsed:(BOOL)collapsed;
- (void)updateFieldWithDisabled:(BOOL)disabled;
- (void)updateWithField:(REMAFormField *)field;
- (void)validate;

@end
