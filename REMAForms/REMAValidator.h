//
//  REMAValidator.h
//
//  Created by Christoffer Winterkvist on 9/24/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;

#import "REMAformField.h"

@interface REMAValidator : NSObject

- (instancetype)initWithValidations:(NSDictionary *)validations;
- (BOOL)validateFieldValue:(id)fieldValue;

@end
