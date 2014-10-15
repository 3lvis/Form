//
//  HYPFormTarget.m
//  HYPForms
//
//  Created by Elvis Nunez on 10/13/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFormTarget.h"

@implementation HYPFormTarget

- (void)setTypeString:(NSString *)typeString
{
    _typeString = typeString;

    if ([typeString isEqualToString:@"field"]) {
        self.type = HYPFormTargetTypeField;
    } else if ([typeString isEqualToString:@"section"]) {
        self.type = HYPFormTargetTypeSection;
    } else {
        self.type = HYPFormTargetTypeNone;
    }
}

- (void)setActionTypeString:(NSString *)actionTypeString
{
    _actionTypeString = actionTypeString;

    if ([actionTypeString isEqualToString:@"show"]) {
        _actionType = HYPFormTargetActionShow;
    } else if ([actionTypeString isEqualToString:@"hide"]) {
        _actionType = HYPFormTargetActionHide;
    } else if ([actionTypeString isEqualToString:@"enable"]) {
        _actionType = HYPFormTargetActionEnable;
    } else if ([actionTypeString isEqualToString:@"disable"]) {
        _actionType = HYPFormTargetActionDisable;
    } else if ([actionTypeString isEqualToString:@"update"]){
        _actionType = HYPFormTargetActionUpdate;
    } else {
        _actionType = HYPFormTargetActionNone;
    }
}

+ (void)filteredTargets:(NSArray*)targets
               filtered:(void (^)(NSArray *shownTargets,
                                  NSArray *hiddenTargets,
                                  NSArray *enabledTargets,
                                  NSArray *disabledTargets,
                                  NSArray *updatedTargets))filtered
{
    NSMutableArray *shown = [NSMutableArray array];
    NSMutableArray *hidden = [NSMutableArray array];
    NSMutableArray *enabled = [NSMutableArray array];
    NSMutableArray *disabled = [NSMutableArray array];
    NSMutableArray *updated = [NSMutableArray array];

    for (HYPFormTarget *target in targets) {
        switch (target.actionType) {
            case HYPFormTargetActionShow:
                [shown addObject:target];
                break;
            case HYPFormTargetActionHide:
                [hidden addObject:target];
                break;
            case HYPFormTargetActionEnable:
                [enabled addObject:target];
                break;
            case HYPFormTargetActionDisable:
                [disabled addObject:target];
                break;
            case HYPFormTargetActionUpdate:
                [updated addObject:target];
                break;
            case HYPFormTargetActionNone:
                break;
        }
    }

    if (filtered) {
        filtered(shown, hidden, enabled, disabled, updated);
    }
}

@end
