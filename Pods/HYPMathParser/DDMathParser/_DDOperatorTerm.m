//
//  _DDOperatorTerm.m
//  DDMathParser
//
//  Created by Dave DeLong on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_DDOperatorTerm.h"
#import "DDMathStringToken.h"
#import "DDMathParserMacros.h"

@implementation _DDOperatorTerm

- (DDParserTermType)type { return DDParserTermTypeOperator; }

- (NSString *)operatorType {
    return [[self token] operatorType];
}

- (NSInteger)operatorPrecedence {
    return [[self token] operatorPrecedence];
}

- (DDOperatorArity)operatorArity {
    return [[self token] operatorArity];
}

- (NSString *)operatorFunction {
    return [[self token] operatorFunction];
}

- (BOOL)resolveWithParser:(DDParser *)parser error:(NSError *__autoreleasing *)error {
#pragma unused(parser)
    ERR_ASSERT(error);
    if ([self operatorArity] == DDOperatorArityUnary) {
        if ([[self token] operatorAssociativity] == DDOperatorAssociativityLeft) {
            *error = ERR(DDErrorCodeUnaryOperatorMissingLeftOperand, @"no left operand to unary %@", [self token]);
        } else {
            *error = ERR(DDErrorCodeUnaryOperatorMissingRightOperand, @"no right operand to unary %@", [self token]);
        }
    } else {
        *error = ERR(DDErrorCodeOperatorMissingOperands, @"missing operands for operator: %@", [self token]);
    }
    return NO;
}

- (NSString *)description {
    return [[self token] token];
}

@end
