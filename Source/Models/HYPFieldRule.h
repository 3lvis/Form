//
//  HYPFieldRule.h
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;

@interface HYPFieldRule : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *target;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *valueIDs;

@end
