//
//  NSDictionary+Networking.m
//  Rema Drifts
//
//  Created by Elvis Nunez on 11/18/12.
//  Copyright (c) 2012 Hyper. All rights reserved.
//

#import "NSDictionary+Networking.h"
@import Darwin.C.time;
#include <xlocale.h>

@implementation NSDictionary (HYPNetworking)

- (NSDate *)dateFromISO8601String:(NSString *)iso8601
{
    // Return nil if nil is given
    if (!iso8601 || [iso8601 isEqual:[NSNull null]]) {
        return nil;
    }

    // Parse number
    if ([iso8601 isKindOfClass:[NSNumber class]]) {
        return [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)iso8601 doubleValue]];
    }

    // Parse string
    else if ([iso8601 isKindOfClass:[NSString class]]) {
        if (!iso8601) {
            return nil;
        }

        const char *str = [iso8601 cStringUsingEncoding:NSUTF8StringEncoding];
        char newStr[25];

        struct tm tm;
        size_t len = strlen(str);
        if (len == 0) {
            return nil;
        }

        // UTC
        if (len == 20 && str[len - 1] == 'Z') {
            strncpy(newStr, str, len - 1);
            strncpy(newStr + len - 1, "+0000", 5);
        }

        //Milliseconds parsing
        else if (len == 24 && str[len - 1] == 'Z') {
            strncpy(newStr, str, len - 1);
            strncpy(newStr, str, len - 5);
            strncpy(newStr + len - 5, "+0000", 5);
        }

        // Timezone
        else if (len == 25 && str[22] == ':') {
            strncpy(newStr, str, 22);
            strncpy(newStr + 22, str + 23, 2);
        }

        // Poorly formatted timezone
        else {
            strncpy(newStr, str, len > 24 ? 24 : len);
        }

        // Add null terminator
        newStr[sizeof(newStr) - 1] = 0;

        if (strptime(newStr, "%FT%T%z", &tm) == NULL) {
            return nil;
        }

        time_t t;
        t = mktime(&tm);

        NSDate *returnedDate = [NSDate dateWithTimeIntervalSince1970:t];
        return returnedDate;
    }

    NSAssert1(NO, @"Failed to parse date: %@", iso8601);
    return nil;
}

- (id)safeObjectForKey:(id)key {
    if (!key) {
        return nil;
    }
	id value = [self valueForKeyPath:key];

    if (value != [NSNull null] && [value isKindOfClass:[NSString class]]) {
        NSString *someValue = value;
        if (someValue.length == 0) {
            return nil;
        }
    }

	if (value == [NSNull null]) {
		return nil;
	}
	return value;
}

- (NSDate *)dateObjectForKey:(id)key usingFormat:(NSString *)format
{
    NSString *dateString  = [self safeObjectForKey:key];

    if (format && dateString) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        NSDate *date = [dateFormatter dateFromString:dateString];
        if (date) {
            return date;
        }
    } else {
        if (dateString) {
            return [self dateFromISO8601String:dateString];
        }
    }

    return nil;
}

- (NSDate *)dateObjectForKey:(id)key
{
    return [self dateObjectForKey:key usingFormat:nil];
}

- (NSNumber *)boolObjectForKey:(id)key withTrueValue:(NSString *)trueValue
{
    NSString *fetchedValue = [self safeObjectForKey:key];

    if ([fetchedValue isEqualToString:trueValue]) {
        return @(YES);
    }

    return @(NO);
}

- (void)setValueOrNull:(id)value forKey:(NSString *)key
{
    if (value == nil) {
        value = [NSNull null];
    }
    [self setValue:value forKey:key];
}

@end
