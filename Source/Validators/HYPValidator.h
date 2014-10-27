//
//  HYPValidator.h
//
//  Created by Christoffer Winterkvist on 9/24/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;

@interface HYPValidator : NSObject

- (instancetype)initWithValidations:(NSDictionary *)validations;
- (BOOL)validateFieldValue:(id)fieldValue;
+ (Class)classForKey:(NSString *)key andType:(NSString *)type;

@end
