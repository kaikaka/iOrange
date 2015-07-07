//
//  DateUtil.m
//  ZHJCalendar
//
//  Created by huajian zhou on 12-4-12.
//  Copyright (c) 2012年 itotemstudio. All rights reserved.
//

#import "CalendarDateUtil.h"

@implementation CalendarDateUtil

+ (BOOL)isLeapYear:(NSInteger)year
{
    NSAssert(!(year < 1), @"invalid year number");
    BOOL leap = FALSE;
    if ((0 == (year % 400))) {
        leap = TRUE;
    }
    else if((0 == (year%4)) && (0 != (year % 100))) {
        leap = TRUE;
    }
    return leap;
}

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month
{
    return [CalendarDateUtil numberOfDaysInMonth:month year:[CalendarDateUtil getCurrentYear]];
}

+ (NSInteger)getCurrentYear
{
    time_t ct = time(NULL);
	struct tm *dt = localtime(&ct);
	int year = dt->tm_year + 1900;
    return year;
}

+ (NSInteger)getCurrentMonth
{
    time_t ct = time(NULL);
	struct tm *dt = localtime(&ct);
	int month = dt->tm_mon + 1;
    return month;
}

+ (NSInteger)getCurrentDay
{
    time_t ct = time(NULL);
	struct tm *dt = localtime(&ct);
	int day = dt->tm_mday;
    return day;
}

+ (NSInteger)getCurrentWeek
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = nil;

   NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday];
    
    /*
    //Week:
    1 －－星期天
    2－－星期一
    3－－星期二
    4－－星期三
    5－－星期四
    6－－星期五
    7－－星期六
     */
}

+ (NSInteger)getCurrentWeekWithDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *comps = nil;
     NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    comps = [calendar components:unitFlags fromDate:date];
    return [comps weekday];
}

+ (NSInteger)getMonthWithDate:(NSDate*)date
{
  unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    NSInteger month = comps.month;
    return month;
}

+ (NSInteger)getDayWithDate:(NSDate*)date
{
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    NSInteger day = comps.day;
    return day;
}

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger) year
{
    NSAssert(!(month < 1||month > 12), @"invalid month number");
    NSAssert(!(year < 1), @"invalid year number");
    month = month - 1;
    static int daysOfMonth[12] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    NSInteger days = daysOfMonth[month];
    /*
     * feb
     */
    if (month == 1) {
        if ([CalendarDateUtil isLeapYear:year]) {
            days = 29;
        }
        else {
            days = 28;
        }
    }
    return days;
}

+ (NSDate*)dateSinceNowWithInterval:(NSInteger)dayInterval
{
    return [NSDate dateWithTimeIntervalSinceNow:dayInterval*24*60*60];
}

+ (NSInteger)componentsDate:(NSDate *)date1 toDate:(NSDate *)date2
{
    NSCalendar *cal = [NSCalendar currentCalendar];
     unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:date1 toDate:date2 options:0];
    
    long sec = [d day]*24*60*60+[d hour]*3600+[d minute]*60+[d second]+2;
    NSLog(@"second = %ld",[d day]*24*60*60+[d hour]*3600+[d minute]*60+[d second]);
    return sec;
}
@end
