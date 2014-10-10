//
//  NSDictionary+HYPSafeValueForKey.h
//  HYPForms
//
//  Created by Elvis Nunez on 10/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;

@interface NSDictionary (HYPSafeValueForKey)

- (id)hyp_safeObjectForKey:(id)key;

@end
