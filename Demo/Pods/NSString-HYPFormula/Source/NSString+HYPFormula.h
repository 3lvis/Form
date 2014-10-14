//
//  NSString+HYPFormula.h
//  HYPFormula
//
//  Created by Christoffer Winterkvist on 13/10/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (HYPFormula)

- (NSString *)processValues:(NSDictionary *)values;
- (id)runFormula;
- (id)runFormulaWithDictionary:(NSDictionary *)dictionary;

@end
