//
//  NSDate+WYKit.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface NSDate (WYKit)

#pragma mark - 当前时间

/** 获获取当前客户端的逻辑日历 */
+ (NSCalendar *)currentCalendar;

/** 将日期转换为当前时区的日期 */
+ (NSDate *)convertDateToLocalTime:(NSDate *)forDate;

#pragma mark - 相对日期

/** 现在的日期 */
+ (NSDate *)dateNow;

/** 明天的日期 */
+ (NSDate *)dateTomorrow;

/** 昨天的日期 */
+ (NSDate *)dateYesterday;

/** 从现在起向后推几天的日期 */
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days;

/** 从现在起向前推几天的日期 */
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days;

/** 从现在起向后推几小时的日期 */
+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours;

/** 从现在起向前推几小时的日期 */
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours;

/** 从现在起向后推几分钟的日期 */
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes;

/** 从现在起向前推几分钟的日期 */
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes;


#pragma mark - 日期转字符串

/* 通过format格式将当前日期转换为String格式*/
- (NSString *)stringWithFormat:(NSString *)format;

/**
 *  通过系统自带的时间风格 来得到字符串
 *  @param dateStyle 日期格式 年月日
 *  @param timeStyle 时间格式 时分秒
 *  @return 得到最终的字符串
 */
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle
                        timeStyle:(NSDateFormatterStyle)timeStyle;

/** 5/5/15, 10:48 AM */
- (NSString *)shortString;

/** 10:48 AM */
- (NSString *)shortTimeString;

/** 5/5/15 */
- (NSString *)shortDateString;

/** May 5, 2015, 10:35:23 AM */
- (NSString *)mediumString;

/** 10:35:23 AM */
- (NSString *)mediumTimeString;

/** May 5, 2015 */
- (NSString *)mediumDateString;

/** May 5, 2015 at 10:35:23 AM GMT+8 */
- (NSString *)longString;

/** May 5, 2015 */
- (NSString *)longTimeString;

/** 10:35:23 AM GMT+8 */
- (NSString *)longDateString;


#pragma mark - 日期比较

/** 抛弃时间外 日期是否相等 精确到天的范围内 */
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate;

/** 日期是不是今天 */
- (BOOL)isToday;

/** 日期是不是明天 */
- (BOOL)isTomorrow;

/** 是不是昨天 */
- (BOOL)isYesterday;

/** 判断和指定日期是否是同一个星期内的 */
- (BOOL)isSameWeekAsDate:(NSDate *)aDate;

/** 判断是不是本周 */
- (BOOL)isThisWeek;

/** 判断是不是下周 */
- (BOOL)isNextWeek;

/** 判断是不是上周 */
- (BOOL)isLastWeek;

/** 判断是不是同一个月 */
- (BOOL)isSameMonthAsDate:(NSDate *)aDate;

/** 判断是不是本月 */
- (BOOL)isThisMonth;

/** 判断是不是上个月 */
- (BOOL)isLastMonth;

/** 判断是不是下个月 */
- (BOOL)isNextMonth;

/** 判断是不是同一年 */
- (BOOL)isSameYearAsDate:(NSDate *)aDate;

/** 判断是不是本年 */
- (BOOL)isThisYear;

/** 判断是不是下一年 */
- (BOOL)isNextYear;

/** 判断是不是上一年 */
- (BOOL)isLastYear;

/** 判断是不是比指定日期早 */
- (BOOL)isEarlierThanDate:(NSDate *)aDate;

/** 判断是不是比指定日期晚 */
- (BOOL)isLaterThanDate:(NSDate *)aDate;

/** 判断一个日期是不是在将来 */
- (BOOL)isInFuture;

/** 判断一个日期是不是在过去 */
- (BOOL)isInPast;

/** 判断一个指定的时间是否已经过了当前时间 */
+ (int)compareWithAnotherDay:(NSString *)anotherDay;

#pragma mark - 日期规则

/** 是不是周六日 */
- (BOOL)isTypicallyWeekend;

/** 是不是工作日 */
- (BOOL)isTypicallyWorkday;

#pragma mark - 调整日期

/** 指定日期后推几年得到的日期 */
- (NSDate *)dateByAddingYears:(NSInteger)dYears;

/** 指定日期前推几年得到的日期 */
- (NSDate *)dateBySubtractingYears:(NSInteger)dYears;

/** 指定日期后推几个月得到的日期 */
- (NSDate *)dateByAddingMonths:(NSInteger)dMonths;

/** 指定日期前推几个月得到的日期 */
- (NSDate *)dateBySubtractingMonths:(NSInteger)dMonths;

/** 指定日期后推几天得到的日期 */
- (NSDate *)dateByAddingDays:(NSInteger)dDays;

/** 指定日期前推几天的到的日期 */
- (NSDate *)dateBySubtractingDays:(NSInteger)dDays;

/** 指定日期后推几小时得到的日期 */
- (NSDate *)dateByAddingHours:(NSInteger)dHours;

/** 指定日期前推几小时得到的日期 */
- (NSDate *)dateBySubtractingHours:(NSInteger)dHours;

/** 指定日期后推几分钟得到的日期 */
- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes;

/** 指定日期前推几分钟得到的日期 */
- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes;

/** 指定日期和给的日期之间相差的时间 */
- (NSDateComponents *)componentsWithOffsetFromDate:(NSDate *)aDate;


#pragma mark - 极端例子

/** 得到指定日期这一天的开始日期 */
- (NSDate *)dateAtStartOfDay;

/** 得到指定日期这一天的结束日期 */
- (NSDate *)dateAtEndOfDay;


#pragma mark - 检索间隔

/** 得到当前日期在给定日期之后的分钟数 */
- (NSInteger)minutesAfterDate:(NSDate *)aDate;

/** 得到当前日期在给定日期之前的分钟数 */
- (NSInteger)minutesBeforeDate:(NSDate *)aDate;

/** 得到当前日期在给定日期之后的小时数 */
- (NSInteger)hoursAfterDate:(NSDate *)aDate;

/** 得到当前日期在给定日期之前的小时数 */
- (NSInteger)hoursBeforeDate:(NSDate *)aDate;

/** 得到当前日期在给定日期之后的天数 */
- (NSInteger)daysAfterDate:(NSDate *)aDate;

/** 得到当前日期在给定日期之后的天数 */
- (NSInteger)daysBeforeDate:(NSDate *)aDate;

/** 当前的日期和给定的日期之间相差的天数 */
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;


#pragma mark - 日期分解

/** 距离当前时间最近的小时 比如9：55 就是10：00 9：25就是9：00 */
- (NSInteger)nearestHour;

/** 当前日期的小时 */
- (NSInteger)hour;

/** 当前日期的分钟 */
- (NSInteger)minute;

/** 当前日期的秒 */
- (NSInteger)seconds;

/** 当前日期的几号 */
- (NSInteger)day;

/** 当前日期的几月 */
- (NSInteger)month;

/** 当前月的第几周 */
- (NSInteger)weekOfMonth;

/** 当前年的第几周 */
- (NSInteger)weekOfYear;

/** 当前日期所在周的第几天 */
- (NSInteger)weekday;

/** 当前日期所在年的第几季度 */
- (NSInteger)nthWeekday;

/** 当前日期的年 */
- (NSInteger)year;


@end
