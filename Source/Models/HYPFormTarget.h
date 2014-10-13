//
//  HYPFormTarget.h
//  HYPForms
//
//  Created by Elvis Nunez on 10/13/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, HYPFormTargetType) {
    HYPFormTargetTypeField = 0,
    HYPFormTargetTypeSection,
    HYPFormTargetTypeNone
};

@interface HYPFormTarget : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *typeString;
@property (nonatomic) HYPFormTargetType type;

@end
