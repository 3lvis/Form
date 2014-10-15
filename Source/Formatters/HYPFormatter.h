//
//  HYPFormatter.h
//
//  Created by Christoffer Winterkvist on 9/23/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFormField.h"

@interface HYPFormatter : NSObject

- (NSString *)formatString:(NSString *)string reverse:(BOOL)reverse;

@end
