#import "DateUtils.h"

//Constants
#define SECOND 1
#define MINUTE (60 * SECOND)
#define HOUR (60 * MINUTE)
#define DAY (24 * HOUR)
#define MONTH (30 * DAY)

@implementation DateUtils

static NSDateFormatter *dateFormatter = nil;

// If it's currently 2013, then a date from 2013 would be
// July 7  4:15 pm
//
// and a date from 2012 would be
// June 5, 2012  2:10 pm

+ (NSString *)getMonthDayAndMaybeYearForDate:(NSDate *)date
{
    NSString *formatString = [self GT_isSameYearAsNow:date] ? @"MMMM d" : @"MMMM d, yyyy";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    return [formatter stringFromDate:date];
}

+ (NSString *)getMonthDayAndYearForDate:(NSDate *)date
{
    NSString *formatString = @"MMMM d, yyyy";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    return [formatter stringFromDate:date];
}

+ (NSString *)getTimeForDate:(NSDate *)date
{
    NSString *formatString = @"h:mm a";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setAMSymbol:@"am"];
    [formatter setPMSymbol:@"pm"];
    [formatter setDateFormat:formatString];
    return [formatter stringFromDate:date];
}

+ (BOOL)GT_isSameYearAsNow:(NSDate *)date
{
    return [[self getYearFromDate:date] isEqualToString:[self getYearFromDate:[NSDate date]]];
}

//Returns @"08.30.2011" for example
+ (NSString *)getDottedDateStringForDate:(NSDate *)date
{
    return [self GT_stringForGMTTimezoneDate:date withFormatString:@"MM.dd.yy"];
}

+ (NSString *)getMediumStyleStringForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)getDateFromMediumStyleString:(NSString *)dateAsString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return [dateFormatter dateFromString:dateAsString];
}

+ (NSString *)getLongStyleStringForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)shortTimeIntervalSinceData:(NSDate *)date
{
    return [self timeIntervalWithStartDate:date withEndDate:[NSDate date] shortVersion:YES];
}

+ (NSString *)readableTimeIntervalSinceDate:(NSDate *)date
{
    return [self timeIntervalWithStartDate:date withEndDate:[NSDate date] shortVersion:NO];
}

+ (NSString *)timeIntervalWithStartDate:(NSDate *)d1 withEndDate:(NSDate *)d2 shortVersion:(BOOL)shortVersion
{
    //Calculate the delta in seconds between the two dates
    NSTimeInterval delta = [d2 timeIntervalSinceDate:d1];
    
    if (delta < 1 * MINUTE) {
        return [self GT_secondsForDelta:delta shortVersion:shortVersion];
    }
    if (delta < 2 * MINUTE) {
        return [self GT_minutesForDelta:delta shortVersion:shortVersion];
    }
    if (delta < 45 * MINUTE) {
        return [self GT_minutesForDelta:delta shortVersion:shortVersion];
    }
    if (delta < 90 * MINUTE) {
        return [self GT_hoursForDelta:delta shortVersion:shortVersion];
    }
    if (delta < 24 * HOUR) {
        return [self GT_hoursForDelta:delta shortVersion:shortVersion];
    }
    if (delta < 48 * HOUR) {
        return @"yesterday";
    }
    if (delta < 30 * DAY) {
        int days = floor((double)delta/DAY);
        return [NSString stringWithFormat:@"%d days ago", days];
    }
    if (delta < 12 * MONTH) {
        return [self GT_monthsForDelta:delta shortVersion:shortVersion];
    }
    else {
        return [self GT_yearsForDelta:delta shortVersion:shortVersion];
    }
}

+ (NSString *)getYearFromDate:(NSDate *)date
{
    return [self GT_stringForGMTTimezoneDate:date withFormatString:@"yyyy"];
}

+ (NSString *)getMonthFromDate:(NSDate *)date
{
    return [self GT_stringForGMTTimezoneDate:date withFormatString:@"MM"];
}

+ (NSString *)getDayOfMonthFromDate:(NSDate *)date
{
    return [self GT_stringForGMTTimezoneDate:date withFormatString:@"dd"];
}

+ (NSDate *)getDateFromHyphenatedString:(NSString *)dateAsString
{
    NSDateFormatter *dateFormatter = [self dateFormatter];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:dateAsString];
}

+ (NSString *)getHyphenatedStringForDate:(NSDate *)date
{
    return [self GT_stringForGMTTimezoneDate:date withFormatString:@"yyyy-MM-dd"];
}

+ (NSDate *)parseYMDDateToGMTMidnightDate:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateObject = [dateFormatter dateFromString:dateString];
    return dateObject;
}

+ (NSDate *)getLocalDateForLongDateTimeString:(NSString *)longDateTimeString
{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [fomatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *localDate = nil;
    NSError *error = nil;
    if (![fomatter getObjectValue:&localDate forString:longDateTimeString range:nil error:&error]) {
        NSLog(@"Date '%@' could not be parsed: %@", longDateTimeString, error);
    }
    
    return localDate;
}

+ (NSDate *)getLocalDateIgnoringTimeZone:(NSDate *)aDate
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:aDate];
	[components setTimeZone:[NSTimeZone systemTimeZone]];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:1];
	NSDate *correctDate = [calendar dateFromComponents:components];
	
	return correctDate;
}

+ (NSDate *)getLocalDateFromTimezonelessDate:(NSDate *)tlDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:tlDate];
	[components setTimeZone:[NSTimeZone systemTimeZone]];
	NSDate *localDate = [calendar dateFromComponents:components];
    return localDate;
}

+ (NSDate *)getTimezonelessDateFromLocalDate:(NSDate *)lDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:lDate];
	[components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	NSDate *timezonelessDate = [calendar dateFromComponents:components];
    return timezonelessDate;
}

+ (NSDateFormatter *)dateFormatter
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    return dateFormatter;
}

+ (NSString *)GT_stringForGMTTimezoneDate:(NSDate *)date withFormatString:(NSString *)formatString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:formatString];
    return [formatter stringFromDate:date];
}

+ (NSString *)GT_stringForDate:(NSDate *)date withFormatString:(NSString *)formatString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    return [formatter stringFromDate:date];
}

+ (int)getDistanceInDates:(NSArray *)dates
{
    NSArray *range = [self getEarliestAndLatestDatesFromDates:dates];
    return[(NSDate *)range[1] timeIntervalSinceDate:(NSDate *)range[0]];
}

+ (NSArray *)getEarliestAndLatestDatesFromDates:(NSArray *)dates
{
    if ([dates count] == 0) {
        return nil;
    }
    
    NSDate *earliestDate = [dates objectAtIndex:0];
    NSDate *latestDate = [dates objectAtIndex:0];
    
    for (NSDate *date in dates) {
        if ([date timeIntervalSinceDate:earliestDate] < 0) {
            earliestDate = date;
        }
        else if ([date timeIntervalSinceDate:latestDate] > 0) {
            latestDate = date;
        }
    }
    
    return @[earliestDate, latestDate];
}

+ (NSString *)GT_secondsForDelta:(NSInteger)delta shortVersion:(BOOL)shortVersion
{
    NSString *output = @"";
    if (shortVersion) {
        output = delta == 1 ? @"one sec ago" : [NSString stringWithFormat:@"%d secs ago", (int)delta];
    } else {
        output = delta == 1 ? @"one second ago" : [NSString stringWithFormat:@"%d seconds ago", (int)delta];
    }
    return output;
}

+ (NSString *)GT_minutesForDelta:(NSInteger)delta shortVersion:(BOOL)shortVersion
{
    NSInteger minutes = floor((double)delta/MINUTE);
    
    NSString *output = @"";
    if (shortVersion) {
        output = (delta < 2 * MINUTE) ? @"a min ago" : [NSString stringWithFormat:@"%d mins ago", minutes];
    } else {
        output = (delta < 2 * MINUTE) ? @"a minute ago" : [NSString stringWithFormat:@"%d minutes ago", minutes];
    }
    return output;
}

+ (NSString *)GT_hoursForDelta:(NSInteger)delta shortVersion:(BOOL)shortVersion
{
    NSInteger hours = floor((double)delta/HOUR);
    
    NSString *output = @"";
    if (shortVersion) {
        output = (delta < 90 * MINUTE) ? @"an hr ago" : [NSString stringWithFormat:@"%d hrs ago", hours];
    } else {
        output = (delta < 90 * MINUTE) ? @"an hour ago" : [NSString stringWithFormat:@"%d hours ago", hours];
    }
    return output;
}

+ (NSString *)GT_monthsForDelta:(NSInteger)delta shortVersion:(BOOL)shortVersion
{
    NSInteger months = floor((double)delta/MONTH);
    
    NSString *output = @"";
    if (shortVersion) {
        output = (months <= 1) ? @"one mo ago" : [NSString stringWithFormat:@"%d mos ago", months];
    } else {
        output = (months <= 1) ? @"one month ago" : [NSString stringWithFormat:@"%d months ago", months];
    }
    return output;
}

+ (NSString *)GT_yearsForDelta:(NSInteger)delta shortVersion:(BOOL)shortVersion
{
    NSInteger years = floor((double)delta/MONTH/12.0);
    
    NSString *output = @"";
    if (shortVersion) {
        output = (years <= 1) ? @"one yr ago" : [NSString stringWithFormat:@"%d yrs ago", years];
    } else {
        output = (years <= 1) ? @"one year ago" : [NSString stringWithFormat:@"%d years ago", years];
    }
    return output;
}

@end
