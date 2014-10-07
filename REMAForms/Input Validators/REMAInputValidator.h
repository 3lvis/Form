//
//  REMAInputValidator.h
//
//  Created by Christoffer Winterkvist on 22/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFormField.h"

@interface REMAInputValidator : NSObject

@property (nonatomic, strong) NSDictionary *validations;

+ (Class)validatorClass:(NSString *)string;

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text;

@end
