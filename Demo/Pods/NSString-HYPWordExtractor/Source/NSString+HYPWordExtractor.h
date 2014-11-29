//
//  NSString+HYPWordExtractor.h
//  NSString-HYPWordExtractor
//
//  Created by Christoffer Winterkvist on 13/10/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (HYPWordExtractor)

- (NSArray *)hyp_words;
- (NSSet *)hyp_uniqueWords;
- (NSArray *)hyp_variables;
- (NSSet *)hyp_uniqueVariables;
- (id)hyp_parseWords:(id)container withCharacterSet:(NSCharacterSet *)set;

@end
