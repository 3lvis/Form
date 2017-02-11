//
//  _DDFunctionExpression.h
//  DDMathParser
//
//  Created by Dave DeLong on 11/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDExpression.h"

@interface _DDFunctionExpression : DDExpression

- (id)initWithFunction:(NSString *)f arguments:(NSArray *)a error:(NSError **)error;

@end
