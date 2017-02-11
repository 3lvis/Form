//
//  DDMathStringToken.m
//  DDMathParser
//
//  Created by Dave DeLong on 11/16/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "DDMathParser.h"
#import "DDMathStringToken.h"
#import "DDMathOperator_Internal.h"

@implementation DDMathStringToken {
	DDTokenType _tokenType;
    DDMathOperator *_operatorInfo;
    BOOL _ambiguous;
}

- (id)initWithToken:(NSString *)t type:(DDTokenType)type {
	self = [super init];
	if (self) {
        _token = [t copy];
		_tokenType = type;
		
		if (_tokenType == DDTokenTypeOperator) {
            NSArray *matching = [DDMathOperator infosForOperatorToken:t];
            if ([matching count] == 0) {
                return nil;
            } else if ([matching count] == 1) {
                _operatorInfo = [matching objectAtIndex:0];
            } else {
                _ambiguous = YES;
            }
		} else if (_tokenType == DDTokenTypeNumber) {
            _numberValue = [[NSDecimalNumber alloc] initWithString:[self token]];
            if (_numberValue == nil) {
                NSLog(@"supposedly invalid number: %@", [self token]);
                _numberValue = @0;
            }
        }
	}
	return self;
}

+ (id)mathStringTokenWithToken:(NSString *)t type:(DDTokenType)type {
	return [[self alloc] initWithToken:t type:type];
}

- (NSString *)description {
	NSMutableString * d = [NSMutableString string];
	if (_tokenType == DDTokenTypeVariable) {
		[d appendString:@"$"];
	}
	[d appendString:_token];
	return d;
}

- (NSString *)debugDescription {
    NSMutableString *d = [NSMutableString stringWithString:[self description]];
    if (_tokenType == DDTokenTypeOperator) {
        [d appendString:@" ("];
        
        DDOperatorArity arity = [self operatorArity];
        NSString *arityNames[3] = { @"UNK", @"UN", @"BIN" };
        [d appendFormat:@"arity:%@, ", arityNames[arity]];
        
        NSInteger precedence = [self operatorPrecedence];
        [d appendFormat:@"precedence:%ld, ", (long)precedence];
        
        DDOperatorAssociativity assoc = [self operatorAssociativity];
        NSString *assocNames[2] = { @"LEFT", @"RIGHT" };
        [d appendFormat:@"associativity:%@, ", assocNames[assoc]];
        
        [d appendFormat:@"function:%@", [self operatorFunction]];
        
        [d appendString:@")"];
    }
    return d;
}

- (NSString *)operatorType {
    if (_ambiguous) { return DDOperatorInvalid; }
    return [_operatorInfo function];
}

- (NSInteger)operatorPrecedence {
    if (_ambiguous) { return -1; }
    return [_operatorInfo precedence];
}

- (DDOperatorArity)operatorArity {
    if (_ambiguous) { return DDOperatorArityUnknown; }
    return [_operatorInfo arity];
}

- (NSString *)operatorFunction {
    if (_ambiguous) { return @""; }
    return [_operatorInfo function];
}

- (DDOperatorAssociativity)operatorAssociativity {
    if (_ambiguous) { return DDOperatorAssociativityLeft; }
    return [_operatorInfo associativity];
}

- (void)resolveToOperatorFunction:(NSString *)function {
    _operatorInfo = [DDMathOperator infoForOperatorFunction:function];
    _ambiguous = (_operatorInfo == nil);
}

@end
