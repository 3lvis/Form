//
//  _DDOperatorInfo.m
//  DDMathParser
//
//  Created by Dave DeLong on 10/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DDMathOperator_Internal.h"

@interface DDMathOperator ()

@property (readwrite, assign) NSInteger precedence;

@end

@implementation DDMathOperator

+ (instancetype)infoForOperatorFunction:(NSString *)function {
    return [[DDMathOperatorSet defaultOperatorSet] operatorForFunction:function];
}

+ (NSArray *)infosForOperatorToken:(NSString *)token {
    return [[DDMathOperatorSet defaultOperatorSet] operatorsForToken:token];
}

#define UNARY DDOperatorArityUnary
#define BINARY DDOperatorArityBinary
#define LEFT DDOperatorAssociativityLeft
#define RIGHT DDOperatorAssociativityRight
#define OPERATOR(_func, _toks, _arity, _prec, _assoc) [[DDMathOperator alloc] initWithOperatorFunction:(_func) tokens:(_toks) arity:(_arity) precedence:(_prec) associativity:(_assoc)]

+ (NSArray *)_defaultOperators {
    static NSArray *defaultOperators = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *operators = [NSMutableArray array];
        NSInteger precedence = 0;
        
        [operators addObject:OPERATOR(DDOperatorLogicalOr, (@[@"||", @"\u2228"]), BINARY, precedence, LEFT)];
        precedence++;
        
        [operators addObject:OPERATOR(DDOperatorLogicalAnd, (@[@"&&", @"\u2227"]), BINARY, precedence, LEFT)];
        precedence++;
        
        // == and != have the same precedence
        [operators addObject:OPERATOR(DDOperatorLogicalEqual, (@[@"==", @"="]), BINARY, precedence, LEFT)];
        [operators addObject:OPERATOR(DDOperatorLogicalNotEqual, (@[@"!="]), BINARY, precedence, LEFT)];
        precedence++;
        
        [operators addObject:OPERATOR(DDOperatorLogicalLessThan, (@[@"<"]), BINARY, precedence, LEFT)];
        precedence++;
        
        [operators addObject:OPERATOR(DDOperatorLogicalGreaterThan, (@[@">"]), BINARY, precedence, LEFT)];
        precedence++;
        
        // \u2264 is ≤, \u226f is ≯ (not greater than)
        [operators addObject:OPERATOR(DDOperatorLogicalLessThanOrEqual, (@[@"<=", @"=<", @"\u2264", @"\u226f"]), BINARY, precedence, LEFT)];
        precedence++;
        
        // \u2265 is ≥, \u226e is ≮ (not less than)
        [operators addObject:OPERATOR(DDOperatorLogicalGreaterThanOrEqual, (@[@">=", @"=>", @"\u2265", @"\u226e"]), BINARY, precedence, LEFT)];
        precedence++;
        
        // \u00AC is ¬
        [operators addObject:OPERATOR(DDOperatorLogicalNot, (@[@"!", @"\u00ac"]), UNARY, precedence, RIGHT)];
        precedence++;
        
        [operators addObject:OPERATOR(DDOperatorBitwiseOr, (@[@"|"]), BINARY, precedence, LEFT)];
        precedence++;
        
        [operators addObject:OPERATOR(DDOperatorBitwiseXor, (@[@"^"]), BINARY, precedence, LEFT)];
        precedence++;
        
        [operators addObject:OPERATOR(DDOperatorBitwiseAnd, (@[@"&"]), BINARY, precedence, LEFT)];
        precedence++;
        
        [operators addObject:OPERATOR(DDOperatorLeftShift, (@[@"<<"]), BINARY, precedence, LEFT)];
        precedence++;
        
        [operators addObject:OPERATOR(DDOperatorRightShift, (@[@">>"]), BINARY, precedence, LEFT)];
        precedence++;
        
        // addition and subtraction have the same precedence
        [operators addObject:OPERATOR(DDOperatorAdd, (@[@"+"]), BINARY, precedence, LEFT)];
        // \u2212 is −
        [operators addObject:OPERATOR(DDOperatorMinus, (@[@"-", @"\u2212"]), BINARY, precedence, LEFT)];
        precedence++;
        
        // multiplication and division have the same precedence
        // \u00d7 is ×
        [operators addObject:OPERATOR(DDOperatorMultiply, (@[@"*", @"\u00d7"]), BINARY, precedence, LEFT)];
        // \u00f7 is ÷
        [operators addObject:OPERATOR(DDOperatorDivide, (@[@"/", @"\u00f7"]), BINARY, precedence, LEFT)];
        precedence++;
        
        // NOTE: percent-as-modulo precedence goes here (between Multiply and Bitwise Not)
        
        [operators addObject:OPERATOR(DDOperatorBitwiseNot, (@[@"~"]), UNARY, precedence, RIGHT)];
        precedence++;
        
        // right associative unary operators have the same precedence
        // \u2212 is −
        [operators addObject:OPERATOR(DDOperatorUnaryMinus, (@[@"-", @"\u2212"]), UNARY, precedence, RIGHT)];
        [operators addObject:OPERATOR(DDOperatorUnaryPlus, (@[@"+"]), UNARY, precedence, RIGHT)];
        precedence++;
        
        // all the left associative unary operators have the same precedence
        [operators addObject:OPERATOR(DDOperatorFactorial, (@[@"!"]), UNARY, precedence, LEFT)];
        // \u00ba is º (option-0); not necessary a degree sign (acutally masculine ordinal), but common enough for it
        // \u00b0 is °
        [operators addObject:OPERATOR(DDOperatorDegree, (@[@"\u00ba", @"\u00b0"]), UNARY, precedence, LEFT)];
        
        // NOTE: percent-as-percent precedence goes here (same as Factorial)
        precedence++;
        
		//determine what associativity NSPredicate/NSExpression is using
		//mathematically, it should be right associative, but it's usually parsed as left associative
		//rdar://problem/8692313
		NSExpression *powerExpression = [NSExpression expressionWithFormat:@"2 ** 3 ** 2"];
		NSNumber *powerResult = [powerExpression expressionValueWithObject:nil context:nil];
        DDOperatorAssociativity powerAssociativity = LEFT;
		if ([powerResult intValue] == 512) {
			powerAssociativity = RIGHT;
		}
        
        [operators addObject:OPERATOR(DDOperatorPower, (@[@"**"]), BINARY, precedence, powerAssociativity)];
        precedence++;
        
        // ( and ) have the same precedence
        // these are defined as unary right/left associative for convenience
        [operators addObject:OPERATOR(DDOperatorParenthesisOpen, (@[@"("]), UNARY, precedence, RIGHT)];
        [operators addObject:OPERATOR(DDOperatorParenthesisClose, (@[@")"]), UNARY, precedence, LEFT)];
        precedence++;
        
        [operators addObject:OPERATOR(DDOperatorComma, (@[@","]), DDOperatorArityUnknown, precedence, LEFT)];
        precedence++;
        
        defaultOperators = [operators copy];
    });
    return defaultOperators;
}

+ (BOOL)_isValidToken:(NSString *)token {
    unichar firstChar = [token characterAtIndex:0];
    if ((firstChar >= '0' && firstChar <= '9' ) || firstChar == '.' || firstChar == '$' || firstChar == '\'' || firstChar == '"') {
        return NO;
    }
    
    NSString *trimmed = [token stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimmed isEqual:token] == NO) {
        return NO;
    }
    
    return YES;
}

- (id)initWithOperatorFunction:(NSString *)function tokens:(NSArray *)tokens arity:(DDOperatorArity)arity associativity:(DDOperatorAssociativity)associativity {
    if (arity == DDOperatorArityUnknown) {
        [NSException raise:NSInvalidArgumentException format:@"Unable to create operator with unknown arity"];
    }
    //normalize the case on operators
    tokens = [tokens valueForKey:@"lowercaseString"];
    
    //make sure they're valid
    for (NSString *token in tokens) {
        if ([DDMathOperator _isValidToken:token] == NO) {
            [NSException raise:NSInvalidArgumentException format:@"Invalid operator token: %@", token];
        }
    }
    return [self initWithOperatorFunction:function tokens:tokens arity:arity precedence:0 associativity:associativity];
}

- (id)initWithOperatorFunction:(NSString *)function tokens:(NSArray *)tokens arity:(DDOperatorArity)arity precedence:(NSInteger)precedence associativity:(DDOperatorAssociativity)associativity {
    self = [super init];
    if (self) {
        _arity = arity;
        _associativity = associativity;
        _precedence = precedence;
        _tokens = tokens;
        _function = function;
    }
    return self;
}

- (void)addTokens:(NSArray *)moreTokens {
    _tokens = [_tokens arrayByAddingObjectsFromArray:[moreTokens valueForKey:@"lowercaseString"]];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithOperatorFunction:_function
                                                   tokens:_tokens
                                                    arity:_arity
                                               precedence:_precedence
                                            associativity:_associativity];
}

- (NSString *)description {
    static NSString *ArityDesc[] = {
        @"Unknown",
        @"Unary",
        @"Binary"
    };
    
    static NSString *AssocDesc[] = {
        @"Left",
        @"Right"
    };
    
    return [NSString stringWithFormat:@"%@ {(%@) => %@(), Arity: %@, Assoc: %@, Precedence: %ld}",
            [super description],
            [_tokens componentsJoinedByString:@", "],
            _function,
            ArityDesc[_arity],
            AssocDesc[_associativity],
            (long)_precedence];
}

@end

@implementation DDMathOperatorSet {
    NSMutableOrderedSet *_operators;
    NSMutableDictionary *_operatorsByFunction;
    NSMutableDictionary *_operatorsByToken;
    
    DDMathOperator *_percentTokenOperator;
}

+ (instancetype)defaultOperatorSet {
    static DDMathOperatorSet *defaultSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultSet = [[DDMathOperatorSet alloc] init];
    });
    return defaultSet;
}

- (instancetype)init {
    // not actually the designated initializer
    return [self initWithOperators:[DDMathOperator _defaultOperators]];
}

/*!
 * The actual designated initializer
 */
- (instancetype)initWithOperators:(NSArray *)operators {
    self = [super init];
    if (self) {
        _operators = [NSMutableOrderedSet orderedSetWithArray:[DDMathOperator _defaultOperators]];
        _operatorsByFunction = [NSMutableDictionary dictionary];
        _operatorsByToken = [NSMutableDictionary dictionary];
        
        for (DDMathOperator *op in _operators) {
            [_operatorsByFunction setObject:op forKey:op.function];
            for (NSString *token in op.tokens) {
                NSMutableOrderedSet *operatorsForToken = [_operatorsByToken objectForKey:token];
                if (operatorsForToken == nil) {
                    operatorsForToken = [NSMutableOrderedSet orderedSet];
                    [_operatorsByToken setObject:operatorsForToken forKey:token];
                }
                [operatorsForToken addObject:op];
            }
        }
        
        _interpretsPercentSignAsModulo = YES;
        _percentTokenOperator = OPERATOR(DDOperatorModulo, @[@"%"], BINARY, 0, LEFT);
        DDMathOperator *multiply = [self operatorForFunction:DDOperatorMultiply];
        [self addOperator:_percentTokenOperator withPrecedenceHigherThanOperator:multiply];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    DDMathOperatorSet *dupe = [[[self class] alloc] initWithOperators:_operators.array];
    dupe.interpretsPercentSignAsModulo = self.interpretsPercentSignAsModulo;
    return dupe;
}

- (NSArray *)operators {
    return [_operators.array copy];
}

- (void)setInterpretsPercentSignAsModulo:(BOOL)interpretsPercentSignAsModulo {
    if (interpretsPercentSignAsModulo != _interpretsPercentSignAsModulo) {
        _interpretsPercentSignAsModulo = interpretsPercentSignAsModulo;
        
        [_operators removeObject:_percentTokenOperator];
        [_operatorsByFunction removeObjectForKey:_percentTokenOperator.function];
        for (NSString *token in _percentTokenOperator.tokens) {
            NSMutableOrderedSet *operatorsForToken = [_operatorsByToken objectForKey:token];
            [operatorsForToken removeObject:_percentTokenOperator];
            if ([operatorsForToken count] == 0) {
                [_operatorsByToken removeObjectForKey:token];
            }
        }
        
        DDMathOperator *relative = nil;
        if (_interpretsPercentSignAsModulo) {
            _percentTokenOperator = OPERATOR(DDOperatorModulo, @[@"%"], BINARY, 0, LEFT);
            relative = [self operatorForFunction:DDOperatorMultiply];
        } else {
            _percentTokenOperator = OPERATOR(DDOperatorPercent, @[@"%"], UNARY, 0, LEFT);
            // this will put it at the same precedence as factorial and dtor
            relative = [self operatorForFunction:DDOperatorUnaryMinus];
        }
        [self addOperator:_percentTokenOperator withPrecedenceHigherThanOperator:relative];
    }
}

- (void)addTokens:(NSArray *)newTokens forOperatorFunction:(NSString *)operatorFunction {
    DDMathOperator *existing = [self operatorForFunction:operatorFunction];
    if (existing == nil) {
        [NSException raise:NSInvalidArgumentException format:@"No operator is defined for function '%@'", operatorFunction];
        return;
    }
    
    DDMathOperator *newOperator = [[DDMathOperator alloc] initWithOperatorFunction:operatorFunction tokens:newTokens arity:0 precedence:0 associativity:0];
    [self addOperator:newOperator withPrecedenceSameAsOperator:existing];
}

- (void)addOperator:(DDMathOperator *)newOperator withPrecedenceHigherThanOperator:(DDMathOperator *)existingOperator {
    newOperator.precedence = existingOperator.precedence + 1;
    [self _processNewOperator:newOperator relativity:NSOrderedAscending];
}

- (void)addOperator:(DDMathOperator *)newOperator withPrecedenceSameAsOperator:(DDMathOperator *)existingOperator {
    newOperator.precedence = existingOperator.precedence;
    [self _processNewOperator:newOperator relativity:NSOrderedSame];
}

- (void)addOperator:(DDMathOperator *)newOperator withPrecedenceLowerThanOperator:(DDMathOperator *)existingOperator {
    newOperator.precedence = existingOperator.precedence - 1;
    [self _processNewOperator:newOperator relativity:NSOrderedDescending];
}

- (DDMathOperator *)operatorForFunction:(NSString *)function {
    return [_operatorsByFunction objectForKey:function];
}

- (NSArray *)operatorsForToken:(NSString *)token {
    token = [token lowercaseString];
    NSOrderedSet *operators = [_operatorsByToken objectForKey:token];
    return operators.array;
}

#pragma mark - Private

- (void)_processNewOperator:(DDMathOperator *)newOperator relativity:(NSComparisonResult)relativity {
    // first, see if there's an operator for this function already
    DDMathOperator *existingOperatorForFunction = [_operatorsByFunction objectForKey:newOperator.function];
    DDMathOperator *resolvedOperator = newOperator;
    if (existingOperatorForFunction != nil) {
        resolvedOperator = existingOperatorForFunction;
        // there is; just add new tokens; don't change any precedence
        [existingOperatorForFunction addTokens:newOperator.tokens];
    } else {
        // there is not.  this is a genuinely new operator
        
        // first, make sure the tokens involved in this new operator are unique
        for (NSString *token in newOperator.tokens) {
            DDMathOperator *existing = [_operatorsByToken objectForKey:[token lowercaseString]];
            if (existing != nil) {
                [NSException raise:NSInvalidArgumentException format:@"An operator is already defined for '%@'", token];
            }
        }
        
        [_operators addObject:newOperator];
        
        if (relativity != NSOrderedSame) {
            NSInteger newPrecedence = newOperator.precedence;
            
            if (relativity == NSOrderedAscending) {
                // the new operator has a precedence higher than the original operator
                // all operators that have an equivalent (or higher) precedence need to be bumped up one
                // to accomodate the new operator
                [_operators enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    DDMathOperator *op = obj;
                    if (op.precedence >= newPrecedence) {
                        op.precedence++;
                    }
                }];
            } else {
                [_operators enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    DDMathOperator *op = obj;
                    if (op.precedence > newPrecedence || op == newOperator) {
                        op.precedence++;
                    }
                }];
            }
        }
        
        [_operators sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"precedence" ascending:YES]]];
        [_operatorsByFunction setObject:newOperator forKey:newOperator.function];
    }
    
    for (NSString *token in newOperator.tokens) {
        NSString *lowercaseToken = [token lowercaseString];
        NSMutableOrderedSet *operatorsForToken = [_operatorsByToken objectForKey:lowercaseToken];
        if (operatorsForToken == nil) {
            operatorsForToken = [NSMutableOrderedSet orderedSet];
            [_operatorsByToken setObject:operatorsForToken forKey:lowercaseToken];
        }
        [operatorsForToken addObject:resolvedOperator];
    }
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    return [_operators countByEnumeratingWithState:state objects:buffer count:len];
}

@end
