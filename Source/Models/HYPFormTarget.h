//
//  HYPFormTarget.h
//  HYPForms
//
//  Created by Elvis Nunez on 10/13/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;

#import "HYPFieldValue.h"

typedef NS_ENUM(NSInteger, HYPFormTargetType) {
    HYPFormTargetTypeField = 0,
    HYPFormTargetTypeSection,
    HYPFormTargetTypeNone
};

typedef NS_ENUM(NSInteger, HYPFormTargetActionType) {
    HYPFormTargetActionShow = 0,
    HYPFormTargetActionHide,
    HYPFormTargetActionUpdate,
    HYPFormTargetActionNone
};

@interface HYPFormTarget : NSObject

@property (nonatomic, copy) NSString *targetID;
@property (nonatomic, copy) NSString *typeString;
@property (nonatomic, copy) NSString *actionTypeString;

@property (nonatomic, strong) HYPFieldValue *value;
@property (nonatomic) HYPFormTargetType type;
@property (nonatomic) HYPFormTargetActionType actionType;

+ (void)filteredTargets:(NSArray*)targets
               filtered:(void (^)(NSArray *shownTargets,
                                  NSArray *hiddenTargets,
                                  NSArray *updatedTargets))filtered;

@end
