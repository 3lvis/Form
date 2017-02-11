//
//  DDMath.h
//  DDMathParser
//
//  Created by Dave DeLong on 11/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDExpression;
@class DDMathEvaluator;

typedef DDExpression* (^DDMathFunction)(NSArray *, NSDictionary *, DDMathEvaluator *, NSError **);

#pragma mark Error Codes

extern NSString * const DDMathParserErrorDomain;

extern NSString * const DDUnknownFunctionKey;
extern NSString * const DDUnknownVariableKey;


typedef NS_ENUM(NSInteger, DDErrorCode) {
    // ERROR CODE                                   // LOCALIZED DESCRIPTION EXAMPLE
    
    // a generic error
    DDErrorCodeInvalidFormat = 1,
    
    // parsing & tokenization errors
    DDErrorCodeInvalidOperator,                     //@"%C is not a valid operator"
    DDErrorCodeInvalidIdentifier,                   //@"unable to parse identifier
    DDErrorCodeInvalidVariable,                     //@"variable names must be at least 1 character long"
    DDErrorCodeInvalidNumber,                       //@"unable to parse number"
    DDErrorCodeUnknownOperatorPrecedence,           //@"unknown precedence for token: %@
    
    // grouping & resolution errors
    DDErrorCodeImbalancedParentheses,               //@"imbalanced parentheses", @"missing parentheses after function %@"
    DDErrorCodeInvalidOperatorArity,                //@"unknown arity for operator: %@"
    DDErrorCodeBinaryOperatorMissingLeftOperand,    //@"no left operand to binary %@"
    DDErrorCodeBinaryOperatorMissingRightOperand,   //@"no right operand to binary %@"
    DDErrorCodeUnaryOperatorMissingLeftOperand,     //@"no left operand to unary %@"
    DDErrorCodeUnaryOperatorMissingRightOperand,    //@"no right operand to unary %@"
    DDErrorCodeOperatorMissingOperands,             //@"missing operand(s) for operator: %@"
    
    // evaluation errors
    DDErrorCodeUnresolvedVariable,                  //@"unable to resolve variable expression: %@"
    DDErrorCodeUnresolvedFunction,                  //@"unable to resolve function: %@"
    DDErrorCodeInvalidFunctionReturnType,           //@"invalid return type from %@ function"
    DDErrorCodeInvalidNumberOfArguments,            //@"random() may only have up to 2 arguments"
    DDErrorCodeInvalidArgument,                     //@"upper bound (%ld) of random() must be larger than lower bound (%ld)"

};

typedef NS_ENUM(NSInteger, DDAngleMeasurementMode) {
    DDAngleMeasurementModeRadians,
    DDAngleMeasurementModeDegrees
};
