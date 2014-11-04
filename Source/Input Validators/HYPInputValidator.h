//
//  HYPInputValidator.h
//
//  Created by Christoffer Winterkvist on 22/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFormField.h"

@interface HYPInputValidator : NSObject

@property (nonatomic, strong) NSDictionary *validations;

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text withRange:(NSRange)range;

@end
