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
    } else if ([actionTypeString isEqualToString:@"update"]){
        self.actionType = HYPFormTargetActionUpdate;
    } else {
        self.actionType = HYPFormTargetActionNone;
    }
}

+ (void)filteredTargets:(NSArray*)targets
               filtered:(void (^)(NSArray *shownTargets,
                                  NSArray *hiddenTargets,
                                  NSArray *updatedTargets))filtered
{
    NSMutableArray *shown = [NSMutableArray array];
    NSMutableArray *hidden = [NSMutableArray array];
    NSMutableArray *updated = [NSMutableArray array];

    // TODO: balance show + hide
    // TODO: balance update + hide

    for (HYPFormTarget *target in targets) {

        switch (target.actionType) {
            case HYPFormTargetActionShow:
                if (![target existsInArray:shown]) {
                    [shown addObject:target];
                }
                break;
            case HYPFormTargetActionHide:
                if (![target existsInArray:hidden]) {
                    [hidden addObject:target];
                }
                break;
            case HYPFormTargetActionUpdate:
                if (![target existsInArray:updated]) {
                    [updated addObject:target];
                }
                break;
            case HYPFormTargetActionNone:
                break;
        }
    }

    if (filtered) {
        filtered(shown, hidden, updated);
    }
}

- (BOOL)existsInArray:(NSArray *)array
{
    for (HYPFormTarget *currentTarget in array) {
        if ([currentTarget.id isEqualToString:self.id] &&
            currentTarget.actionType == self.actionType &&
            currentTarget.type == self.type) {
            return YES;
        }
    }

    return NO;
}

@end
