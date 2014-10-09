//
//  REMAFieldValuesTableViewController.h

//
//  Created by Elvis Nunez on 03/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

@class REMAFieldValue;
@class REMAFormField;

@protocol REMAFieldValuesTableViewControllerDelegate;

@interface HYPFieldValuesTableViewController : UITableViewController

@property (nonatomic, weak) REMAFormField *field;

@property (nonatomic, weak) id <REMAFieldValuesTableViewControllerDelegate> delegate;

@end


@protocol REMAFieldValuesTableViewControllerDelegate <NSObject>

- (void)fieldValuesTableViewController:(HYPFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(REMAFieldValue *)selectedValue;

@end