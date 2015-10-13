//
//  SACalendar.h
//  SACalendarExample
//
//  Created by Nop Shusang on 7/10/14.
//  Copyright (c) 2014 SyncoApp. All rights reserved.
//
//  Distributed under MIT License

#import <UIKit/UIKit.h>
#import "SACalendarConstants.h"

@protocol SACalendarDelegate;
@interface SACalendar : UIView

@property (nonatomic, weak) id<SACalendarDelegate> delegate;

/**
 *  Bit mask containing the currently displayed event types
 */
@property (nonatomic) SACalendarEventType displayedEvents;

/**
 *  Default constructor, calendar will begin at current month
 *
 *  @param frame of the calendar
 *
 *  @return initialized calendar
 */
- (id)initWithFrame:(CGRect)frame;

/**
 *  Begin calendar at specific month and year
 *
 *  @param frame of the calendar
 *  @param m     month to begin calendar
 *  @param y     year to begin calendar
 *
 *  @return initialized calendar starting at mm/yyyy
 */
- (id)initWithFrame:(CGRect)frame month:(int)m year:(int)y;

/**
 *  Calendar will begin at current month, the user can also specify other properties
 *
 *  @param frame     of the calendar
 *  @param direction scroll direction, default to vertical
 *  @param paging    paging enabled, default to yes
 *
 *  @return initialized calendar
 */
-(id)initWithFrame:(CGRect)frame
   scrollDirection:(SAScrollDirection)direction
     pagingEnabled:(BOOL)paging;

/**
 *  The complete constructor
 *
 *  @param frame     of the calendar
 *  @param m         month to begin calendar
 *  @param y         year to begin calendar
 *  @param direction scroll direction, default to vertical
 *  @param paging    paging enabled, default to yes
 *
 *  @return initialized calendar
 */
-(id)initWithFrame:(CGRect)frame
             month:(int)m year:(int)y
   scrollDirection:(SAScrollDirection)direction
     pagingEnabled:(BOOL)paging;

/**
* Customize the display of a certain event type with a background image
*
*  @param eventType         event type as specified in SACalendarConstants.h
*  @param backgroundImage   background image to be displayed in the circle view of the date (will be scaled to fit)
*  @param textColor         textcolor for the date (should be readable on the background image
*
*/
- (void)highlightEventType:(SACalendarEventType)eventType withBackgroundImage:(UIImage *)backgroundImage withTextColor:(UIColor *)textColor;

/**
* Convenience method to customize the display of a certain event type using only colors
*
*  @param eventType         event type as specified in SACalendarConstants.h, can be combined via binary OR operator
*  @param backgroundColor   background color for the circle view of the date (will be scaled to fit)
*  @param textColor         textcolor for the date (should be readable on the background image
*
*/
- (void)highlightEventType:(SACalendarEventType)eventType withBackgroundColor:(UIColor *)backgroundColor withTextColor:(UIColor *)textColor;

/**
 * Enable/disable the display of a certain event type
 *
 * @param eventType     event type as specified in SACalendarConstants.h, can be combined via binary OR operator
 * @param enabled       YES to display the events, NO to hide the events of the given type
 */
- (void)highlightForEventType:(SACalendarEventType)eventType setEnabled:(BOOL)enabled;

/**
 * Add an event type to a date, previously added events will be kept
 *
 * @param eventType         event type as specified in SACalendarConstants.h, can be combined via binary OR operator
 * @param dateComponents    date to add the event to, specify as date components containing year, month, day, calendar
 */
- (void)addEvent:(SACalendarEventType)eventType forDate:(NSDateComponents *)dateComponents;

/**
 * Set an event type to a date, previously added events will be reset
 *
 * @param eventType         event type as specified in SACalendarConstants.h, can be combined via binary OR operator
 * @param dateComponents    date to set the event for, specify as date components containing year, month, day, calendar
 */
- (void)setEvent:(SACalendarEventType)eventType forDate:(NSDateComponents *)dateComponents;

/**
 * Reset all events saved for the calendar
 */
- (void)resetEvents;

/**
 * Force the calendar to refresh
 */
- (void)refreshCalendar;

/**
 * Reset the selection of the calendar
 */
- (void)resetSelection;

@end

@protocol SACalendarDelegate <NSObject>
@optional

/**
 *  A delegate function that gets called once the calendar displays a different month
 *  This is caused by swiping up or down (vertical scroll direction) / left or right (horizontal scroll direction)
 *
 *  @param calendar The calendar object that gets changed
 *  @param month    The new month displayed
 *  @param year     The new year displayed
 */
- (void)calendar:(SACalendar *)calendar didDisplayCalendarForMonth:(int)month year:(int)year;

/**
 *  This function gets called when a specific date is selected
 *
 *  @param calendar The calendar object that the selected date is on
 *  @param day      The date selected
 *  @param month    The month selected
 *  @param year     The year selected
 */
- (void)calendar:(SACalendar *)calendar didSelectDate:(int)day month:(int)month year:(int)year;

@end