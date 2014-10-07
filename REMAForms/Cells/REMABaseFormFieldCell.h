//
//  REMABaseFormFieldCell.h
//  REMAForms
//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

#import "REMAFormField.h"

static const NSInteger REMAFieldCellMargin = 10.0f;
static const NSInteger REMAFieldCellItemSmallHeight = 1.0f;
static const NSInteger REMAFieldCellItemHeight = 100.0f;

@interface REMABaseFormFieldCell : UICollectionViewCell

@property (nonatomic, strong) REMAFormField *field;
@property (nonatomic, getter = isDisabled) BOOL disabled;

- (void)updateFieldWithDisabled:(BOOL)disabled;
- (void)updateWithField:(REMAFormField *)field;
- (void)validate;

@end
