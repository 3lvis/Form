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
        self.actionType = HYPFormTargetActionShow;
    } else if ([actionTypeString isEqualToString:@"hide"]) {
        self.actionType = HYPFormTargetActionHide;
    } else if ([actionTypeString isEqualToString:@"enable"]) {
        self.actionType = HYPFormTargetActionEnable;
    } else if ([actionTypeString isEqualToString:@"disable"]) {
        self.actionType = HYPFormTargetActionDisable;
    } else if ([actionTypeString isEqualToString:@"update"]){
        self.actionType = HYPFormTargetActionUpdate;
    } else {
        self.actionType = HYPFormTargetActionNone;
    }
}

+ (void)filteredTargets:(NSArray*)targets
               filtered:(void (^)(NSArray *shownTargets,
                                  NSArray *hiddenTargets,
                                  NSArray *enabledTargets,
                                  NSArray *disabledTargets,
                                  NSArray *updatedTargets))filtered
{
    NSMutableDictionary *shown = [NSMutableDictionary dictionary];
    NSMutableDictionary *hidden = [NSMutableDictionary dictionary];
    NSMutableDictionary *enabled = [NSMutableDictionary dictionary];
    NSMutableDictionary *disabled = [NSMutableDictionary dictionary];
    NSMutableDictionary *updated = [NSMutableDictionary dictionary];

    // TODO: balance show + hide
    // TODO: balance update + hide

    for (HYPFormTarget *target in targets) {
        switch (target.actionType) {
            case HYPFormTargetActionShow:
                [shown setValue:target forKey:target.id];
                break;
            case HYPFormTargetActionHide:
                [hidden setValue:target forKey:target.id];
                break;
            case HYPFormTargetActionEnable:
                [enabled setValue:target forKey:target.id];
                break;
            case HYPFormTargetActionDisable:
                [disabled setValue:target forKey:target.id];
                break;
            case HYPFormTargetActionUpdate:
                [updated setValue:target forKey:target.id];
                break;
            case HYPFormTargetActionNone:
                break;
        }
    }

    if (filtered) {
        filtered([shown allValues], [hidden allValues], [enabled allValues], [disabled allValues], [updated allValues]);
    }
}

@end
