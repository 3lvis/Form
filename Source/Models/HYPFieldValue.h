//
//  HYPFieldValue.h
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;

@interface HYPFieldValue : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *targets;

- (void)filteredTargets:(void (^)(NSArray *shownTargets,
                                  NSArray *hiddenTargets,
                                  NSArray *enabledTargets,
                                  NSArray *disabledTargets,
                                  NSArray *updatedTargets))targets;


@end
