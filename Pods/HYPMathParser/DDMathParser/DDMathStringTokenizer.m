//
//  DDMathParserTokenizer.m
//  DDMathParser
//
//  Created by Dave DeLong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DDMathParser.h"
#import "DDMathStringTokenizer.h"
#import "DDMathParserMacros.h"
#import "DDMathStringToken.h"
#import "DDMathOperator.h"

#define DD_IS_DIGIT(_c) ((_c) >= '0' && (_c) <= '9')
#define DD_IS_HEX(_c) (((_c) >= '0' && (_c) <= '9') || ((_c) >= 'a' && (_c) <= 'f') || ((_c) >= 'A' && (_c) <= 'F'))
#define DD_IS_WHITESPACE(_c) ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:(_c)])

@interface DDMathStringTokenizer ()

@property (nonatomic, readonly) NSCharacterSet *operatorCharacters;

- (BOOL)_processToken:(DDMathStringToken *)token withError:(NSError **)error;
- (BOOL)_processUnknownOperatorToken:(DDMathStringToken *)token withError:(NSError **)error;
- (BOOL)_processImplicitMultiplicationWithToken:(DDMathStringToken *)token error:(NSError **)error;
- (BOOL)_processArgumentlessFunctionWithToken:(DDMathStringToken *)token error:(NSError **)error;

- (unichar)_peekNextCharacter;
- (unichar)_nextCharacter;

- (DDMathStringToken *)_nextTokenWithError:(NSError **)error;
- (DDMathStringToken *)_parseNumberWithError:(NSError **)error;
- (DDMathStringToken *)_parseFunctionWithError:(NSError **)error;
- (DDMathStringToken *)_parseVariableWithError:(NSError **)error;
- (DDMathStringToken *)_parseOperatorWithError:(NSError **)error;

@end

@implementation DDMathStringTokenizer {
    unichar *_characters;
    unichar *_caseInsensitiveCharacters;
    
    NSUInteger _length;
    NSUInteger _characterIndex;
    
    NSArray *_tokens;
    NSUInteger _tokenIndex;
    
}

@synthesize operatorCharacters=_operatorCharacters;
- (NSCharacterSet *)operatorCharacters {
    if (_operatorCharacters == nil) {
        NSArray *tokens = [self.operatorSet valueForKeyPath:@"operators.@unionOfArrays.tokens"];
        NSString *tokenString = [tokens componentsJoinedByString:@""];
        _operatorCharacters = [NSCharacterSet characterSetWithCharactersInString:tokenString];
    }
    return _operatorCharacters;
}

+ (NSCharacterSet *)_singleCharacterFunctionCharacterSet {
    static dispatch_once_t onceToken;
    static NSCharacterSet *_singleCharFunctionSet = nil;
    dispatch_once(&onceToken, ^{
        NSString *singleChars = [NSString stringWithFormat:@"\u03C0\u03D5\u03C4"];  // π, ϕ, and τ
        _singleCharFunctionSet = [NSCharacterSet characterSetWithCharactersInString:singleChars];
    });
    return _singleCharFunctionSet;
}

- (instancetype)initWithString:(NSString *)expressionString operatorSet:(DDMathOperatorSet *)operatorSet error:(NSError *__autoreleasing *)error {
	ERR_ASSERT(error);
    self = [super init];
    if (self) {
        _operatorSet = operatorSet;
        if (_operatorSet == nil) {
            _operatorSet = [DDMathOperatorSet defaultOperatorSet];
        }
        
        _length = [expressionString length];
        _characters = (unichar *)calloc(_length+1, sizeof(unichar));
        _caseInsensitiveCharacters = (unichar *)calloc(_length+1, sizeof(unichar));
        
        [expressionString getCharacters:_characters];
        [[expressionString lowercaseString] getCharacters:_caseInsensitiveCharacters];
        
        _characterIndex = 0;
        
        _tokens = [[NSMutableArray alloc] init];
        DDMathStringToken *token = nil;
        while((token = [self _nextTokenWithError:error]) != nil) {
            if (![self _processToken:token withError:error]) {
                return nil;
            }
        }
        
        [self _processToken:nil withError:error];
		
        if (error && *error) {
            self = nil;
        }
    }
    
    return self;
}

- (void)dealloc {
    free(_characters);
    free(_caseInsensitiveCharacters);
}

- (BOOL)_processToken:(DDMathStringToken *)token withError:(NSError **)error {
    //figure out if "-" and "+" are unary or binary
    (void)[self _processUnknownOperatorToken:token withError:error];
    
    if ([token operatorType] == DDOperatorUnaryPlus) {
        // the unary + operator is a no-op operator.  It does nothing, so we'll throw it out
        return YES;
    }
    
    //this adds support for not adding parentheses to functions
    (void)[self _processArgumentlessFunctionWithToken:token error:error];
    
    //this adds support for implicit multiplication
    (void)[self _processImplicitMultiplicationWithToken:token error:error];
    
    [self appendToken:token];
    return YES;
}

- (BOOL)_processUnknownOperatorToken:(DDMathStringToken *)token withError:(NSError **)error {
    DDMathStringToken *previousToken = [_tokens lastObject];
    if ([token tokenType] == DDTokenTypeOperator && [token operatorType] == DDOperatorInvalid) {
        NSString *resolvedOperator = DDOperatorInvalid;
        
        BOOL shouldBeUnary = NO;
        
        if (previousToken == nil) {
            shouldBeUnary = YES;
        } else if ([previousToken tokenType] == DDTokenTypeOperator) {
            if ([previousToken operatorArity] == DDOperatorArityBinary) {
                // a binary operator can't be followed by a binary operator
                // therefore, this is probably a unary operator
                shouldBeUnary = YES;
            } else if ([previousToken operatorArity] == DDOperatorArityUnary &&
                       [previousToken operatorAssociativity] == DDOperatorAssociativityRight) {
                // a right-assoc unary operator can be followed by another unary operator
                // (a left-assoc unary followed by a left-assoc unary is handled below)
                shouldBeUnary = YES;
            } else if ([previousToken operatorArity] == DDOperatorArityUnknown) {
                // the previous operator has unknown arity. this _should_ only happen when preceded by a comma,
                // so we'll assume that this should be a unary operator
                shouldBeUnary = YES;
            }
        }
        
        if (shouldBeUnary) {
            NSArray *potentialOperators = @[[DDMathOperator infoForOperatorFunction:DDOperatorUnaryPlus],
                                            [DDMathOperator infoForOperatorFunction:DDOperatorUnaryMinus]];
            for (DDMathOperator *info in potentialOperators) {
                if ([info.tokens containsObject:token.token]) {
                    resolvedOperator = info.function;
                    break;
                }
            }
        } else {
            NSArray *potentialOperators = @[[DDMathOperator infoForOperatorFunction:DDOperatorAdd],
                                            [DDMathOperator infoForOperatorFunction:DDOperatorMinus]];
            for (DDMathOperator *info in potentialOperators) {
                if ([info.tokens containsObject:token.token]) {
                    resolvedOperator = info.function;
                    break;
                }
            }
        }
        
        if (resolvedOperator == DDOperatorInvalid && [[token token] isEqual:@"!"]) {
            if (previousToken == nil) {
                resolvedOperator = DDOperatorLogicalNot;
            } else if ([previousToken tokenType] == DDTokenTypeOperator &&
                       ([previousToken operatorArity] == DDOperatorArityBinary ||
                        [previousToken operatorAssociativity] == DDOperatorAssociativityRight)
                       ) {
                resolvedOperator = DDOperatorLogicalNot;
            } else {
                resolvedOperator = DDOperatorFactorial;
            }
        }
        
        [token resolveToOperatorFunction:resolvedOperator];
        
        if ([token operatorType] == DDOperatorInvalid) {
            if (error != nil) {
                *error = ERR(DDErrorCodeUnknownOperatorPrecedence, @"unknown precedence for token: %@", token);
            }
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)_processImplicitMultiplicationWithToken:(DDMathStringToken *)token error:(NSError **)error {
    // See: https://github.com/davedelong/DDMathParser/wiki/Implicit-Multiplication
    
    DDMathStringToken *previousToken = [_tokens lastObject];
    if (previousToken != nil && token != nil) {
        BOOL shouldInsertMultiplier = NO;
        if ([previousToken tokenType] == DDTokenTypeNumber ||
            [previousToken tokenType] == DDTokenTypeVariable ||
            ([previousToken operatorArity] == DDOperatorArityUnary && [previousToken operatorAssociativity] == DDOperatorAssociativityLeft)) {
            
            if ([token tokenType] != DDTokenTypeOperator ||
                ([token operatorArity] == DDOperatorArityUnary && [token operatorAssociativity] == DDOperatorAssociativityRight)) {
                //inject a "multiplication" token:
                shouldInsertMultiplier = YES;
            }
            
        }
        
        if (shouldInsertMultiplier) {
            DDMathStringToken * multiply = [DDMathStringToken mathStringTokenWithToken:@"*" type:DDTokenTypeOperator];
            
            [self appendToken:multiply];
        }
    }
    return YES;
}

- (BOOL)_processArgumentlessFunctionWithToken:(DDMathStringToken *)token error:(NSError **)error {
    DDMathStringToken *previousToken = [_tokens lastObject];
    if (previousToken != nil && [previousToken tokenType] == DDTokenTypeFunction) {
        if ([token tokenType] != DDTokenTypeOperator || [token operatorType] != DDOperatorParenthesisOpen || token == nil) {
            DDMathStringToken *openParen = [DDMathStringToken mathStringTokenWithToken:@"(" type:DDTokenTypeOperator];
            [self appendToken:openParen];
            
            DDMathStringToken *closeParen = [DDMathStringToken mathStringTokenWithToken:@")" type:DDTokenTypeOperator];
            [self appendToken:closeParen];
        }
    }
    return YES;
}

// methods overridable by subclasses
- (void)didParseToken:(DDMathStringToken *)token {
    // default implementation does nothing
#pragma unused(token)
    return;
}

// methods that can be used by subclasses
- (void)appendToken:(DDMathStringToken *)token {
    [self didParseToken:token];
    if (token) {
        [(NSMutableArray *)_tokens addObject:token];
    }
}

#pragma mark NSEnumerator methods

- (NSArray *)allObjects {
    NSRange r = NSMakeRange(_tokenIndex, [_tokens count] - _tokenIndex);
    if (_tokenIndex >= [_tokens count]) { r.length = 0; }
    return [_tokens subarrayWithRange:r];
}

- (DDMathStringToken *)nextObject {
    DDMathStringToken *t = [self peekNextObject];
    if (t != nil) {
        _tokenIndex++;
    }
    return t;
}

- (DDMathStringToken *)peekNextObject {
    if (_tokenIndex >= [_tokens count]) { return nil; }
    return [_tokens objectAtIndex:_tokenIndex];
}

- (void)reset {
	_tokenIndex = 0;
    _characterIndex = 0;
}

#pragma mark Character methods

- (unichar)_peekNextCharacter {
    return [self _peek:_characters];
}

- (unichar)_nextCharacter {
    return [self _next:_characters];
}

- (unichar)_peek:(unichar *)characters {
    if (_characterIndex >= _length) { return '\0'; }
    return characters[_characterIndex];
}

- (unichar)_next:(unichar *)characters {
    unichar character = [self _peek:characters];
    if (character != '\0') { _characterIndex++; }
    return character;
}

- (DDMathStringToken *)_nextTokenWithError:(NSError **)error {
    ERR_ASSERT(error);
    unichar next = [self _peekNextCharacter];
    while (DD_IS_WHITESPACE(next)) {
        (void)[self _nextCharacter];
        next = [self _peekNextCharacter];
    }
    if (next == '\0') { return nil; }
    
    DDMathStringToken *token = nil;
    if (DD_IS_DIGIT(next) || next == '.') {
        token = [self _parseNumberWithError:error];
    }
    
    if (token == nil && next == '$') {
        token = [self _parseVariableWithError:error];
    }
    
    if (token == nil && (next == '"' || next == '\'')) {
        token = [self _parseStringVariableWithError:error];
    }
    
    if (token == nil) {
        token = [self _parseOperatorWithError:error];
    }
    
    if (token == nil) {
        token = [self _parseFunctionWithError:error];
    }
    
    if (token != nil) {
        *error = nil;
    }
    return token;
}

- (DDMathStringToken *)_parseNumberWithError:(NSError **)error {
    ERR_ASSERT(error);
    NSUInteger start = _characterIndex;
    DDMathStringToken *token = nil;
    
    if ([self _peekNextCharacter] == '0') {
        _characterIndex++;
        unichar next = [self _peekNextCharacter];
        if (next == 'x' || next == 'X') {
            _characterIndex++;
            return [self _parseHexNumberWithError:error];
        } else {
            _characterIndex = start;
        }
    }
    
    while (DD_IS_DIGIT([self _peekNextCharacter])) {
        _characterIndex++;
    }
    
    if ([self _peekNextCharacter] == '.') {
        _characterIndex++;
        
        while (DD_IS_DIGIT([self _peekNextCharacter])) {
            _characterIndex++;
        }
    }
    
    NSUInteger indexBeforeE = _characterIndex;
    if ([self _peekNextCharacter] == 'e' || [self _peekNextCharacter] == 'E') {
        _characterIndex++;
        
        // there might a "-" or "+" character preceding the exponent
        if ([self _peekNextCharacter] == '-' || [self _peekNextCharacter] == '+') {
            _characterIndex++;
        }
        
        NSUInteger indexAtExponentDigits = _characterIndex;
        while (DD_IS_DIGIT([self _peekNextCharacter])) {
            _characterIndex++;
        }
        
        if (_characterIndex == indexAtExponentDigits) {
            // we didn't read any digits following the "e" or the "-"/"+"
            // therefore the entire exponent range is invalid
            // reset to just before we saw the "e"
            _characterIndex = indexBeforeE;
        }
    }
    
    NSUInteger length = _characterIndex - start;
    if (length > 0) {
        if (length != 1 || _characters[start] != '.') { // do not recognize "." as a number
            NSString *rawToken = [NSString stringWithCharacters:(_characters+start) length:length];
            token = [DDMathStringToken mathStringTokenWithToken:rawToken type:DDTokenTypeNumber];
        }
    }
    
    if (!token) {
        _characterIndex = start;
        *error = ERR(DDErrorCodeInvalidNumber, @"unable to parse number");
    }
    return token;
}

- (DDMathStringToken *)_parseHexNumberWithError:(NSError **)error {
    ERR_ASSERT(error);
    DDMathStringToken *token = nil;
    NSUInteger start = _characterIndex;
    while (DD_IS_HEX([self _peekNextCharacter])) {
        _characterIndex++;
    }
    NSUInteger length = _characterIndex - start;
    if (length > 0) {
        NSString *rawHex = [NSString stringWithCharacters:(_characters+start) length:length];
        NSScanner *scanner = [NSScanner scannerWithString:rawHex];
        
        unsigned long long hexValue = 0;
        [scanner scanHexLongLong:&hexValue];
        
        token = [DDMathStringToken mathStringTokenWithToken:[@(hexValue) stringValue] type:DDTokenTypeNumber];
    }
    
    if (!token) {
        _characterIndex = start;
        *error = ERR(DDErrorCodeInvalidNumber, @"unable to parse hex number");
    }
    return token;
}

- (DDMathStringToken *)_parseFunctionWithError:(NSError **)error {
    ERR_ASSERT(error);
    NSUInteger start = _characterIndex;
    NSUInteger length = 0;
    
    NSCharacterSet *singleCharacterFunctions = [[self class] _singleCharacterFunctionCharacterSet];
    if ([singleCharacterFunctions characterIsMember:[self _peekNextCharacter]]) {
        length++;
        _characterIndex++;
    } else {
        NSCharacterSet *operatorSet = self.operatorCharacters;
        while ([operatorSet characterIsMember:[self _peekNextCharacter]] == NO &&
               DD_IS_WHITESPACE([self _peekNextCharacter]) == NO &&
               [self _peekNextCharacter] != '\0') {
            
            length++;
            _characterIndex++;
        }
    }
    
    if (length > 0) {
        NSString *rawToken = [NSString stringWithCharacters:(_characters+start) length:length];
        return [DDMathStringToken mathStringTokenWithToken:rawToken type:DDTokenTypeFunction];
    }
    
    _characterIndex = start;
    *error = ERR(DDErrorCodeInvalidIdentifier, @"unable to parse identifier");
    return nil;
}

- (DDMathStringToken *)_parseVariableWithError:(NSError **)error {
    ERR_ASSERT(error);
    NSUInteger start = _characterIndex;
    _characterIndex++; // consume the $
    DDMathStringToken *token = [self _parseFunctionWithError:error];
    if (token == nil) {
        _characterIndex = start;
        *error = ERR(DDErrorCodeInvalidVariable, @"variable names must be at least 1 character long");
    } else {
        token = [DDMathStringToken mathStringTokenWithToken:[token token] type:DDTokenTypeVariable];
        *error = nil;
    }
    return token;
}

- (DDMathStringToken *)_parseStringVariableWithError:(NSError **)error {
    ERR_ASSERT(error);
    NSUInteger start = _characterIndex;
    unichar quoteChar = [self _peekNextCharacter];
    
    _characterIndex++; // consume the quote
    
    BOOL isBackslashEscaped = NO;
    NSMutableString *cleaned = [NSMutableString stringWithCapacity:42];
    
    while (1) {
        unichar next = [self _peekNextCharacter];
        if (next == '\0') { break; }
        
        if (isBackslashEscaped == NO) {
            if (next == '\\') {
                isBackslashEscaped = YES;
                _characterIndex++; // consume the backslash
            } else if (next != quoteChar) {
                [cleaned appendFormat:@"%C", [self _nextCharacter]];
            } else {
                // it's a single/double quote
                break;
            }
        } else {
            [cleaned appendFormat:@"%C", next];
            isBackslashEscaped = NO;
            _characterIndex++;
        }
    }
    
    if ([self _peekNextCharacter] != quoteChar) {
        _characterIndex = start;
        *error = ERR(DDErrorCodeInvalidVariable, @"Unable to parsed quoted variable name");
        return nil;
    } else {
        _characterIndex++;
        *error = nil;
        return [DDMathStringToken mathStringTokenWithToken:cleaned type:DDTokenTypeVariable];
    }
}

- (DDMathStringToken *)_parseOperatorWithError:(NSError **)error {
    ERR_ASSERT(error);
    NSUInteger start = _characterIndex;
    NSUInteger length = 1;
    
    unichar character = [self _next:_caseInsensitiveCharacters];
    
    NSString *lastGood = nil;
    NSUInteger lastGoodLength = length;
    
    while ([self.operatorCharacters characterIsMember:character]) {
        NSString *tmp = [NSString stringWithCharacters:(_caseInsensitiveCharacters+start) length:length];
        NSArray *operators = [DDMathOperator infosForOperatorToken:tmp];
        if ([operators count] > 0) {
            lastGood = tmp;
            lastGoodLength = length;
        }
        character = [self _next:_caseInsensitiveCharacters];
        length++;
    }
    
    if (lastGood != nil) {
        _characterIndex = start+lastGoodLength;
        
        return [DDMathStringToken mathStringTokenWithToken:lastGood type:DDTokenTypeOperator];
    }
    
    _characterIndex = start;
    *error = ERR(DDErrorCodeInvalidOperator, @"%C is not a valid operator", character);
    return nil;
}

@end

@implementation DDMathStringTokenizer (Deprecated)

+ (id)tokenizerWithString:(NSString *)expressionString error:(NSError *__autoreleasing *)error {
    return [[self alloc] initWithString:expressionString operatorSet:nil error:error];
}

- (id)initWithString:(NSString *)expressionString error:(NSError *__autoreleasing *)error {
    return [self initWithString:expressionString operatorSet:nil error:error];
}

@end
