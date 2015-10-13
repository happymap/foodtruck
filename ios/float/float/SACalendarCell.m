//
//  SACalendarCell.m
//  SACalendarExample
//
//  Created by Nop Shusang on 7/12/14.
//  Copyright (c) 2014 SyncoApp. All rights reserved.
//
//  Distributed under MIT License

#import "SACalendarCell.h"
#import "SACalendarConstants.h"

@implementation SACalendarCell

/**
 *  Draw the basic components of the cell, including the top grey line, the red current date circle,
 *  the black selected circle and the date label. Customized the cell appearance by editing this function.
 *
 *  @param frame - size of the cell
 *
 *  @return initialized cell
 */
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupCalendarCell];
    }
    return self;
}

- (void)setupCalendarCell
{
    self.backgroundColor = cellBackgroundColor;

    self.topLineView = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, self.frame.size.width + 2, 0.5)];
    self.topLineView.backgroundColor = cellTopLineColor;

    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * labelToCellRatio)];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;

    CGRect labelFrame = self.dateLabel.frame;
    CGSize labelSize = labelFrame.size;

    CGPoint origin;
    int length;
    if (labelSize.width > labelSize.height) {
        origin.x = (labelSize.width - labelSize.height * circleToCellRatio) / 2;
        origin.y = (labelSize.height * (1 - circleToCellRatio)) / 2;
        length = labelSize.height * circleToCellRatio;
    }
    else{
        origin.x = (labelSize.width * (1 - circleToCellRatio)) / 2;
        origin.y = (labelSize.height - labelSize.width * circleToCellRatio) / 2;
        length = labelSize.width * circleToCellRatio;
    }

    self.highlightedView = [[UIImageView alloc] initWithFrame:CGRectMake(origin.x, origin.y, length, length)];
    self.highlightedView.contentMode = UIViewContentModeScaleToFill;
    self.highlightedView.layer.cornerRadius = length / 2;
    self.highlightedView.layer.shouldRasterize = YES;
    self.highlightedView.layer.masksToBounds = NO;
    self.highlightedView.clipsToBounds = YES;

    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, length, length)];
    self.circleView.layer.cornerRadius = length / 2;
    self.circleView.layer.borderColor = currentDateCircleColor.CGColor;
    self.circleView.layer.borderWidth = currentDateCircleLineWidth;
    self.circleView.backgroundColor = [UIColor clearColor];

    self.selectedView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, length, length)];
    self.selectedView.layer.cornerRadius = length / 2;
    self.selectedView.layer.borderColor = selectedDateCircleColor.CGColor;
    self.selectedView.layer.borderWidth = selectedDateCircleLineWidth;
    self.selectedView.backgroundColor = [UIColor clearColor];

    [self.viewForBaselineLayout addSubview:self.topLineView];
    [self.viewForBaselineLayout addSubview:self.highlightedView];
    [self.viewForBaselineLayout addSubview:self.circleView];
    [self.viewForBaselineLayout addSubview:self.selectedView];
    [self.viewForBaselineLayout addSubview:self.dateLabel];
    [self.contentView setOpaque:YES];
    [self.backgroundView setOpaque:YES];
    [self.viewForBaselineLayout setOpaque:YES];

    self.viewForBaselineLayout.layer.shouldRasterize = YES;
    self.viewForBaselineLayout.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
