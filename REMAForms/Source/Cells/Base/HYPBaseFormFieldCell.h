//
//  REMABaseFormFieldCell.h

//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

#import "HYPFormFieldHeadingLabel.h"

#import "HYPTextFormField.h"
#import "HYPFormFieldHeadingLabel.h"

#import "REMAFormField.h"

#import "UIColor+ANDYHex.h"
#import "UIFont+Styles.h"

static const NSInteger REMAFieldCellMargin = 10.0f;
static const NSInteger REMAFieldCellItemSmallHeight = 1.0f;
static const NSInteger REMAFieldCellItemHeight = 85.0f;

static const CGFloat REMATextFormFieldCellMarginX = 10.0f;
static const CGFloat REMATextFormFieldCellTextFieldMarginTop = 30.0f;
static const CGFloat REMATextFormFieldCellTextFieldMarginBottom = 10.0f;

@interface HYPBaseFormFieldCell : UICollectionViewCell

@property (nonatomic, strong) HYPFormFieldHeadingLabel *headingLabel;

@property (nonatomic, strong) REMAFormField *field;
@property (nonatomic, getter = isDisabled) BOOL disabled;

- (void)updateFieldWithDisabled:(BOOL)disabled;
- (void)updateWithField:(REMAFormField *)field;
- (void)validate;

@end
