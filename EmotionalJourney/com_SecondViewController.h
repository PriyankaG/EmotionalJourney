//
//  com_SecondViewController.h
//  EmotionalJourney
//
//  Created by Administrator on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmotionsHistoryView.h"
#import "GraphView.h"

@interface com_SecondViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *labelInputPrompt;
@property (nonatomic, retain) IBOutlet UILabel *labelFromDate;
@property (nonatomic, retain) IBOutlet UILabel *labelToDate;

@property (nonatomic, retain) IBOutlet UIButton *buttonFromDateChosen;
@property (nonatomic, retain) IBOutlet UIButton *buttonToDateChosen;
@property (nonatomic, retain) IBOutlet UIButton *buttonChartPie;
@property (nonatomic, retain) IBOutlet UIButton *buttonChartLine;
@property (nonatomic, retain) IBOutlet UIButton *buttonChartPieCompare;
@property (nonatomic, retain) IBOutlet UIButton *buttonChartCompareNow;

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) NSDate *historyFromDate;
@property (nonatomic, retain) NSDate *historyToDate;
@property (nonatomic, retain) NSDate *historyFromDate2;
@property (nonatomic, retain) NSDate *historyToDate2;
// TODO : Probably change this to a number? String might be an overdo.
@property (nonatomic, retain) NSString *whichView;
@property (strong, nonatomic) NSArray *controllers;
@property (nonatomic, retain) GraphView *graphView;

-(IBAction) fromDateChosen: (id)sender;
-(IBAction) toDateChosen: (id)sender;
-(IBAction) dateBeingChosen:(id)sender;
-(IBAction) buttonChartLinePressed:(id)sender;
-(IBAction) buttonChartPiePressed:(id)sender;
-(IBAction) buttonChartPieComparePressed:(id)sender;
-(IBAction) buttonChartCompareNowPressed:(id)sender;

-(void) displayChart: (int) chartType;
-(void) displaySecondPeriodForComparison;
-(void) displayComparisonPieCharts;
-(void) reinitializeInterfaceAfterComparison;

@end
