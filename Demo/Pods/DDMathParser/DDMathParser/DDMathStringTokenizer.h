//
//  DDMathParserTokenizer.h
//  DDMathParser
//
//  Created by Dave DeLong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDMathStringToken, DDMathOperatorSet;

@interface DDMathStringTokenizer : NSEnumerator

@property (readonly) DDMathOperatorSet *operatorSet;

- (instancetype)initWithString:(NSString *)expressionString operatorSet:(DDMathOperatorSet *)operatorSet error:(NSError **)error;

- (DDMathStringToken *)peekNextObject;

- (void)reset;

// methods overridable by subclasses
- (void)didParseToken:(DDMathStringToken *)token;

// methods that can be used by subclasses
- (void)appendToken:(DDMathStringToken *)token;

@end

@interface DDMathStringTokenizer (Deprecated)

+ (id)tokenizerWithString:(NSString *)expressionString error:(NSError **)error __attribute__((deprecated("Use -initWithString:operatorSet:error: instead")));
- (id)initWithString:(NSString *)expressionString error:(NSError **)error __attribute__((deprecated("Use -initWithString:operatorSet:error: instead")));

@end
