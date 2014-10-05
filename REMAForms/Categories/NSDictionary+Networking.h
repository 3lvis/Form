//
//  NSDictionary+Networking.h
//  Rema Drifts
//
//  Created by Elvis Nunez on 11/18/12.
//  Copyright (c) 2012 Hyper. All rights reserved.
//

@import Foundation;

@interface NSDictionary (HYPNetworking)

///------------------------
/// @name Accessing Objects
///------------------------

/**
 Returns the object for the specified key or `nil` if the value is `[NSNull null]`.

 @param key The key used to look up the object in the receiver.

 @return The object for the specified key or `nil` if the value is `[NSNull null]`.
 */
- (id)safeObjectForKey:(id)key;
- (NSDate *)dateFromISO8601String:(NSString *)iso8601;
- (NSDate *)dateObjectForKey:(id)key;
- (NSDate *)dateObjectForKey:(id)key usingFormat:(NSString *)format;
- (NSNumber *)boolObjectForKey:(id)key withTrueValue:(NSString *)trueValue;

- (void)setValueOrNull:(id)value forKey:(NSString *)key;

@end
