//
//  _DDOperatorTerm.h
//  DDMathParser
//
//  Created by Dave DeLong on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_DDParserTerm.h"
#import "DDParserTypes.h"

@interface _DDOperatorTerm : _DDParserTerm

@property (nonatomic,readonly) NSString *operatorType;
@property (nonatomic,readonly) NSInteger operatorPrecedence;
@property (nonatomic,readonly) DDOperatorArity operatorArity;
@property (nonatomic,readonly) NSString *operatorFunction;

@end
