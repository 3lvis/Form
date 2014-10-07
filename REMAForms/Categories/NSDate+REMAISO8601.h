//
//  NSDate+REMAISO8601.h

//
//  Created by Elvis Nunez on 15/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;

@interface NSDate (REMAISO8601)

+ (NSDate *)rema_dateFromISO8601String:(NSString *)iso8601;

@end
