//
//  HYPFormTimeViewController.h
//  RemaDrifts
//
//  Created by Elvis Nunez on 1/22/13.
//  Copyright (c) 2013 Hyper. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef void (^HYPFormTimeViewActionBlock)(NSDate *date);

@protocol HYPFormTimeViewControllerDelegate;

@interface HYPFormTimeViewController : UIViewController

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, weak) id <HYPFormTimeViewControllerDelegate> delegate;
@property (nonatomic) BOOL birthdayPicker;
@property (nonatomic, copy) UIColor *actionButtonColor;
@property (nonatomic, strong) NSDate *minimumDate;

- (id)initWithDate:(NSDate *)date;
- (id)initWithDate:(NSDate *)date title:(NSString *)title message:(NSString *)message
       actionTitle:(NSString *)actionTitle actionBlock:(HYPFormTimeViewActionBlock)actionBlock;

- (CGFloat)calculatedHeight;
@end

@protocol HYPFormTimeViewControllerDelegate <NSObject>

- (void)timeController:(HYPFormTimeViewController *)timeController didChangedDate:(NSDate *)date;

@end
