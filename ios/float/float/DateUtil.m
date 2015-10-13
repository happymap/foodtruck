//
//  DateUtil.m
//  SACalendarExample
//
//  Created by Nop Shusang on 7/11/14.
//  Copyright (c) 2014 SyncoApp. All rights reserved.
//
//  Distributed under MIT License

#import "DateUtil.h"
#import "SACalendarConstants.h"

@implementation DateUtil

+(NSString*)getCurrentDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    [formatter setLocale:currentLocale];
    
    [formatter setCalendar:currentCalendar];
    [formatter setDateFormat:@"dd"];
    return [formatter stringFromDate:[NSDate date]];
}

+(NSString*)getCurrentMonth
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];

    NSLocale *currentLocale = [NSLocale currentLocale];
    [formatter setLocale:currentLocale];
    
    [formatter setCalendar:currentCalendar];
    [formatter setDateFormat:@"MM"];
    return [formatter stringFromDate:[NSDate date]];
}

+(NSString*)getCurrentYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];

    NSLocale *currentLocale = [NSLocale currentLocale];
    [formatter setLocale:currentLocale];
    
    [formatter setCalendar:currentCalendar];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}

+(NSString*)getCurrentDay
{
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];

    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    [theDateFormatter setCalendar:currentCalendar];
    
    [theDateFormatter setDateFormat:@"EEEE"];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    [theDateFormatter setLocale:currentLocale];
    
    NSString *weekDay =  [theDateFormatter stringFromDate:[NSDate date]];
    return weekDay;
}

+(NSString*)getCurrentDateString
{
    return [NSString stringWithFormat:@"%@/%@/%@",[self getCurrentMonth],[self getCurrentDate],[self getCurrentYear]];
}


+(NSString*)getMonthString:(int)index
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *months = [dateFormatter monthSymbols];
    return [months objectAtIndex:index-1];
}

+(NSString*)getDayString:(int)index
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *weekDays = [self getWeekdaysOrderedAccordingToLocaleWithShortNames:NO];
    return [weekDays objectAtIndex:index];
}


+(int)getDaysInMonth:(int)month year:(int)year
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [[NSDateComponents alloc] init];

    [components setMonth:month];
    [components setYear:year];

    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[calendar dateFromComponents:components]];
    return range.length;
}

+(NSString*)getDayOfDate:(int)date month:(int)month year:(int)year
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    [dateFormatter setCalendar:currentCalendar];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    [dateFormatter setLocale:currentLocale];
    
    NSDate *capturedStartDate = [dateFormatter dateFromString: [NSString stringWithFormat:@"%04i-%02i-%02i",year,month,date]];
    
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setLocale:currentLocale];
    
    [weekday setDateFormat: @"EEEE"];
    
    return [weekday stringFromDate:capturedStartDate];
}

+ (NSArray *)getWeekdaysOrderedAccordingToLocaleWithShortNames:(BOOL)shortNames
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *weekDays = shortNames ? [dateFormatter shortWeekdaySymbols] : [dateFormatter weekdaySymbols];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    int firstWeekdayIndex = (currentCalendar.firstWeekday - 1) % DAYS_IN_WEEK;
    NSMutableArray *orderedWeekdays = [weekDays mutableCopy];
    for (int i = 0; i < weekDays.count; i++) {
        int newIndex = (i - firstWeekdayIndex) % DAYS_IN_WEEK;
        newIndex = newIndex < 0 ? newIndex + DAYS_IN_WEEK : newIndex;
        [orderedWeekdays replaceObjectAtIndex:newIndex withObject:weekDays[i]];
    }
    return orderedWeekdays;
}

@end
