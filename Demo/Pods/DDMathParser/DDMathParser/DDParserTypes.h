//
//  DDParserTypes.h
//  DDMathParser
//
//  Created by Dave DeLong on 12/4/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DDOperatorAssociativity) {
	DDOperatorAssociativityLeft = 0,
	DDOperatorAssociativityRight = 1
};

typedef NS_ENUM(NSInteger, DDOperatorArity) {
    DDOperatorArityUnknown = 0,
    
    DDOperatorArityUnary,
    DDOperatorArityBinary
};

extern NSString *const DDOperatorInvalid;
extern NSString *const DDOperatorLogicalOr;
extern NSString *const DDOperatorLogicalAnd;
extern NSString *const DDOperatorLogicalNot;
extern NSString *const DDOperatorLogicalEqual;
extern NSString *const DDOperatorLogicalNotEqual;
extern NSString *const DDOperatorLogicalLessThan;
extern NSString *const DDOperatorLogicalGreaterThan;
extern NSString *const DDOperatorLogicalLessThanOrEqual;
extern NSString *const DDOperatorLogicalGreaterThanOrEqual;
extern NSString *const DDOperatorBitwiseOr;
extern NSString *const DDOperatorBitwiseXor;
extern NSString *const DDOperatorBitwiseAnd;
extern NSString *const DDOperatorLeftShift;
extern NSString *const DDOperatorRightShift;
extern NSString *const DDOperatorMinus;
extern NSString *const DDOperatorAdd;
extern NSString *const DDOperatorDivide;
extern NSString *const DDOperatorMultiply;
extern NSString *const DDOperatorModulo;
extern NSString *const DDOperatorBitwiseNot;
extern NSString *const DDOperatorFactorial;
extern NSString *const DDOperatorDegree;
extern NSString *const DDOperatorPercent;
extern NSString *const DDOperatorPower;
extern NSString *const DDOperatorParenthesisOpen;
extern NSString *const DDOperatorParenthesisClose;
extern NSString *const DDOperatorComma;
extern NSString *const DDOperatorUnaryMinus;
extern NSString *const DDOperatorUnaryPlus;
