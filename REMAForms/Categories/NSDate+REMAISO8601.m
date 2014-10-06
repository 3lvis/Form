//
//  NSDate+REMAISO8601.m
//  Mine Ansatte
//
//  Created by Elvis Nunez on 15/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "NSDate+REMAISO8601.h"

@implementation NSDate (REMAISO8601)

+ (NSDate *)rema_dateFromISO8601String:(NSString *)iso8601
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

@end
