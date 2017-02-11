//
//  _DDOperatorInfo.h
//  DDMathParser
//
//  Created by Dave DeLong on 10/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMathParser.h"

@interface DDMathOperator : NSObject <NSCopying>

@property (nonatomic, readonly, strong) NSString *function;
@property (nonatomic, readonly, strong) NSArray *tokens;
@property (nonatomic, readonly) DDOperatorArity arity;
@property (nonatomic, assign) DDOperatorAssociativity associativity;

+ (instancetype)infoForOperatorFunction:(NSString *)function;
+ (NSArray *)infosForOperatorToken:(NSString *)token;

// the only reason you'd want to init a new \c MathOperator is so you can pass it to the -[DDMathOperatorSet addOperator:...] methods
- (id)initWithOperatorFunction:(NSString *)function
                        tokens:(NSArray *)tokens
                         arity:(DDOperatorArity)arity
                 associativity:(DDOperatorAssociativity)associativity;

@end

/*!
 * Maintains a collection of \c DDMathOperators.
 * Modifications to an Operator Set are not thread-safe.
 */
@interface DDMathOperatorSet : NSObject <NSFastEnumeration, NSCopying>

@property (readonly, copy) NSArray *operators;
@property (nonatomic) BOOL interpretsPercentSignAsModulo; // default is YES

+ (instancetype)defaultOperatorSet;

- (instancetype)init;

- (DDMathOperator *)operatorForFunction:(NSString *)function;
- (NSArray *)operatorsForToken:(NSString *)token;

- (void)addOperator:(DDMathOperator *)newOperator withPrecedenceSameAsOperator:(DDMathOperator *)existingOperator;
- (void)addOperator:(DDMathOperator *)newOperator withPrecedenceLowerThanOperator:(DDMathOperator *)existingOperator;
- (void)addOperator:(DDMathOperator *)newOperator withPrecedenceHigherThanOperator:(DDMathOperator *)existingOperator;

- (void)addTokens:(NSArray *)newTokens forOperatorFunction:(NSString *)operatorFunction;

@end
