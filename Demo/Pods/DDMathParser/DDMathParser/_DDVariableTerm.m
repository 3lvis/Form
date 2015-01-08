//
//  _DDVariableTerm.m
//  DDMathParser
//
//  Created by Dave DeLong on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_DDVariableTerm.h"
#import "DDMathParserMacros.h"
#import "DDMathStringToken.h"
#import "DDExpression.h"

@implementation _DDVariableTerm

- (DDParserTermType)type { return DDParserTermTypeVariable; }
- (BOOL)resolveWithParser:(DDParser *)parser error:(NSError **)error {
#pragma unused(parser, error)
    [self setResolved:YES];
    return YES;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"$%@", [[self token] token]];
}

- (DDExpression *)expressionWithError:(NSError **)error {
    ERR_ASSERT(error);
    return [DDExpression variableExpressionWithVariable:[[self token] token]];
}

@end
