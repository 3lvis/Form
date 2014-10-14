//
//  HYPFieldValue.m
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFieldValue.h"

#import "HYPFormTarget.h"

@implementation HYPFieldValue

- (void)filteredTargets:(void (^)(NSArray *shownTargets,
                                  NSArray *hiddenTargets,
                                  NSArray *enabledTargets,
                                  NSArray *disabledTargets,
                                  NSArray *updatedTargets))targets
{
    NSMutableArray *shown = [NSMutableArray array];
    NSMutableArray *hidden = [NSMutableArray array];
    NSMutableArray *enabled = [NSMutableArray array];
    NSMutableArray *disabled = [NSMutableArray array];
    NSMutableArray *updated = [NSMutableArray array];

    for (HYPFormTarget *target in self.targets) {
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

    if (targets) {
        targets(shown, hidden, enabled, disabled, updated);
    }
}

@end
