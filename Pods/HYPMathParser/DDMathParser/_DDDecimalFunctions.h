//
//  _DDDecimalFunctions.h
//  DDMathParser
//
//  Created by Dave DeLong on 12/24/10.
//  Copyright 2010 Home. All rights reserved.

#import <Foundation/Foundation.h>

extern NSDecimal DDDecimalNAN(void);
extern NSDecimal DDDecimalEpsilon(void);
extern NSDecimal DDDecimalNegativeOne(void);
extern NSDecimal DDDecimalZero(void);
extern NSDecimal DDDecimalOne(void);
extern NSDecimal DDDecimalTwo(void);

extern NSDecimal DDDecimalPhi(void);
extern NSDecimal DDDecimalPi(void);
extern NSDecimal DDDecimal2Pi(void);
extern NSDecimal DDDecimalPi_2(void);
extern NSDecimal DDDecimalPi_4(void);
extern NSDecimal DDDecimalSqrt2(void);
extern NSDecimal DDDecimalE(void);
extern NSDecimal DDDecimalLog2e(void);
extern NSDecimal DDDecimalLog10e(void);
extern NSDecimal DDDecimalLn2(void);
extern NSDecimal DDDecimalLn10(void);

#pragma mark Decimal Creation
extern NSDecimal DDDecimalFromInteger(NSInteger i);
extern NSDecimal DDDecimalFromDouble(double d);

#pragma mark Extraction

extern float DDFloatFromDecimal(NSDecimal d);
extern double DDDoubleFromDecimal(NSDecimal d);
extern NSUInteger DDUIntegerFromDecimal(NSDecimal d);

#pragma mark Utility Functions
extern BOOL DDDecimalIsInteger(NSDecimal d);
extern BOOL DDDecimalIsNegative(NSDecimal d);
extern BOOL DDDecimalIsProbablyEqual(NSDecimal a, NSDecimal b);

extern void DDDecimalNegate(NSDecimal *d);
extern void DDDecimalInvert(NSDecimal *d);

extern NSDecimal DDDecimalAdd(NSDecimal a, NSDecimal b);
extern NSDecimal DDDecimalSubtract(NSDecimal a, NSDecimal b);
extern NSDecimal DDDecimalMultiply(NSDecimal a, NSDecimal b);
extern NSDecimal DDDecimalDivide(NSDecimal a, NSDecimal b);

extern NSDecimal DDDecimalAverage2(NSDecimal a, NSDecimal b);
extern NSDecimal DDDecimalMod(NSDecimal a, NSDecimal b);
extern NSDecimal DDDecimalMod2Pi(NSDecimal a);
extern NSDecimal DDDecimalAbsoluteValue(NSDecimal a);
extern NSDecimal DDDecimalSqrt(NSDecimal d);
extern NSDecimal DDDecimalInverse(NSDecimal d);
extern NSDecimal DDDecimalFactorial(NSDecimal d);
extern NSDecimal DDDecimalPower(NSDecimal d, NSDecimal power);
extern NSDecimal DDDecimalNthRoot(NSDecimal d, NSDecimal root);

extern NSDecimal DDDecimalLeftShift(NSDecimal base, NSDecimal shift);
extern NSDecimal DDDecimalRightShift(NSDecimal base, NSDecimal shift);

#pragma mark Trig Functions
extern NSDecimal DDDecimalSin(NSDecimal d);
extern NSDecimal DDDecimalCos(NSDecimal d);
extern NSDecimal DDDecimalTan(NSDecimal d);

extern NSDecimal DDDecimalCsc(NSDecimal d);
extern NSDecimal DDDecimalSec(NSDecimal d);
extern NSDecimal DDDecimalCot(NSDecimal d);

extern NSDecimal DDDecimalAsin(NSDecimal d);
extern NSDecimal DDDecimalAcos(NSDecimal d);
extern NSDecimal DDDecimalAtan(NSDecimal d);

extern NSDecimal DDDecimalAcsc(NSDecimal d);
extern NSDecimal DDDecimalAsec(NSDecimal d);
extern NSDecimal DDDecimalAcot(NSDecimal d);

extern NSDecimal DDDecimalSinh(NSDecimal d);
extern NSDecimal DDDecimalCosh(NSDecimal d);
extern NSDecimal DDDecimalTanh(NSDecimal d);

extern NSDecimal DDDecimalCsch(NSDecimal d);
extern NSDecimal DDDecimalSech(NSDecimal d);
extern NSDecimal DDDecimalCoth(NSDecimal d);

extern NSDecimal DDDecimalAsinh(NSDecimal d);
extern NSDecimal DDDecimalAcosh(NSDecimal d);
extern NSDecimal DDDecimalAtanh(NSDecimal d);

extern NSDecimal DDDecimalAcsch(NSDecimal d);
extern NSDecimal DDDecimalAsech(NSDecimal d);
extern NSDecimal DDDecimalAcoth(NSDecimal d);
