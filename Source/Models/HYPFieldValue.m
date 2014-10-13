//
//  HYPFieldValue.m
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFieldValue.h"

@implementation HYPFieldValue

- (void)setActionTypeString:(NSString *)actionTypeString
{
    _actionTypeString = actionTypeString;

    if ([actionTypeString isEqualToString:@"show"]) {
        _actionType = HYPFieldValueActionShow;
    } else if ([actionTypeString isEqualToString:@"hide"]) {
        _actionType = HYPFieldValueActionHide;
    } else if ([actionTypeString isEqualToString:@"enable"]) {
        _actionType = HYPFieldValueActionEnable;
    } else if ([actionTypeString isEqualToString:@"disable"]) {
        _actionType = HYPFieldValueActionDisable;
    } else {
        _actionType = HYPFieldValueActionNone;
    }
}

@end
