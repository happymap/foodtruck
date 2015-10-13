//
//  SACalendar.m
//  SACalendarExample
//
//  Created by Nop Shusang on 7/10/14.
//  Copyright (c) 2014 SyncoApp. All rights reserved.
//
//  Distributed under MIT License

#import "SACalendar.h"
#import "SACalendarCell.h"
#import "DMLazyScrollView.h"
#import "DateUtil.h"

@interface SACalendar () <UICollectionViewDataSource, UICollectionViewDelegate>{
    DMLazyScrollView* scrollView;
    NSMutableDictionary *controllers;
    NSMutableDictionary *calendars;
    NSMutableDictionary *monthLabels;
    UILabel *currentMonthLabel;
    UIView *titleView;
    NSMutableDictionary *weekdayNameLabels;
    UIView *topLineView;
    
    int year, month;
    int prev_year, prev_month;
    int next_year, next_month;
    int current_date, current_month, current_year;
    
    int state, scroll_state;
    int previousIndex;
    BOOL scrollLeft;
    
    int firstDay;
    NSArray *daysInWeeks;
    CGSize cellSize;
    
    int selectedRow;
    float headerSize;

    BOOL pagingEnabled;

    float TITLE_MONTH_LABEL_HEIGHT;
    float TITLE_VIEW_HEIGHT;

    NSMutableDictionary *events;
    NSMutableDictionary *eventImages;
    NSMutableDictionary *eventTextColors;
}

@end

@implementation SACalendar

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame month:0 year:0 scrollDirection:ScrollDirectionVertical pagingEnabled:YES];
}

- (id)initWithFrame:(CGRect)frame month:(int)m year:(int)y
{
    return [self initWithFrame:frame month:m year:y scrollDirection:ScrollDirectionVertical pagingEnabled:YES];
}

-(id)initWithFrame:(CGRect)frame
   scrollDirection:(SAScrollDirection)direction
     pagingEnabled:(BOOL)paging
{
    return [self initWithFrame:frame month:0 year:0 scrollDirection:direction pagingEnabled:paging];
}

-(id)initWithFrame:(CGRect)frame
             month:(int)m
              year:(int)y
   scrollDirection:(SAScrollDirection)direction
     pagingEnabled:(BOOL)paging
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = viewBackgroundColor;

        current_date = [[DateUtil getCurrentDate] intValue];
        current_month = [[DateUtil getCurrentMonth] intValue];
        current_year = [[DateUtil getCurrentYear] intValue];

        month = m ? m : current_month;
        year = y ? y : current_year;

        pagingEnabled = paging;

        [self setupCalendarProperties];

        [self setupEventProperties];

        TITLE_MONTH_LABEL_HEIGHT = paging ? TITLE_MONTH_LABEL_HEIGHT_PAGING : 0;
        TITLE_VIEW_HEIGHT = TITLE_MONTH_LABEL_HEIGHT + TITLE_WEEKDAY_LABELS_HEIGHT;
        headerSize = pagingEnabled ? 0 : (self.frame.size.height - TITLE_VIEW_HEIGHT) / calendarToHeaderRatio;

        [self setupTitleView];
        [self layoutTitleView];

        [self setupScrollViewWithDirection:direction pagingEnabled:paging];

        [self addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"delegate"];
}

#pragma mark - PUBLIC METHODS

- (void)addEvent:(SACalendarEventType)eventType forDate:(NSDateComponents *)dateComponents
{
    events[dateComponents] = [NSNumber numberWithInt:([events[dateComponents] intValue] | eventType)];
}

- (void)setEvent:(SACalendarEventType)eventType forDate:(NSDateComponents *)dateComponents
{
    events[dateComponents] = [NSNumber numberWithInt:eventType];
}

- (void)highlightEventType:(SACalendarEventType)eventType withBackgroundImage:(UIImage *)backgroundImage withTextColor:(UIColor *)textColor
{
    eventImages[[NSNumber numberWithInt:eventType]] = backgroundImage;
    eventTextColors[[NSNumber numberWithInt:eventType]] = textColor;
}

- (void)highlightEventType:(SACalendarEventType)eventType withBackgroundColor:(UIColor *)backgroundColor withTextColor:(UIColor *)textColor
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self highlightEventType:eventType withBackgroundImage:image withTextColor:textColor];
}

- (void)highlightForEventType:(SACalendarEventType)eventType setEnabled:(BOOL)enabled
{
    if (enabled) {
        self.displayedEvents |= eventType;
    } else {
        self.displayedEvents &= ~eventType;
    }
    [self refreshCalendar];
}

- (void)resetEvents
{
    events = [NSMutableDictionary dictionary];
}

- (void)refreshCalendar
{
    for (NSString *key in calendars) {
        UICollectionView *cal = calendars[key];
        [cal reloadData];
    }
}

- (void)resetSelection
{
    selectedRow = DESELECT_ROW;
    [self refreshCalendar];
}

#pragma mark - SETUP

- (void)setupCalendarProperties
{
    controllers = [NSMutableDictionary dictionary];
    calendars = [NSMutableDictionary dictionary];
    monthLabels = [NSMutableDictionary dictionary];

    daysInWeeks = [DateUtil getWeekdaysOrderedAccordingToLocaleWithShortNames:NO];
}

- (void)setupEventProperties
{
    events = [NSMutableDictionary dictionary];
    eventImages = [NSMutableDictionary dictionary];
    eventTextColors = [NSMutableDictionary dictionary];
    self.displayedEvents = SACalendarEventAll;
}

/**
 * Set up title view displaying the current month plus the shortened weekday names
 */
- (void)setupTitleView
{
    // Parent title view
    titleView = [[UIView alloc] init];
    titleView.backgroundColor = titleBackgroundColor;
    [self addSubview:titleView];

    // Display of current month name (displayed only when paging is enabled)
    if (pagingEnabled) {
        NSString *string = @"STRING";
        CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        float pointsPerPixel = MONTH_NAME_FONT_SIZE / size.height;
        float desiredFontSize = TITLE_MONTH_LABEL_HEIGHT * pointsPerPixel;
        currentMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, TITLE_MONTH_LABEL_HEIGHT)];
        currentMonthLabel.font = [UIFont systemFontOfSize: desiredFontSize * pagingHeaderFontRatio];
        currentMonthLabel.textAlignment = NSTextAlignmentCenter;
        currentMonthLabel.textColor = headerTextColor;
        [titleView addSubview:currentMonthLabel];
    }

    // Short week names
    NSArray *shortWeekdayNames = [DateUtil getWeekdaysOrderedAccordingToLocaleWithShortNames:YES];
    float x = 0;
    float y = TITLE_MONTH_LABEL_HEIGHT;
    float width = self.frame.size.width / shortWeekdayNames.count;
    weekdayNameLabels = [NSMutableDictionary dictionary];
    int i = 0;
    for (NSString *day in shortWeekdayNames) {
        UILabel *weekdayLabel = [[UILabel alloc] init];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.font = [UIFont systemFontOfSize:WEEK_DAY_FONT_SIZE];
        weekdayLabel.textColor = [UIColor grayColor];
        weekdayLabel.text = day;
        [titleView addSubview:weekdayLabel];
        NSString *key = [NSString stringWithFormat:@"label%i", ++i];
        weekdayNameLabels[key] = weekdayLabel;
        x += width;
    }

    // Line view
    topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = cellTopLineColor;
    [titleView addSubview:topLineView];
}

/**
 * Set up scroll view containing months view controllers
 */
- (void)setupScrollViewWithDirection:(SAScrollDirection)direction pagingEnabled:(BOOL)paging
{
    state = LOADSTATESTART;
    scroll_state = SCROLLSTATE_120;
    selectedRow = DESELECT_ROW;

    CGRect rect = CGRectMake(0, TITLE_VIEW_HEIGHT, self.frame.size.width, self.frame.size.height - TITLE_VIEW_HEIGHT);
    scrollView = [[DMLazyScrollView alloc] initWithFrameAndDirection:rect direction:direction circularScroll:YES paging:paging];

    __weak __typeof(&*self)weakSelf = self;
    scrollView.dataSource = ^(NSUInteger index) {
        return [weakSelf controllerAtIndex:index];
    };
    scrollView.numberOfPages = 3;
    [self addSubview:scrollView];
}

#pragma mark - LAYOUT

/**
 * Layout title view to fill the complete width of the calendar with a fixed height
 */
- (void)layoutTitleView
{
    [titleView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view" : titleView}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[view(%.1f)]", TITLE_VIEW_HEIGHT] options:0 metrics:nil views:@{@"view" : titleView}]];
    [titleView.superview addConstraints:constraints];

    if (currentMonthLabel) {
        [currentMonthLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view" : currentMonthLabel}]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[view(%.1f)]", TITLE_MONTH_LABEL_HEIGHT] options:0 metrics:nil views:@{@"view" : currentMonthLabel}]];
        [currentMonthLabel.superview addConstraints:constraints];
    }

    [topLineView setTranslatesAutoresizingMaskIntoConstraints:NO];
    constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view" : topLineView}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[view(%.1f)]|", 0.5] options:0 metrics:nil views:@{@"view" : topLineView}]];
    [topLineView.superview addConstraints:constraints];

    constraints = [NSMutableArray array];
    for (NSString *key in weekdayNameLabels) {
        [weekdayNameLabels[key] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[label(%.1f)]|", TITLE_WEEKDAY_LABELS_HEIGHT] options:0 metrics:nil views:@{@"label" : weekdayNameLabels[key]}]];
    }
    UILabel *firstLabel = weekdayNameLabels[@"label1"];
    [firstLabel.superview addConstraints:constraints];
    [firstLabel.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label1][label2(==label1)][label3(==label1)][label4(==label1)][label5(==label1)][label6(==label1)][label7(==label1)]|" options:0 metrics:nil views:weekdayNameLabels]];
}

/**
 * Layout month label to be centered in the title view
 */
- (void)layoutMonthLabel:(UILabel *)monthLabel
{
    [monthLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view" : monthLabel}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[view(%.1f)]", headerSize] options:0 metrics:nil views:@{@"view" : monthLabel}]];
    [monthLabel.superview addConstraints:constraints];
}

/**
 * Layout calendar view to fill the space beneath the title view
 */
- (void)layoutCalendarView:(UIView *)calendar
{
    [calendar setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view" : calendar}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%.1f)-[view]|", headerSize] options:0 metrics:nil views:@{@"view" : calendar}]];
    [calendar.superview addConstraints:constraints];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendar:didDisplayCalendarForMonth:year:)]) {
        [self.delegate calendar:self didDisplayCalendarForMonth:month year:year];
    }
}

#pragma mark - SCROLL VIEW DELEGATE

- (UIViewController *)controllerAtIndex:(NSInteger)index
{
    if (index == previousIndex && state == LOADSTATEPREVIOUS) {
        // Handle right scroll
        if (++month > MAX_MONTH) {
            month = MIN_MONTH;
            year ++;
        }
        scrollLeft = NO;
        selectedRow = DESELECT_ROW;
    } else if (state == LOADSTATEPREVIOUS) {
        // Handle left scroll
        if (--month < MIN_MONTH) {
            month = MAX_MONTH;
            year--;
        }
        scrollLeft = YES;
        selectedRow = DESELECT_ROW;
    }
    
    previousIndex = (int)index;
    
    if (state  <= LOADSTATEPREVIOUS ) {
        state = LOADSTATENEXT;
    } else if (state == LOADSTATENEXT) {
        prev_month = month - 1;
        prev_year = year;
        if (prev_month < MIN_MONTH) {
            prev_month = MAX_MONTH;
            prev_year--;
        }
        state = LOADSTATECURRENT;
    } else {
        next_month = month + 1;
        next_year = year;
        if (next_month > MAX_MONTH) {
            next_month = MIN_MONTH;
            next_year++;
        }
        if (scrollLeft) {
            if (--scroll_state < SCROLLSTATE_120) {
                scroll_state = SCROLLSTATE_012;
            }
        } else {
            scroll_state++;
            if (scroll_state > SCROLLSTATE_012) {
                scroll_state = SCROLLSTATE_120;
            }
        }
        state = LOADSTATEPREVIOUS;

        if (pagingEnabled) {
            currentMonthLabel.text = [NSString stringWithFormat:@"%@ %04i",[DateUtil getMonthString:month],year];
        }
        if (nil != _delegate && [_delegate respondsToSelector:@selector(calendar:didDisplayCalendarForMonth:year:)]) {
            [_delegate calendar:self didDisplayCalendarForMonth:month year:year];
        }
    }

     // If it already exists, reload the calendar with new values
    UICollectionView *calendar = [calendars objectForKey:[NSString stringWithFormat:@"%li",(long)index]];
    [calendar reloadData];

    // Create a new view controller and add it to a dictionary for caching
    if (![controllers objectForKey:[NSString stringWithFormat:@"%li", (long)index]]) {
        UIViewController *controller = [[UIViewController alloc] init];
        controller.view.backgroundColor = scrollViewBackgroundColor;
        [controllers setObject:controller forKey:[NSString stringWithFormat:@"%li", (long) index]];

        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height - TITLE_VIEW_HEIGHT);
        UICollectionView *calendar = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:flowLayout];
        calendar.dataSource = self;
        calendar.delegate = self;
        calendar.scrollEnabled = NO;
        [calendar registerClass:[SACalendarCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [calendar setBackgroundColor:calendarBackgroundColor];
        calendar.tag = index;
        [controller.view addSubview:calendar];
        [self layoutCalendarView:calendar];
        [calendars setObject:calendar forKey:[NSString stringWithFormat:@"%li", (long)index]];

        if (!pagingEnabled) {
            NSString *string = @"STRING";
            CGSize size = [string sizeWithAttributes:
                    @{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
            float pointsPerPixel = 12.0 / size.height;
            float desiredFontSize = headerSize * pointsPerPixel;

            UILabel *monthLabel = [[UILabel alloc] init];
            monthLabel.font = [UIFont systemFontOfSize: desiredFontSize * headerFontRatio];
            monthLabel.textAlignment = NSTextAlignmentCenter;
            monthLabel.text = [NSString stringWithFormat:@"%@ %04i",[DateUtil getMonthString:month],year];
            monthLabel.textColor = headerTextColor;
            [controller.view addSubview:monthLabel];
            [self layoutMonthLabel:monthLabel];

            [monthLabels setObject:monthLabel forKey:[NSString stringWithFormat:@"%li", (long)index]];
        }
        return controller;
    }
    else {
        return [controllers objectForKey:[NSString stringWithFormat:@"%li", (long)index]];
    }
    
}

/**
 *  Get the month corresponding to the collection view
 *
 *  @param tag of the collection view
 *
 *  @return month that the collection view should load
 */
- (int)monthToLoad:(int)tag
{
    if (scroll_state == SCROLLSTATE_120) {
        if (tag == 0) return next_month;
        else if(tag == 1) return prev_month;
        else return month;
    }
    else if (scroll_state == SCROLLSTATE_201){
        if (tag == 0) return month;
        else if(tag == 1) return next_month;
        else return prev_month;
    }
    else{
        if (tag == 0) return prev_month;
        else if(tag == 1) return month;
        else return next_month;
    }
}

/**
 *  Get the year corresponding to the collection view
 *
 *  @param tag of the collection view
 *
 *  @return year that the collection view should load
 */
- (int)yearToLoad:(int)tag
{
    if (scroll_state == SCROLLSTATE_120) {
        if (tag == 0) return next_year;
        else if(tag == 1) return prev_year;
        else return year;
    }
    else if(scroll_state == SCROLLSTATE_201){
        if (tag == 0) return year;
        else if(tag == 1) return next_year;
        else return prev_year;
    }
    else{
        if (tag == 0) return prev_year;
        else if(tag == 1) return year;
        else return next_year;
    }
}

#pragma mark - COLLECTION VIEW DELEGATE

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int monthToLoad = [self monthToLoad:(int)collectionView.tag];
    int yearToLoad = [self yearToLoad:(int)collectionView.tag];
    
    firstDay = (int)[daysInWeeks indexOfObject:[DateUtil getDayOfDate:1 month:monthToLoad year:yearToLoad]];

    if (!pagingEnabled) {
        UILabel *monthLabel = [monthLabels objectForKey:[NSString stringWithFormat:@"%li",(long)collectionView.tag]];
        monthLabel.text = [NSString stringWithFormat:@"%@ %04i",[DateUtil getMonthString:monthToLoad],yearToLoad];
    }
    
    return MAX_CELL;
}

/**
 *  Controls what gets displayed in each cell
 *  Edit this function for customized calendar logic
 */

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SACalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

    int yearToLoad = [self yearToLoad:(int)collectionView.tag];
    int monthToLoad = [self monthToLoad:(int)collectionView.tag];
    int dayToLoad = indexPath.row - firstDay + 1;

    // Number of days in the month we are loading
    int daysInMonth = (int)[DateUtil getDaysInMonth:monthToLoad year:yearToLoad];
    
    // If cell is out of the month, do not show
    if (indexPath.row < firstDay || indexPath.row >= firstDay + daysInMonth) {
        cell.hidden = YES;
    } else {
        cell.hidden = NO;

        // Hide the top line for the days of the topmost week
        cell.topLineView.hidden = (indexPath.row < DAYS_IN_WEEK && pagingEnabled);

        // Get appropriate font size
        NSString *string = @"STRING";
        CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        float pointsPerPixel = 12.0 / size.height;
        float desiredFontSize = cellSize.height * pointsPerPixel;
        
        UIFont *font = cellFont;
        UIFont *boldFont = cellBoldFont;
        cell.dateLabel.textColor = dateTextColor;

        BOOL isToday = dayToLoad == current_date && monthToLoad == current_month && yearToLoad == current_year;
        cell.circleView.hidden = !isToday;
        cell.selectedView.hidden = indexPath.row != selectedRow;
        cell.dateLabel.font = indexPath.row == selectedRow || isToday ? boldFont : font;
        
        // Set the appropriate date for the cell
        cell.dateLabel.text = [NSString stringWithFormat:@"%i",(int)indexPath.row - firstDay + 1];

        // Display the appropriate highlight view if events were added to the current date
        cell.highlightedView.hidden = YES;
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setYear:yearToLoad];
        [components setMonth:monthToLoad];
        [components setDay:dayToLoad];
        [components setCalendar:[NSCalendar currentCalendar]];
        if (events[components]) {
            // Get the event status for the current date, taking into account which events are currently being displayed
            NSNumber *eventIndex = [NSNumber numberWithInt:([events[components] intValue] & self.displayedEvents)];
            if (eventImages[eventIndex]) {
                cell.highlightedView.image = eventImages[eventIndex];
                cell.dateLabel.textColor = eventTextColors[eventIndex];
                cell.highlightedView.hidden = NO;
            }
        }
    }
    return cell;
}

/*
 * Scale the collection view size to fit the frame
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    int width = self.bounds.size.width;
    int height = self.bounds.size.height - TITLE_VIEW_HEIGHT - headerSize;
    cellSize = CGSizeMake(width / DAYS_IN_WEEK, height / MAX_WEEK);
    return cellSize;
}

/*
 * Set all spaces between the cells to zero
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

/**
 * If the width of the calendar cannot be divided by 7, add offset to each side to fit the calendar in
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    int width = self.frame.size.width;
    int offset = (width % DAYS_IN_WEEK) / 4;
    // top, left, bottom, right
    return UIEdgeInsetsMake(0, offset, 0, offset);
}

/**
 * Only cells displaying a date are selectable
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int daysInMonth = (int)[DateUtil getDaysInMonth:[self monthToLoad:(int)collectionView.tag] year:[self yearToLoad:(int)collectionView.tag]];
    return (indexPath.row >= firstDay && indexPath.row < firstDay + daysInMonth);
}

/**
 * Update the UI and notify the delegate when a date was selected
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendar:didSelectDate:month:year:)]) {
        int dateSelected = (int)indexPath.row - firstDay + 1;
        [self.delegate calendar:self didSelectDate:dateSelected month:month year:year];
    }
    selectedRow = (int)indexPath.row;
    [collectionView reloadData];
}

@end
