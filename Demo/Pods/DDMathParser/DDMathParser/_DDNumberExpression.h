//
//  _DDNumberExpression.h
//  DDMathParser
//
//  Created by Dave DeLong on 11/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDExpression.h"

@interface _DDNumberExpression : DDExpression

- (id)initWithNumber:(NSNumber *)n;

@end
