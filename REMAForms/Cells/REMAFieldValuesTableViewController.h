//
//  REMAFieldValuesTableViewController.h

//
//  Created by Elvis Nunez on 03/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

@class REMAFieldValue;

@protocol REMAFieldValuesTableViewControllerDelegate;

@interface REMAFieldValuesTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) REMAFieldValue *selectedValue;
@property (nonatomic, weak) id <REMAFieldValuesTableViewControllerDelegate> delegate;

- (instancetype)initWithValues:(NSArray *)values andSelectedValue:(REMAFieldValue *)selectedValue;

@end


@protocol REMAFieldValuesTableViewControllerDelegate <NSObject>

- (void)fieldValuesTableViewController:(REMAFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(REMAFieldValue *)selectedValue;

@end