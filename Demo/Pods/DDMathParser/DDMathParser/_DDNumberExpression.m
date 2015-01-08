//
//  _DDNumberExpression.m
//  DDMathParser
//
//  Created by Dave DeLong on 11/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "DDMathParser.h"
#import "_DDNumberExpression.h"


@implementation _DDNumberExpression {
	NSNumber *_number;
}

- (id)initWithNumber:(NSNumber *)n {
	self = [super init];
	if (self) {
		_number = n;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithNumber:[aDecoder decodeObjectForKey:@"number"]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self number] forKey:@"number"];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithNumber:[self number]];
}

- (DDExpressionType)expressionType { return DDExpressionTypeNumber; }

- (DDExpression *)simplifiedExpressionWithEvaluator:(DDMathEvaluator *)evaluator error:(NSError **)error {
#pragma unused(evaluator, error)
	return self;
}

- (NSNumber *)number { return _number; }

- (NSString *)description {
	return [[self number] description];
}

@end
