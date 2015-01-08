//
//  _DDNumberTerm.m
//  DDMathParser
//
//  Created by Dave DeLong on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_DDNumberTerm.h"
#import "DDMathStringToken.h"
#import "DDExpression.h"
#import "DDMathParserMacros.h"

@implementation _DDNumberTerm

- (DDParserTermType)type { return DDParserTermTypeNumber; }
- (BOOL)resolveWithParser:(DDParser *)parser error:(NSError **)error {
#pragma unused(parser, error)
    [self setResolved:YES];
    return YES;
}
- (NSString *)description {
    return [[self token] description];
}

- (DDExpression *)expressionWithError:(NSError **)error {
    ERR_ASSERT(error);
    return [DDExpression numberExpressionWithNumber:[[self token] numberValue]];
}

@end
