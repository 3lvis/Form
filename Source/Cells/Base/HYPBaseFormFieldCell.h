//
//  HYPBaseFormFieldCell.h

//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

#import "HYPFormFieldHeadingLabel.h"

#import "HYPTextFormField.h"
#import "HYPFormFieldHeadingLabel.h"

#import "HYPFormField.h"

#import "UIColor+ANDYHex.h"
#import "UIFont+REMAStyles.h"

static const NSInteger HYPFieldCellMargin = 10.0f;
static const NSInteger HYPFieldCellItemSmallHeight = 1.0f;
static const NSInteger HYPFieldCellItemHeight = 85.0f;

static const CGFloat HYPTextFormFieldCellMarginX = 10.0f;
static const CGFloat HYPTextFormFieldCellLabelMarginX = 5.0f;
static const CGFloat HYPTextFormFieldCellTextFieldMarginTop = 30.0f;
static const CGFloat HYPTextFormFieldCellTextFieldMarginBottom = 10.0f;

@protocol HYPBaseFormFieldCellDelegate;

@interface HYPBaseFormFieldCell : UICollectionViewCell

@property (nonatomic, strong) HYPFormFieldHeadingLabel *headingLabel;

@property (nonatomic, strong) HYPFormField *field;
@property (nonatomic, getter = isDisabled) BOOL disabled;

@property (nonatomic, weak) id <HYPBaseFormFieldCellDelegate> delegate;

- (void)updateFieldWithDisabled:(BOOL)disabled;
- (void)updateWithField:(HYPFormField *)field;
- (void)validate;

@end

@protocol HYPBaseFormFieldCellDelegate <NSObject>

- (void)fieldCell:(UICollectionViewCell *)fieldCell updatedWithField:(HYPFormField *)field;

@end
