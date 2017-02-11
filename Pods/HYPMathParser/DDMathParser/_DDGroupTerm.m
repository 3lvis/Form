//
//  _DDGroupTerm.m
//  DDMathParser
//
//  Created by Dave DeLong on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DDMathParser.h"
#import "_DDGroupTerm.h"
#import "DDMathStringTokenizer.h"
#import "DDMathStringToken.h"
#import "DDMathParserMacros.h"

#import "DDParser.h"
#import "_DDOperatorTerm.h"
#import "_DDFunctionTerm.h"

@interface _DDGroupTerm ()

- (NSIndexSet *)_indicesOfOperatorsWithHighestPrecedence;
- (BOOL)_reduceTermsAroundOperatorAtIndex:(NSUInteger)index withParser:(DDParser *)parser error:(NSError **)error;
- (BOOL)_reduceBinaryOperatorAtIndex:(NSUInteger)index withParser:(DDParser *)parser error:(NSError **)error;
- (BOOL)_reduceUnaryOperatorAtIndex:(NSUInteger)index withParser:(DDParser *)parser error:(NSError **)error;

@end

@implementation _DDGroupTerm

- (void)_setSubterms:(NSArray *)newTerms {
    _subterms = [newTerms mutableCopy];
}

- (id)_initWithSubterms:(NSArray *)terms error:(NSError **)error {
#pragma unused(error)
    self = [super init];
    if (self) {
        [self _setSubterms:terms];
    }
    return self;
}

- (id)_initWithTokenizer:(DDMathStringTokenizer *)tokenizer error:(NSError **)error {
    ERR_ASSERT(error);
    self = [super _initWithTokenizer:tokenizer error:error];
    if (self) {
        NSMutableArray *terms = [NSMutableArray array];
        DDMathStringToken *nextToken = [tokenizer peekNextObject];
        while (nextToken && [nextToken operatorType] != DDOperatorParenthesisClose) {
            _DDParserTerm *nextTerm = [_DDParserTerm termWithTokenizer:tokenizer error:error];
            if (nextTerm) {
                [terms addObject:nextTerm];
            } else {
                // extracting a term failed.  *error should've been filled already
                return nil;
            }
            nextToken = [tokenizer peekNextObject];
        }
        
        // consume the closing parenthesis and verify it exists
        if ([tokenizer nextObject] == nil) {
            *error = ERR(DDErrorCodeImbalancedParentheses, @"imbalanced parentheses");
            return nil;
        }
        
        [self _setSubterms:terms];
    }
    return self;
}

- (DDParserTermType)type { return DDParserTermTypeGroup; }

- (NSString *)description {
    NSArray *descriptions = [[self subterms] valueForKey:@"description"];
    NSString *description = [descriptions componentsJoinedByString:@""];
    return [NSString stringWithFormat:@"(%@)", description];
}

#pragma mark - Resolution

- (BOOL)resolveWithParser:(DDParser *)parser error:(NSError **)error {
    if ([self isResolved]) { return YES; }
    ERR_ASSERT(error);
    
    while ([[self subterms] count] > 1) {
        NSIndexSet *operatorIndices = [self _indicesOfOperatorsWithHighestPrecedence];
        if ([operatorIndices count] > 0) {
            NSUInteger index = [operatorIndices firstIndex];
            if ([operatorIndices count] > 1) {
                // we have more than one index
                // use a different index if the operator is right associative
                _DDOperatorTerm *operatorTerm = [[self subterms] objectAtIndex:index];
                
                if ([parser associativityForOperatorFunction:[operatorTerm operatorType]] == DDOperatorAssociativityRight) {
                    index = [operatorIndices lastIndex];
                }
            }
            
            // we have the index for the next operator
            if (![self _reduceTermsAroundOperatorAtIndex:index withParser:parser error:error]) {
                return NO;
            }
            
        } else {
            // more than one term is left
            // but there are no more operators
            *error = ERR(DDErrorCodeInvalidFormat, @"invalid format: %@", self);
            return NO;
        }
    }
    
    if ([[self subterms] count] > 0) {
        _DDParserTerm *subterm = [[self subterms] objectAtIndex:0];
        if (![subterm resolveWithParser:parser error:error]) {
            return NO;
        }
    }
    
    [self setResolved:YES];
    return YES;
}

- (NSIndexSet *)_indicesOfOperatorsWithHighestPrecedence {
	NSMutableIndexSet * indices = [NSMutableIndexSet indexSet];
	__block NSInteger currentPrecedence = -1;
    [[self subterms] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
#pragma unused(stop)
        _DDParserTerm *term = obj;
        if ([term type] == DDParserTermTypeOperator) {
            if ([(_DDOperatorTerm *)term operatorPrecedence] > currentPrecedence) {
                currentPrecedence = [(_DDOperatorTerm *)term operatorPrecedence];
                [indices removeAllIndexes];
                [indices addIndex:idx];
            } else if ([(_DDOperatorTerm *)term operatorPrecedence] == currentPrecedence) {
                [indices addIndex:idx];
            }
        }
    }];
	return indices;
}

- (BOOL)_reduceTermsAroundOperatorAtIndex:(NSUInteger)index withParser:(DDParser *)parser error:(NSError **)error {
    ERR_ASSERT(error);
    _DDOperatorTerm *operatorTerm = [[self subterms] objectAtIndex:index];
    
    if ([operatorTerm operatorArity] == DDOperatorArityBinary) {
        return [self _reduceBinaryOperatorAtIndex:index withParser:parser error:error];
    } else if ([operatorTerm operatorArity] == DDOperatorArityUnary) {
        return [self _reduceUnaryOperatorAtIndex:index withParser:parser error:error];
    }
    
    *error = ERR(DDErrorCodeInvalidOperatorArity, @"unknown arity for operator: %@", operatorTerm);
    return NO;
}

- (BOOL)_reduceBinaryOperatorAtIndex:(NSUInteger)index withParser:(DDParser *)parser error:(NSError **)error {
    ERR_ASSERT(error);
#pragma unused(parser)
    _DDOperatorTerm *operatorTerm = [[self subterms] objectAtIndex:index];
    
    if (index == 0) {
        *error = ERR(DDErrorCodeBinaryOperatorMissingLeftOperand, @"no left operand to binary %@", operatorTerm);
        return NO;
    }
    if (index == [[self subterms] count] - 1) {
        *error = ERR(DDErrorCodeBinaryOperatorMissingRightOperand, @"no right operand to binary %@", operatorTerm);
        return NO;
    }
    
    NSRange replacementRange = NSMakeRange(index-1, 3);
    
    _DDParserTerm *leftOperand = [[self subterms] objectAtIndex:index-1];
    _DDParserTerm *rightmostOperand = [[self subterms] objectAtIndex:index+1];
    
    NSRange rightOperandRange = NSMakeRange(index+1, 1);
    while ([rightmostOperand type] == DDParserTermTypeOperator && [(_DDOperatorTerm *)rightmostOperand operatorArity] == DDOperatorArityUnary) {
        // this should really only happen when operator is the power operator and the exponent has 1+ negations
        rightOperandRange.length++;
        if (NSMaxRange(rightOperandRange)-1 >= [[self subterms] count]) {
            *error = ERR(DDErrorCodeUnaryOperatorMissingRightOperand, @"no right operand to unary %@", rightmostOperand);
            return NO;
        }
        rightmostOperand = [[self subterms] objectAtIndex:NSMaxRange(rightOperandRange)-1];
    }
    
    if (rightOperandRange.length > 1) {
        NSArray *rightOperands = [[self subterms] subarrayWithRange:rightOperandRange];
        _DDGroupTerm *group = [[_DDGroupTerm alloc] _initWithSubterms:rightOperands error:error];
        [[self subterms] replaceObjectsInRange:rightOperandRange withObjectsFromArray:@[group]];
        
        rightmostOperand = [[self subterms] objectAtIndex:NSMaxRange(replacementRange)-1];
    }
    
    NSArray *parameters = @[leftOperand, rightmostOperand];
    _DDFunctionTerm *function = [[_DDFunctionTerm alloc] _initWithFunction:[operatorTerm operatorFunction] subterms:parameters error:error];
    
    [[self subterms] replaceObjectsInRange:replacementRange withObjectsFromArray:@[function]];
    
    return YES;
}

- (BOOL)_reduceUnaryOperatorAtIndex:(NSUInteger)index withParser:(DDParser *)parser error:(NSError **)error {
    ERR_ASSERT(error);
    _DDOperatorTerm *operatorTerm = [[self subterms] objectAtIndex:index];
    DDOperatorAssociativity associativity = [parser associativityForOperatorFunction:[operatorTerm operatorType]];
    
    NSRange replacementRange;
    _DDParserTerm *parameter = nil;
    
    if (associativity == DDOperatorAssociativityRight) {
        // right associative unary operator (negate, not)
        if (index == [[self subterms] count] - 1) {
            *error = ERR(DDErrorCodeUnaryOperatorMissingRightOperand, @"no right operand to unary %@", operatorTerm);
            return NO;
        }
        
        parameter = [[self subterms] objectAtIndex:index+1];
        replacementRange = NSMakeRange(index, 2);
        
    } else {
        // left associative unary operator (factorial)
        if (index == 0) {
            *error = ERR(DDErrorCodeUnaryOperatorMissingLeftOperand, @"no left operand to unary %@", operatorTerm);
            return NO;
        }
        
        parameter = [[self subterms] objectAtIndex:index-1];
        replacementRange = NSMakeRange(index-1, 2);
        
    }
    
    NSArray *parameters = @[parameter];
    _DDFunctionTerm *function = [[_DDFunctionTerm alloc] _initWithFunction:[operatorTerm operatorFunction] subterms:parameters error:error];
    
    [[self subterms] replaceObjectsInRange:replacementRange withObjectsFromArray:@[function]];
    
    return YES;
}

#pragma mark - Expressions

- (DDExpression *)expressionWithError:(NSError **)error {
    ERR_ASSERT(error);
    if ([[self subterms] count] == 1) {
        _DDParserTerm *term = [[self subterms] objectAtIndex:0];
        return [term expressionWithError:error];
    }
    *error = ERR(DDErrorCodeInvalidFormat, @"Unable to create expression from term: %@", self);
    return nil;
}

@end
