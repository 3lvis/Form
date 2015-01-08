//
//  _DDDecimalFunctions.m
//  DDMathParser
//
//  Created by Dave DeLong on 12/24/10.
//  Copyright 2010 Home. All rights reserved.
//
#import "DDMathParser.h"
#import "_DDDecimalFunctions.h"

#define IS_FATAL(_e) ((_e) == NSCalculationUnderflow || (_e) == NSCalculationOverflow || (_e) == NSCalculationDivideByZero)

#pragma mark Constants

NSDecimal DDDecimalNAN() {
    static NSDecimalNumber * _nan = nil;
    if (_nan == nil) {
        _nan = [NSDecimalNumber notANumber];
    }
    return [_nan decimalValue];
}

NSDecimal DDDecimalEpsilon() {
    static NSDecimalNumber *_epsilon = nil;
    if (_epsilon == nil) {
        _epsilon = [[NSDecimalNumber alloc] initWithMantissa:1 exponent:-64 isNegative:NO];
    }
    return [_epsilon decimalValue];
}

NSDecimal DDDecimalNegativeOne() {
	static NSDecimalNumber * _minusOne = nil;
	if (_minusOne == nil) {
		_minusOne = [[NSDecimalNumber alloc] initWithMantissa:1 exponent:0 isNegative:YES];
	}
	return [_minusOne decimalValue];
}

NSDecimal DDDecimalZero() {
	return [[NSDecimalNumber zero] decimalValue];
}

NSDecimal DDDecimalOne() {
	static NSDecimalNumber * _one = nil;
	if (_one == nil) {
		_one = [[NSDecimalNumber alloc] initWithMantissa:1 exponent:0 isNegative:NO];
	}
	return [_one decimalValue];
}

NSDecimal DDDecimalTwo() {
	static NSDecimalNumber * _two = nil;
	if (_two == nil) {
		_two = [[NSDecimalNumber alloc] initWithMantissa:2 exponent:0 isNegative:NO];
	}
	return [_two decimalValue];
}

NSDecimal DDDecimalPhi() {
    static NSDecimalNumber *_phi = nil;
    if (_phi == nil) {
        _phi = [[NSDecimalNumber alloc] initWithString:@"1.61803398874989484820458683436563811772030917980576286213544862270526046281890"];
    }
    return [_phi decimalValue];
}

NSDecimal DDDecimalPi() {
	static NSDecimalNumber * _pi = nil;
	if (_pi == nil) {
		_pi = [[NSDecimalNumber alloc] initWithString:@"3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679"];
	}
	return [_pi decimalValue];
}

NSDecimal DDDecimal2Pi() {
	static NSDecimalNumber * _2pi = nil;
	if (_2pi == nil) {
		NSDecimal pi = DDDecimalPi();
		NSDecimal two = DDDecimalTwo();
		NSDecimal tpi;
		NSDecimalMultiply(&tpi, &pi, &two, NSRoundBankers);
		_2pi = [[NSDecimalNumber alloc] initWithDecimal:tpi];
	}
	return [_2pi decimalValue];
}

NSDecimal DDDecimalPi_2() {
	static NSDecimalNumber * _pi_2 = nil;
	if (_pi_2 == nil) {
		_pi_2 = [[NSDecimalNumber alloc] initWithString:@"1.5707963267948966192313216916397514420985846996875529104874722961539082031431044993140174126710585340"];
	}
	return [_pi_2 decimalValue];
}

NSDecimal DDDecimalPi_4() {
	static NSDecimalNumber * _pi_4 = nil;
	if (_pi_4 == nil) {
		_pi_4 = [[NSDecimalNumber alloc] initWithString:@"0.7853981633974483096156608458198757210492923498437764552437361480769541015715522496570087063355292670"];
	}
	return [_pi_4 decimalValue];
}

NSDecimal DDDecimalSqrt2() {
	static NSDecimalNumber * _sqrt2 = nil;
	if (_sqrt2 == nil) {
		_sqrt2 = [[NSDecimalNumber alloc] initWithString:@"1.414213562373095048801688724209698078569671875376948073176679737990732478462107038850387534327641572"];
	}
	return [_sqrt2 decimalValue];
}

NSDecimal DDDecimalE() {
	static NSDecimalNumber * _e = nil;
	if (_e == nil) {
		_e = [[NSDecimalNumber alloc] initWithString:@"2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274"];
	}
	return [_e decimalValue];
}

NSDecimal DDDecimalLog2e() {
	static NSDecimalNumber * _log2e = nil;
	if (_log2e == nil) {
		_log2e = [[NSDecimalNumber alloc] initWithString:@"1.4426950408889634073599246810018921374266459541529859341354494069311092191811850798855266228935063445"];
	}
	return [_log2e decimalValue];
}

NSDecimal DDDecimalLog10e() {
	static NSDecimalNumber * _log10e = nil;
	if (_log10e == nil) {
		_log10e = [[NSDecimalNumber alloc] initWithString:@"0.4342944819032518276511289189166050822943970058036665661144537831658646492088707747292249493384317483"];
	}
	return [_log10e decimalValue];
}

NSDecimal DDDecimalLn2() {
	static NSDecimalNumber * _ln2 = nil;
	if (_ln2 == nil) {
		_ln2 = [[NSDecimalNumber alloc] initWithString:@"0.693147180559945309417232121458176568075500134360255254120680009493393621969694715605863326996418687"];
	}
	return [_ln2 decimalValue];
}

NSDecimal DDDecimalLn10() {
	static NSDecimalNumber * _ln10 = nil;
	if (_ln10 == nil) {
		_ln10 = [[NSDecimalNumber alloc] initWithString:@"2.30258509299404568401799145468436420760110148862877297603332790096757260967735248023599720508959830"];
	}
	return [_ln10 decimalValue];
}

#pragma mark Creation

NSDecimal DDDecimalFromInteger(NSInteger i) {
	unsigned long long ull = i;
	return [[NSDecimalNumber decimalNumberWithMantissa:ull exponent:0 isNegative:(i < 0)] decimalValue];
}

NSDecimal DDDecimalFromDouble(double d) {
	return [@(d) decimalValue];
}

#pragma mark Extraction

NSUInteger DDUIntegerFromDecimal(NSDecimal d) {
    return [[NSDecimalNumber decimalNumberWithDecimal:d] unsignedIntegerValue];
}

float DDFloatFromDecimal(NSDecimal d) {
	return [[NSDecimalNumber decimalNumberWithDecimal:d] floatValue];
}

double DDDoubleFromDecimal(NSDecimal d) {
	return [[NSDecimalNumber decimalNumberWithDecimal:d] doubleValue];
}

#pragma mark Utilties

BOOL DDDecimalIsNegative(NSDecimal d) {
	NSDecimal z = DDDecimalZero();
	return (NSDecimalCompare(&d, &z) == NSOrderedAscending); //d < z
}

BOOL DDDecimalIsInteger(NSDecimal d) {
	NSDecimal rounded = d;
	NSDecimalRound(&rounded, &d, 0, NSRoundDown);
	return (NSDecimalCompare(&rounded, &d) == NSOrderedSame);
}

void DDDecimalNegate(NSDecimal *d) {
    NSDecimal nOne = DDDecimalNegativeOne();
    NSDecimalMultiply(d, d, &nOne, NSRoundBankers);
}

void DDDecimalInvert(NSDecimal *d) {
    NSDecimal one = DDDecimalOne();
    NSDecimalDivide(d, &one, d, NSRoundBankers);
}

NSDecimal DDDecimalAdd(NSDecimal a, NSDecimal b) {
    NSDecimal r;
    NSDecimalAdd(&r, &a, &b, NSRoundBankers);
    return r;
}

NSDecimal DDDecimalSubtract(NSDecimal a, NSDecimal b) {
    NSDecimal r;
    NSDecimalSubtract(&r, &a, &b, NSRoundBankers);
    return r;
}

NSDecimal DDDecimalMultiply(NSDecimal a, NSDecimal b) {
    NSDecimal r;
    NSDecimalMultiply(&r, &a, &b, NSRoundBankers);
    return r;
}

NSDecimal DDDecimalDivide(NSDecimal a, NSDecimal b) {
    NSDecimal r;
    NSDecimalDivide(&r, &a, &b, NSRoundBankers);
    return r;
}

NSDecimal DDDecimalAverage2(NSDecimal a, NSDecimal b) {
	NSDecimal r;
	NSDecimalAdd(&r, &a, &b, NSRoundBankers);
	NSDecimal t = DDDecimalTwo();
	NSDecimalDivide(&r, &r, &t, NSRoundBankers);
	return r;
}

NSDecimal DDDecimalMod(NSDecimal a, NSDecimal b) {
	//a % b == a - (b * floor(a / b))
	NSDecimal result;
	NSDecimalDivide(&result, &a, &b, NSRoundBankers);
	NSDecimalRound(&result, &result, 0, NSRoundDown);
	NSDecimalMultiply(&result, &b, &result, NSRoundBankers);
	NSDecimalSubtract(&result, &a, &result, NSRoundBankers);
	return result;	
}

NSDecimal DDDecimalMod2Pi(NSDecimal a) {
    // returns a number in the range of -π to π
    NSDecimal pi = DDDecimalPi();
    NSDecimal tpi = DDDecimal2Pi();
	a = DDDecimalMod(a, tpi);
    if (NSDecimalCompare(&a, &pi) == NSOrderedDescending) {
        //a > pi
        NSDecimalSubtract(&a, &a, &tpi, NSRoundBankers);
    }
    return a;
}

NSDecimal DDDecimalAbsoluteValue(NSDecimal a) {
	if (DDDecimalIsNegative(a)) {
        DDDecimalNegate(&a);
	}
	return a;
}

BOOL DDDecimalIsProbablyEqual(NSDecimal a, NSDecimal b) {
    NSDecimal epsilon = DDDecimalEpsilon();
	
	NSDecimal diff;
	NSDecimalSubtract(&diff, &a, &b, NSRoundBankers);
	diff = DDDecimalAbsoluteValue(diff);
	return (NSDecimalCompare(&diff, &epsilon) == NSOrderedAscending);
}

NSDecimal DDDecimalSqrt(NSDecimal d) {
	NSDecimal s = d;
    if (s._exponent > 2) { s._exponent /= 2; }
	for (NSUInteger iterationCount = 0; iterationCount < 50; ++iterationCount) {
		NSDecimal low;
		NSDecimalDivide(&low, &d, &s, NSRoundBankers);
		s = DDDecimalAverage2(low, s);
		
		NSDecimal square;
		NSDecimalMultiply(&square, &s, &s, NSRoundBankers);
		if (DDDecimalIsProbablyEqual(square, d)) { break; }
	}
	return s;
}

NSDecimal DDDecimalNthRoot(NSDecimal d, NSDecimal root) {
    // ((n-1)s + a/(s^(n-1)))/n
    NSDecimal rootM1;
    NSDecimal one = DDDecimalOne();
    NSDecimalSubtract(&rootM1, &root, &one, NSRoundBankers);
    
    NSDecimal guess = d;
    // pick a big 'ol number
    for (NSUInteger i = 0; i < 50; ++i) {
        NSDecimal l;
        NSDecimalMultiply(&l, &rootM1, &guess, NSRoundBankers);
        
        NSDecimal divisor = DDDecimalPower(guess, rootM1);
        NSDecimal r;
        NSDecimalDivide(&r, &d, &divisor, NSRoundBankers);
        
        NSDecimal numerator;
        NSDecimalAdd(&numerator, &l, &r, NSRoundBankers);
        
        NSDecimalDivide(&guess, &numerator, &root, NSRoundBankers);
        
        NSDecimal power = DDDecimalPower(guess, root);
        if (DDDecimalIsProbablyEqual(d, power)) { break; }
    }
    return guess;
}

NSDecimal DDDecimalInverse(NSDecimal d) {
	NSDecimal one = DDDecimalOne();
	NSDecimalDivide(&d, &one, &d, NSRoundBankers);
	return d;
}

NSDecimal DDDecimalFactorial(NSDecimal d) {
	if (DDDecimalIsInteger(d)) {
		NSDecimal one = DDDecimalOne();
		NSDecimal final = one;
		if (DDDecimalIsNegative(d)) {
            DDDecimalNegate(&d);
		}
		while (NSDecimalCompare(&d, &one) == NSOrderedDescending) {
			NSCalculationError e = NSDecimalMultiply(&final, &final, &d, NSRoundBankers);
			NSDecimalSubtract(&d, &d, &one, NSRoundBankers);
            
            if (e == NSCalculationOverflow) {
                return DDDecimalNAN();
            }
		}
		return final;
	} else {
		double f = DDDoubleFromDecimal(d);
		f = tgamma(f+1);
		return DDDecimalFromDouble(f);
	}
}

extern NSDecimal DDDecimalPower(NSDecimal d, NSDecimal power) {
    NSDecimal r = DDDecimalOne();
    NSDecimal zero = DDDecimalZero();
    NSComparisonResult compareToZero = NSDecimalCompare(&zero, &power);
    if (compareToZero == NSOrderedSame) {
        return r;
    }
    if (DDDecimalIsInteger(power) && compareToZero == NSOrderedAscending) {
        // we can only use the NSDecimal function for positive integers
        NSUInteger p = DDUIntegerFromDecimal(power);
        NSDecimalPower(&r, &d, p, NSRoundBankers);
    } else {
        double base = DDDoubleFromDecimal(d);
        double p = DDDoubleFromDecimal(power);
        double result = pow(base, p);
        r = DDDecimalFromDouble(result);
    }
    return r;
}

NSDecimal DDDecimalLeftShift(NSDecimal base, NSDecimal shift) {
    NSDecimalRound(&shift, &shift, 0, NSRoundDown);
    if (DDDecimalIsNegative(shift)) {
        DDDecimalNegate(&shift);
        return DDDecimalRightShift(base, shift);
    }
    
    NSDecimal zero = DDDecimalZero();
    NSDecimal one = DDDecimalOne();
    NSDecimal two = DDDecimalTwo();
    
    while (NSDecimalCompare(&shift, &zero) == NSOrderedDescending) {
        NSDecimalMultiply(&base, &base, &two, NSRoundBankers);
        NSDecimalSubtract(&shift, &shift, &one, NSRoundBankers);
    }
    if (NSDecimalCompare(&base, &one) == NSOrderedAscending) {
        return zero;
    }
    return base;
}

NSDecimal DDDecimalRightShift(NSDecimal base, NSDecimal shift) {
    NSDecimalRound(&shift, &shift, 0, NSRoundDown);
    if (DDDecimalIsNegative(shift)) {
        DDDecimalNegate(&shift);
        return DDDecimalLeftShift(base, shift);
    }
    
    NSDecimal zero = DDDecimalZero();
    NSDecimal one = DDDecimalOne();
    NSDecimal two = DDDecimalTwo();
    
    while (NSDecimalCompare(&shift, &zero) == NSOrderedDescending) {
        NSDecimalDivide(&base, &base, &two, NSRoundBankers);
        NSDecimalSubtract(&shift, &shift, &one, NSRoundBankers);
    }
    if (NSDecimalCompare(&base, &one) == NSOrderedAscending) {
        return zero;
    }
    return base;
}

#pragma mark Trig Functions
NSDecimal DDDecimalSin(NSDecimal x) {
    // from: http://en.wikipedia.org/wiki/Cotangent#Series_definitions
	x = DDDecimalMod2Pi(x);
    
    NSDecimal final = x;
    BOOL shouldSubtract = YES;
    NSCalculationError e = NSCalculationNoError;
    for (NSInteger i = 3; i <= 45; i += 2) {
        NSDecimal numerator;
        e = NSDecimalPower(&numerator, &x, i, NSRoundBankers);
        if (IS_FATAL(e)) { break; }
        
        NSDecimal denominator = DDDecimalFactorial(DDDecimalFromInteger(i));
        
        NSDecimal term;
        e = NSDecimalDivide(&term, &numerator, &denominator, NSRoundBankers);
        if (IS_FATAL(e)) { break; }
        
        if (shouldSubtract) {
            NSDecimalSubtract(&final, &final, &term, NSRoundBankers);
        } else {
            NSDecimalAdd(&final, &final, &term, NSRoundBankers);
        }
        
        shouldSubtract = !shouldSubtract;
    }
    
    return final;
}

NSDecimal DDDecimalCos(NSDecimal x) {
    // from: http://en.wikipedia.org/wiki/Cotangent#Series_definitions
	x = DDDecimalMod2Pi(x);
    
    NSDecimal final = DDDecimalOne();
    BOOL shouldSubtract = YES;
    NSCalculationError e = NSCalculationNoError;
    for (NSInteger i = 2; i <= 45; i += 2) {
        NSDecimal numerator;
        e = NSDecimalPower(&numerator, &x, i, NSRoundBankers);
        if (IS_FATAL(e)) { break; }
        
        NSDecimal denominator = DDDecimalFactorial(DDDecimalFromInteger(i));
        
        NSDecimal term;
        e = NSDecimalDivide(&term, &numerator, &denominator, NSRoundBankers);
        if (IS_FATAL(e)) { break; }
        
        if (shouldSubtract) {
            NSDecimalSubtract(&final, &final, &term, NSRoundBankers);
        } else {
            NSDecimalAdd(&final, &final, &term, NSRoundBankers);
        }
        
        shouldSubtract = !shouldSubtract;
    }
    
    return final;
	
}

NSDecimal DDDecimalTan(NSDecimal x) {
    // tan(x) = sin(x) / cos(x)
    NSDecimal sin = DDDecimalSin(x);
    NSDecimal cos = DDDecimalCos(x);
    
    NSDecimal roundedCosine;
    NSDecimalRound(&roundedCosine, &cos, 34, NSRoundBankers);

    NSDecimal tan;
    NSDecimalDivide(&tan, &sin, &roundedCosine, NSRoundBankers);
    return tan;
}

NSDecimal DDDecimalCsc(NSDecimal d) {
    // csc(x) = 1/sin(x)
    return DDDecimalInverse(DDDecimalSin(d));
}

NSDecimal DDDecimalSec(NSDecimal d) {
    // sec(x) = 1/cos(x)
    return DDDecimalInverse(DDDecimalCos(d));
}

NSDecimal DDDecimalCot(NSDecimal d) {
    // cot(x) = 1/tan(x)
    return DDDecimalInverse(DDDecimalTan(d));
}


 NSDecimal DDDecimalAsin(NSDecimal x) {
     // Normal infinite series approximation fails here, due to the limits of NSDecimal precision
     // Instead, representing as arcsin(x) = arctan(x/sqrt(1-x^2))
     
     NSDecimal one = DDDecimalOne();
     
     if (NSDecimalCompare(&one, &x) == NSOrderedSame) {
         return DDDecimalPi_2();
     }
     
     NSDecimal absX = DDDecimalAbsoluteValue(x);
     
     NSComparisonResult comparisonBetweenAbsInputAndOne = NSDecimalCompare(&one, &absX);
     
     if (comparisonBetweenAbsInputAndOne == NSOrderedAscending) {
         return DDDecimalNAN();
     } else if (comparisonBetweenAbsInputAndOne == NSOrderedSame) {
         if (DDDecimalIsNegative(x)) {
             NSDecimal negativePi_2 = DDDecimalPi_2();
             DDDecimalNegate(&negativePi_2);
             return negativePi_2;
         }
         else {
             return DDDecimalPi_2();
         }
     }
         
     NSDecimal interiorOfRoot;
     NSDecimalMultiply(&interiorOfRoot, &x, &x, NSRoundBankers);
     NSDecimalSubtract(&interiorOfRoot, &one, &interiorOfRoot, NSRoundBankers);
     NSDecimal denominator = DDDecimalSqrt(interiorOfRoot);
     NSDecimal tangentValue;
     NSDecimalDivide(&tangentValue, &x, &denominator, NSRoundBankers);
     
     
     NSDecimal tangentResult = DDDecimalAtan(tangentValue);
     
     return tangentResult;
}

NSDecimal DDDecimalAcos(NSDecimal d) {
    // from: http://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Infinite_series
    NSDecimal halfPi = DDDecimalPi_2();
    d = DDDecimalAsin(d);
    NSDecimalSubtract(&d, &halfPi, &d, NSRoundBankers);
    return d;
}


NSDecimal DDDecimalAtan(NSDecimal x) {
    // from: http://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Infinite_series
//    NSLog(@"Input: %@", NSDecimalString(&x, [NSLocale currentLocale]));

    // The normal infinite series diverges if x > 1
    NSDecimal one = DDDecimalOne();
    NSDecimal absX = DDDecimalAbsoluteValue(x);

    NSDecimal z = x;
    if (NSDecimalCompare(&one, &absX) == NSOrderedAscending) {
        // y = x / (1 + sqrt(1+x^2))
        // Atan(x) = 2*Atan(y)
        // From: http://www.mathkb.com/Uwe/Forum.aspx/math/14680/faster-Taylor-s-series-of-Atan-x
        
        NSDecimal interiorOfRoot;
        NSDecimalMultiply(&interiorOfRoot, &x, &x, NSRoundBankers);
        NSDecimalAdd(&interiorOfRoot, &one, &interiorOfRoot, NSRoundBankers);
        NSDecimal denominator = DDDecimalSqrt(interiorOfRoot);
        NSDecimalAdd(&denominator, &one, &denominator, NSRoundBankers);
        NSDecimal y;
        NSDecimalDivide(&y, &x, &denominator, NSRoundBankers);
        
        NSDecimalMultiply(&interiorOfRoot, &y, &y, NSRoundBankers);
        NSDecimalAdd(&interiorOfRoot, &one, &interiorOfRoot, NSRoundBankers);
        denominator = DDDecimalSqrt(interiorOfRoot);
        NSDecimalAdd(&denominator, &one, &denominator, NSRoundBankers);
        NSDecimal y2;
        NSDecimalDivide(&y2, &y, &denominator, NSRoundBankers);
        
//        NSDecimal two = DDDecimalTwo();
        NSDecimal four = DDDecimalFromInteger(4);
        NSDecimal firstArctangent = DDDecimalAtan(y2);
        
        NSDecimalMultiply(&z, &four, &firstArctangent, NSRoundBankers);
    } else {
        BOOL shouldSubtract = YES;
        for (NSInteger n = 3; n < 150; n += 2) {
            NSDecimal numerator;
            if (NSDecimalPower(&numerator, &x, n, NSRoundBankers) == NSCalculationUnderflow)
            {
                numerator = DDDecimalZero();
                n = 150;
            }
            
            NSDecimal denominator = DDDecimalFromInteger(n);
            
            NSDecimal term;
            if (NSDecimalDivide(&term, &numerator, &denominator, NSRoundBankers) == NSCalculationUnderflow)
            {
                term = DDDecimalZero();
                n = 150;
            }
            
            if (shouldSubtract) {
                NSDecimalSubtract(&z, &z, &term, NSRoundBankers);
            } else {
                NSDecimalAdd(&z, &z, &term, NSRoundBankers);
            }
            
//            NSLog(@"%d, term: %@, numerator: %@, denominator: %@, z: %@", n, NSDecimalString(&term, [NSLocale currentLocale]), NSDecimalString(&numerator, [NSLocale currentLocale]), NSDecimalString(&denominator, [NSLocale currentLocale]), NSDecimalString(&z, [NSLocale currentLocale]));
            shouldSubtract = !shouldSubtract;
        }
    }

    return z;
}

/*
 
 Original 
 
NSDecimal DDDecimalAtan(NSDecimal x) {
    // from: http://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Infinite_series
    NSLog(@"Input: %@", NSDecimalString(&x, [NSLocale currentLocale]));
    
    NSDecimal z = x;
    BOOL shouldSubtract = YES;
    for (NSInteger n = 3; n < 150; n += 2) {
        NSDecimal numerator;
        if (NSDecimalPower(&numerator, &x, n, NSRoundBankers) == NSCalculationUnderflow)
        {
            numerator = DDDecimalZero();
        }
        
        NSDecimal denominator = DDDecimalFromInteger(n);
        
        NSDecimal term;
        NSDecimalDivide(&term, &numerator, &denominator, NSRoundBankers);

        if (shouldSubtract) {
            NSDecimalSubtract(&z, &z, &term, NSRoundBankers);
        } else {
            NSDecimalAdd(&z, &z, &term, NSRoundBankers);
        }

        NSLog(@"%d, term: %@, numerator: %@, denominator: %@, z: %@", n, NSDecimalString(&term, [NSLocale currentLocale]), NSDecimalString(&numerator, [NSLocale currentLocale]), NSDecimalString(&denominator, [NSLocale currentLocale]), NSDecimalString(&z, [NSLocale currentLocale]));
        shouldSubtract = !shouldSubtract;
    }
    
    return z;
}
*/

NSDecimal DDDecimalAcsc(NSDecimal d) {
    // from: http://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Infinite_series
    NSDecimal halfPi = DDDecimalPi_2();
    d = DDDecimalAsec(d);
    NSDecimalSubtract(&d, &halfPi, &d, NSRoundBankers);
    return d;
}

NSDecimal DDDecimalAsec(NSDecimal d) {
    // from: http://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Infinite_series
    d = DDDecimalInverse(d);
    return DDDecimalAcos(d);
}

NSDecimal DDDecimalAcot(NSDecimal d) {
    //from: http://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Infinite_series
    NSDecimal halfPi = DDDecimalPi_2();
    d = DDDecimalAtan(d);
    NSDecimalSubtract(&d, &halfPi, &d, NSRoundBankers);
    return d;    
}

NSDecimal DDDecimalSinh(NSDecimal x) {
    // from: http://en.wikipedia.org/wiki/Hyperbolic_sine#Taylor_series_expressions
    
    NSDecimal final = x;
    for (NSInteger i = 3; i <= 51; i += 2) {
        NSDecimal numerator;
        NSDecimalPower(&numerator, &x, i, NSRoundBankers);
        
        NSDecimal denominator = DDDecimalFactorial(DDDecimalFromInteger(i));
        
        NSDecimal term;
        NSDecimalDivide(&term, &numerator, &denominator, NSRoundBankers);
        
        NSDecimalAdd(&final, &final, &term, NSRoundBankers);
    }
    
    return final;
}

NSDecimal DDDecimalCosh(NSDecimal x) {
    // from: http://en.wikipedia.org/wiki/Hyperbolic_sine#Taylor_series_expressions
    
    NSDecimal final = DDDecimalOne();
    for (NSInteger i = 2; i <= 20; i += 2) {
        NSDecimal numerator;
        NSDecimalPower(&numerator, &x, i, NSRoundBankers);
        
        NSDecimal denominator = DDDecimalFactorial(DDDecimalFromInteger(i));
        
        NSDecimal term;
        NSDecimalDivide(&term, &numerator, &denominator, NSRoundBankers);
        
        NSDecimalAdd(&final, &final, &term, NSRoundBankers);
    }
    
    return final;
}

NSDecimal DDDecimalTanh(NSDecimal x) {
    // tanh(x) = sinh(x) / cosh(x)
    NSDecimal sinh = DDDecimalSinh(x);
    NSDecimal cosh = DDDecimalCosh(x);
    
    NSDecimal tanh;
    NSDecimalDivide(&tanh, &sinh, &cosh, NSRoundBankers);
    return tanh;
}

NSDecimal DDDecimalCsch(NSDecimal x) {
    // csch(x) = 1/sinh(x)
    return DDDecimalInverse(DDDecimalSinh(x));
}

NSDecimal DDDecimalSech(NSDecimal x) {
    // sech(x) = 1/cosh(x)
    return DDDecimalInverse(DDDecimalCosh(x));
}

NSDecimal DDDecimalCoth(NSDecimal x) {
    // coth(x) = 1/tanh(x)
    return DDDecimalInverse(DDDecimalTanh(x));
}

NSDecimal DDDecimalAsinh(NSDecimal x) {
    // from: http://en.wikipedia.org/wiki/Inverse_hyperbolic_function#Series_expansions
    NSDecimal one = DDDecimalOne();
    NSDecimal absX = DDDecimalAbsoluteValue(x);
    if (NSDecimalCompare(&one, &absX) == NSOrderedAscending) {
        return DDDecimalNAN();
    }
    
    BOOL shouldSubtract = YES;
    
    NSDecimal z = x;
    NSDecimal fraction = DDDecimalOne();
    for (NSInteger n = 1; n < 20;) {
        NSDecimal numerator = DDDecimalFromInteger(n);
        NSDecimalMultiply(&fraction, &fraction, &numerator, NSRoundBankers);
        NSDecimal denominator = DDDecimalFromInteger(++n);
        NSDecimalDivide(&fraction, &fraction, &denominator, NSRoundBankers);
        
        denominator = DDDecimalFromInteger(++n);
        NSDecimalPower(&numerator, &x, n, NSRoundBankers);
        NSDecimal zTerm;
        NSDecimalDivide(&zTerm, &numerator, &denominator, NSRoundBankers);
        
        NSDecimalMultiply(&zTerm, &fraction, &zTerm, NSRoundBankers);
        
        if (shouldSubtract) {
            NSDecimalSubtract(&z, &z, &zTerm, NSRoundBankers);
        } else {
            NSDecimalAdd(&z, &z, &zTerm, NSRoundBankers);
        }
        
        shouldSubtract = !shouldSubtract;
    }
    
    return z;
}

NSDecimal DDDecimalAcosh(NSDecimal x) {
    //TODO: arccosh
	double d = DDDoubleFromDecimal(x);
	d = acosh(d);
	return DDDecimalFromDouble(d);
}

NSDecimal DDDecimalAtanh(NSDecimal x) {
    // from: http://en.wikipedia.org/wiki/Inverse_hyperbolic_function#Series_expansions
    NSDecimal one = DDDecimalOne();
    NSDecimal absX = DDDecimalAbsoluteValue(x);
    if (NSDecimalCompare(&one, &absX) == NSOrderedAscending) {
        return DDDecimalNAN();
    }
    
    NSDecimal z = x;
    for (NSInteger n = 3; n < 20; n += 2) {
        NSDecimal numerator;
        NSDecimalPower(&numerator, &x, n, NSRoundBankers);
        NSDecimal denominator = DDDecimalFromInteger(n);
        
        NSDecimal term;
        NSDecimalDivide(&term, &numerator, &denominator, NSRoundBankers);
        NSDecimalAdd(&z, &z, &term, NSRoundBankers);
    }
    
    return z;
}

NSDecimal DDDecimalAcsch(NSDecimal d) {
    // from: http://en.wikipedia.org/wiki/Inverse_hyperbolic_function#Series_expansions
    d = DDDecimalInverse(d);
    return DDDecimalAsinh(d);
}

NSDecimal DDDecimalAsech(NSDecimal d) {
    // from: http://en.wikipedia.org/wiki/Inverse_hyperbolic_function#Series_expansions
    d = DDDecimalInverse(d);
    return DDDecimalAcosh(d);
}

NSDecimal DDDecimalAcoth(NSDecimal d) {
    // from: http://en.wikipedia.org/wiki/Inverse_hyperbolic_function#Series_expansions
    d = DDDecimalInverse(d);
    return DDDecimalAtanh(d);
}

