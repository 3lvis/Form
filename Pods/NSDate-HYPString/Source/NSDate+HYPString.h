@import Foundation;

@interface NSDate (HYPString)

- (NSString *)hyp_timeString;

- (NSString *)hyp_dateString;

- (NSString *)hyp_dateStringWithFormat:(NSString *)format;

- (NSString *)hyp_timeRangeStringToEndDate:(NSDate *)endDate;

- (NSString *)hyp_dateRangeStringToEndDate:(NSDate *)endDate;

- (NSString *)hyp_dateRangeStringToEndDate:(NSDate *)endDate
                                withFormat:(NSString *)format;

@end
