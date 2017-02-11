#import "NSDate+HYPString.h"

static NSString * const HYPDateDefaultFormat = @"yyyy-MM-dd";
static NSString * const HYPTimeDefaultFormat = @"HH:mm";
static NSString * const HYPTimeRangeFormat = @"%@ - %@";

@implementation NSDate (HYPString)

- (NSString *)hyp_timeString
{
    return [self hyp_dateStringWithFormat:HYPTimeDefaultFormat];
}

- (NSString *)hyp_dateString
{
    return [self hyp_dateStringWithFormat:HYPDateDefaultFormat];
}

- (NSString *)hyp_dateStringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = format;

    NSTimeZone *timezone = [NSTimeZone localTimeZone];
    NSInteger seconds = [timezone secondsFromGMTForDate:self];
    NSDate *localDate = [NSDate dateWithTimeInterval:seconds sinceDate:self];

    return [dateFormatter stringFromDate:localDate];
}

- (NSString *)hyp_timeRangeStringToEndDate:(NSDate *)endDate
{
    return [self hyp_dateRangeStringToEndDate:endDate withFormat:HYPTimeDefaultFormat];
}

- (NSString *)hyp_dateRangeStringToEndDate:(NSDate *)endDate
{
    return [self hyp_dateRangeStringToEndDate:endDate withFormat:HYPDateDefaultFormat];
}

- (NSString *)hyp_dateRangeStringToEndDate:(NSDate *)endDate withFormat:(NSString *)format
{
    return [NSString stringWithFormat:HYPTimeRangeFormat,
            [self hyp_dateStringWithFormat:format],
            [endDate hyp_dateStringWithFormat:format]];
}

@end
