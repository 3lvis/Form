//
//  HYPPopoverFormFieldCell.h

//
//  Created by Elvis Nunez on 08/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPBaseFormFieldCell.h"
#import "HYPTitleLabel.h"

@interface HYPPopoverFormFieldCell : HYPBaseFormFieldCell

@property (nonatomic, strong) HYPTitleLabel *titleLabel;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIButton *iconButton;

- (instancetype)initWithFrame:(CGRect)frame contentViewController:(UIViewController *)controller
               andContentSize:(CGSize)contentSize;

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(HYPFormField *)field;

@end
