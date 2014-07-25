@interface DateUtils : NSObject {
    
}

+ (NSString *)getMonthDayAndMaybeYearForDate:(NSDate *)date;
+ (NSString *)getMonthDayAndYearForDate:(NSDate *)date;
+ (NSString *)getTimeForDate:(NSDate *)date;
+ (NSString *)getDottedDateStringForDate:(NSDate *)date;
+ (NSString *)getMediumStyleStringForDate:(NSDate *)date;
+ (NSString *)getLongStyleStringForDate:(NSDate *)date;
+ (NSDate *)getDateFromMediumStyleString:(NSString *)dateAsString;
+ (NSString *)shortTimeIntervalSinceData:(NSDate *)date;
+ (NSString *)readableTimeIntervalSinceDate:(NSDate *)date;
+ (NSString *)timeIntervalWithStartDate:(NSDate *)d1 withEndDate:(NSDate *)d2 shortVersion:(BOOL)shortVersion;

+ (NSString *)getYearFromDate:(NSDate *)date;
+ (NSString *)getMonthFromDate:(NSDate *)date;
+ (NSString *)getDayOfMonthFromDate:(NSDate *)date;
+ (NSDate *)parseYMDDateToGMTMidnightDate:(NSString *)dateString;
+ (NSDate *)getLocalDateForLongDateTimeString:(NSString *)longDateTimeString;
+ (NSDate *)getLocalDateIgnoringTimeZone:(NSDate *)aDate;
+ (NSDate *)getLocalDateFromTimezonelessDate:(NSDate *)tlDate;
+ (NSDate *)getTimezonelessDateFromLocalDate:(NSDate *)lDate;

+ (NSDate *)getDateFromHyphenatedString:(NSString *)dateAsString;
+ (NSString *)getHyphenatedStringForDate:(NSDate *)date;

+ (int)getDistanceInDates:(NSArray *)dates;
+ (NSArray *)getEarliestAndLatestDatesFromDates:(NSArray *)dates;

@end