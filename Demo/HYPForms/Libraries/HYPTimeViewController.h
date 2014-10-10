//
//  HYPTimeViewController.h
//  HYPDrifts
//
//  Created by Elvis Nunez on 1/22/13.
//  Copyright (c) 2013 Hyper. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef void (^HYPTimeViewActionBlock)(NSDate *date);

@protocol HYPTimeViewControllerDelegate;

@interface HYPTimeViewController : UIViewController

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, weak) id <HYPTimeViewControllerDelegate> delegate;
@property (nonatomic) BOOL birthdayPicker;
@property (nonatomic, copy) UIColor *actionButtonColor;

- (id)initWithDate:(NSDate *)date;
- (id)initWithDate:(NSDate *)date title:(NSString *)title message:(NSString *)message
       actionTitle:(NSString *)actionTitle actionBlock:(HYPTimeViewActionBlock)actionBlock;

- (CGFloat)calculatedHeight;

@end

@protocol HYPTimeViewControllerDelegate <NSObject>

- (void)timeController:(HYPTimeViewController *)timeController didChangedDate:(NSDate *)date;

@end
