//
//  SACalendarConstants.h
//  SACalendar
//
//  User Interface constants. Customize your calendar here.
//
//  Created by Nop Shusang on 7/14/14.
//  Copyright (c) 2014 SyncoApp. All rights reserved.
//
//  Distributed under MIT License

#import <Foundation/Foundation.h>

/**
 *  Constants. Do not change
 */
#define MAX_MONTH 12
#define MIN_MONTH 1
#define MAX_CELL 42
#define DESELECT_ROW -1
#define DAYS_IN_WEEK 7
#define MAX_WEEK 6

/**
 *  Calendar's proportion
 */
#define calendarToHeaderRatio 7
#define headerFontRatio 0.4
#define pagingHeaderFontRatio 0.6

#define cellFontRatio 0.6
#define labelToCellRatio 0.7
#define circleToCellRatio 1

#define TITLE_MONTH_LABEL_HEIGHT_PAGING 25.0
#define TITLE_WEEKDAY_LABELS_HEIGHT 25.0

/**
 * Font sizes
 */
#define MONTH_NAME_FONT_SIZE 12.0
#define WEEK_DAY_FONT_SIZE 11.0

/**
 * Calendar colors
 */

// There are 3 layered views in SACalendar, the default UIView, the scroll view, and the collection view.
// Change their colors here

#define viewBackgroundColor [UIColor whiteColor]
#define scrollViewBackgroundColor [UIColor whiteColor]
#define calendarBackgroundColor [UIColor whiteColor]

#define headerTextColor [UIColor redColor]

#define titleBackgroundColor [UIColor colorWithRed:250./255. green:250./255 blue:250./255 alpha:1];


/**
 *  Cell properties
 */

// All cells
#define cellFont [UIFont systemFontOfSize:desiredFontSize * cellFontRatio]
#define cellBoldFont [UIFont boldSystemFontOfSize:desiredFontSize * cellFontRatio]

#define cellBackgroundColor [UIColor whiteColor]
#define cellTopLineColor [UIColor lightGrayColor]

#define dateTextColor [UIColor blackColor]

// Current date's cell
#define currentDateCircleColor [UIColor blackColor]
#define currentDateCircleLineWidth 2

// Selected date's cell
#define selectedDateCircleColor [UIColor blackColor]
#define selectedDateCircleLineWidth 1

/*
 * Loading states for infinite scroll view is to load the scroll view on the left (previous) first
 * then load the scroll view on the right (next) and finally load the scroll view in the middle (current)
 */
typedef enum {LOADSTATESTART = -1, LOADSTATEPREVIOUS = 0, LOADSTATENEXT, LOADSTATECURRENT} SALoadStates;

/*
 * Since we are reusing the scroll views, we need to define the three possible scroll views' positions
 * Assuming that the scroll views are called 0,1,2 then the three states are
 * 0 1 2, 2 0 1 and 1 2 0
 */
typedef enum {SCROLLSTATE_120 = 0, SCROLLSTATE_201 = 1, SCROLLSTATE_012} SAScrollStates;

/**
 *  Scroll view's scroll direction
 */
typedef enum {ScrollDirectionHorizontal = 0, ScrollDirectionVertical = 1} SAScrollDirection;

/**
* Calendar event types to be highlighted with different background images
* Event types can be renamed and added here
*
* Use the bit shift operator for further events (1 << 2, 1 << 3, and so on)
* and add them to SACalendarEventAll using the binary OR operator
* to be able to assign multiple events to the same date
*/
typedef enum {
    SACalendarEventType1 = 1 << 0,
    SACalendarEventType2 = 1 << 1,
    SACalendarEventAll = SACalendarEventType1 | SACalendarEventType2
} SACalendarEventType;