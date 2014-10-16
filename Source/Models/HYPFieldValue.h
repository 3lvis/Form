//
//  HYPFieldValue.h
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;

#import "HYPFormField.h"

@interface HYPFieldValue : NSObject

@property (nonatomic, strong) id id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *targets;
@property (nonatomic, strong) HYPFormField *field;
@property (nonatomic, strong) NSNumber *value;

- (BOOL)identifierIsEqualTo:(id)identifier;

@end
