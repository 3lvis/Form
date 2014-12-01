@import Foundation;

@interface NSString (HYPFormula)

- (NSString *)hyp_processValuesDictionary:(NSDictionary *)valuesDictionary;
- (id)hyp_runFormulaWithValuesDictionary:(NSDictionary *)valuesDictionary;

@end
