//
//  HYPPopoverFormFieldCell.h

//
//  Created by Elvis Nunez on 08/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPBaseFormFieldCell.h"

static const CGFloat HYPPopFormIconWidth = 38.0f;

@interface HYPPopoverFormFieldCell : HYPBaseFormFieldCell

@property (nonatomic, strong) HYPTextFormField *textField;
@property (nonatomic, strong) UIPopoverController *popoverController;

- (instancetype)initWithFrame:(CGRect)frame contentViewController:(UIViewController *)controller
               andContentSize:(CGSize)contentSize;

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(HYPFormField *)field;

@end
