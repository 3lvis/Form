//
//  REMAPopoverFormFieldCell.h

//
//  Created by Elvis Nunez on 08/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMABaseFormFieldCell.h"

@interface REMAPopoverFormFieldCell : REMABaseFormFieldCell

@property (nonatomic, strong) REMATextFormField *textField;
@property (nonatomic, strong) UIPopoverController *popoverController;

- (instancetype)initWithFrame:(CGRect)frame contentViewController:(UIViewController *)controller
               andContentSize:(CGSize)contentSize;

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(REMAFormField *)field;

@end
