//
//  REMABaseField.h

//
//  Created by Christoffer Winterkvist on 7/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef NS_ENUM(NSInteger, REMATextFieldCornerType) {
    REMATextFieldCornerFull = 0,
    REMATextFieldCornerTop,
    REMATextFieldCornerBottom
};

@interface REMABaseField : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic) REMATextFieldCornerType cornerType;

@property (nonatomic, strong) UIImage *validIcon;
@property (nonatomic, strong) UIImage *invalidIcon;
@property (nonatomic, strong) UIImage *disabledIcon;

@property (nonatomic, getter = isValid)    BOOL valid;
@property (nonatomic, getter = isFailed)   BOOL failed;
@property (nonatomic, getter = isActive)   BOOL active;
@property (nonatomic, getter = isDisabled) BOOL disabled;
@property (nonatomic, getter = isCollapsed) BOOL collapsed;
@property (nonatomic, getter = isAlternative) BOOL alternative;

- (void)setDisabled:(BOOL)disabled;
- (void)setFailed:(BOOL)failed;

- (void)validate;

@end
