//
//  HYPFieldValue.h
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, HYPFieldValueActionType) {
    HYPFieldValueActionShow = 0,
    HYPFieldValueActionHide,
    HYPFieldValueActionEnable,
    HYPFieldValueActionDisable,
    HYPFieldValueActionNone
};

@interface HYPFieldValue : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *actionTypeString;
@property (nonatomic) HYPFieldValueActionType actionType;
@property (nonatomic, strong) NSArray *targets;

@end
