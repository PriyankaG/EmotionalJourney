//
//  com_SecondViewController.m
//  EmotionalJourney
//
//  Created by Administrator on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "com_SecondViewController.h"
#import "DatabaseOperations.h"
#import "EmotionsHistoryView.h"
#import "EmotionsHistoryView.h"

// #define kFromDateButtonTitle @"I've chosen the 'FROM' date"
#define kChartTypePie               0
#define kChartTypeLine              1
#define kChartTypeBar               2
#define kChartTypePieCompare        3

#define kEmptyString                @""
#define kTableName                  @"emotionrrys"
#define kButtonPieEnabled           @"Button_PieChart_Red.png"
#define kButtonPieDisabled          @"Button_PieChart_Grey.png"
#define kButtonLineEnabled          @"Button_LineChart_Red.png"
#define kButtonLineDisabled         @"Button_LineChart_Grey.png"
#define kButtonFromDateEnabled      @"Button_FromDate_Red.png"
#define kButtonFromDateDisabled     @"Button_FromDate_Grey.png"
#define kButtonToDateEnabled        @"Button_ToDate_Red.png"
#define kButtonToDateDisabled       @"Button_ToDate_Grey.png"
#define kEmptyString                @""
#define kLabelSecondPeriod          @"Enter the second period, for comparison"


@implementation com_SecondViewController

@synthesize labelInputPrompt;
@synthesize labelFromDate;
@synthesize labelToDate;
@synthesize buttonFromDateChosen;
@synthesize buttonToDateChosen;
@synthesize buttonChartLine;
@synthesize buttonChartPie;
@synthesize buttonChartPieCompare;
@synthesize buttonChartCompareNow;
@synthesize datePicker;
@synthesize historyFromDate;
@synthesize historyToDate;
@synthesize historyFromDate2;
@synthesize historyToDate2;
@synthesize whichView;
@synthesize controllers;
@synthesize graphView;


static CGFloat const FONTSIZE = 14.0;
DatabaseOperations *dbOps;
EmotionsHistoryView *historyView;
NSArray *moodHistory;


/**
 * This method gets automatically triggered when the 'From' date is chosen
 */
-(IBAction) fromDateChosen: (id)sender {
            
    NSLog(@"User has chosen the 'From' date");
    [self.buttonFromDateChosen setEnabled:NO];
    
    // Get the chosen date value
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSDate *fromDate = [datePicker date];
    NSString *dateOrig = [dateFormatter stringFromDate:fromDate];
    NSLog(@"date original: %@", dateOrig);
    historyFromDate = fromDate;
    self.labelFromDate.hidden   = YES;
    
    [UIView transitionWithView:self.labelFromDate
                      duration:1.0
                       options:UIViewAnimationOptionCurveLinear
                    animations:^{ 
                        
                        // Set the 'from' date label to reflect the user's choice
                        labelFromDate.text = [dateFormatter stringFromDate:historyFromDate];
                        self.labelFromDate.hidden   = NO;
                    }  
                    completion:^(BOOL finished){
                        // Change the label at the top to ask the user to choose the 'To' date
                        [labelInputPrompt setText:@"Choose the 'To' Date now"];
    }];

    NSLog(@"'From' Date Chosen:%@", historyFromDate);
}



/**
 * This method gets automatically triggered when the 'To' date is chosen
 */
-(IBAction) toDateChosen:(id)sender {
        
        [self.buttonToDateChosen setEnabled:NO];
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        //[dateFormatter stringFromDate:[datePicker date]]);
        
        // Get the chosen date value
        historyToDate = [datePicker date];
        NSLog(@"'From': %@, 'To': %@", historyFromDate, historyToDate); 
        
        // TODO : build on this
        whichView = @"2";

        // Set the 'to' date label to reflect the user's choice
        labelToDate.text = [dateFormatter stringFromDate:historyToDate];
    [   labelInputPrompt setText:kEmptyString];

        self.buttonChartLine.enabled        = YES;
        self.buttonChartPie.enabled         = YES;
        self.buttonChartPieCompare.enabled  = YES;
    
        //[self.view addSubview:graphView];
        
        
        //        [UIView beginAnimations:nil context:nil];
        //        [UIView setAnimationDuration:1.5];
        //        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];    
        //        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        //        
        //        [self viewWillDisappear:YES];
        //        [historyView viewWillAppear:YES];
        //        self.view.hidden = YES;
        //        historyView.view.hidden = NO;
        //        [self viewDidDisappear:YES];
        //        [historyView viewDidAppear:YES];
        //        
        //        [UIView commitAnimations];
        
        //graphView.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        //graphView.modalPresentationStyle = UIModalPresentationFullScreen;
        
        // Curl up the view :)
        //UIView *container = self.view.window;
        //[historyView viewWillAppear:YES];
        //historyView.self.view.bounds = CGRectMake(0, 5, 200, 200);
        
        /*[UIView transitionWithView:container duration:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                [self.navigationController.view removeFromSuperview];
                [container addSubview: historyView.view];
            } 
            completion:^(BOOL finished) {
                [self presentModalViewController:historyView animated:NO];
            }];
         */
         
        //[self.navigationController popViewControllerAnimated:YES];

    
    //alpha fading
    //    modalController.view.alpha = 0.0;
    //    [self.view.window.rootViewController presentModalViewController:modalController animated:NO];
    //    [UIView animateWithDuration:0.5
    //                     animations:^{modalController.view.alpha = 1.0;}];
}



/**
 * This method gets automatically triggered when the user is in the process of choosing the date
 */
/*
-(IBAction) dateBeingChosen:(id)sender {
    
    //NSString *buttonTitle = kFromDateButtonTitle;
    //if ([[buttonDateChosen currentTitle] isEqualToString:buttonTitle]) { 
      
    if ( historyFromDate == nil ) {
        
        [self.buttonFromDateChosen setEnabled:YES];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        // Set the 'from' date label to reflect the user's choice
        labelFromDate.text = [dateFormatter stringFromDate:[datePicker date]];
     
        
    } else {
        
        [self.buttonToDateChosen setEnabled:YES];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        // Set the 'to' date label to reflect the user's choice
        labelToDate.text = [dateFormatter stringFromDate:[datePicker date]];
        
    }
}
*/


-(IBAction)buttonChartLinePressed:(id)sender {

    [self displayChart:kChartTypeLine];
}



-(IBAction)buttonChartPiePressed:(id)sender {
    
    [self displayChart:kChartTypePie];
}


-(IBAction) buttonChartPieComparePressed:(id)sender {

    [self displaySecondPeriodForComparison];
}



-(void) displayChart: (int) chartType {

    NSLog(@"displayChart: begin for charttype %d", chartType);
    
    if (chartType == kChartTypePie) {
        NSArray *moodHistory = 
                    [dbOps getDataBetweenDates:kTableName 
                                        withStartDate:historyFromDate 
                                          withEndDate:historyToDate];
        [self.graphView setMoodHistoryData:moodHistory];
        
        
    } else if (chartType == kChartTypeLine) {
        NSArray *moodSleepHistory = 
          [dbOps getMoodSleepBetweenDates:kTableName withStartDate:historyFromDate withEndDate:historyToDate];
        NSLog(@"displayChart: got the mood history and sleep data");
        [self.graphView setMoodSleepHistory:moodSleepHistory];
        
        
    } else if (chartType == kChartTypePieCompare) {
        
        NSLog(@"displayChart: kChartTypePieCompare");
        NSString *dateStrFromCompare   =   self.labelFromDate.text;
        NSString *dateStrToCompare     =   self.labelToDate.text;
        NSLog(@"Label from date: %@", dateStrFromCompare);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        NSDate *dateFromCompare = [dateFormatter dateFromString:dateStrFromCompare];
        NSDate *dateToCompare   = [dateFormatter dateFromString:dateStrToCompare];
        [self.graphView setHistoryFromDateForComparison:dateFromCompare];
        [self.graphView setHistoryToDateForComparison:dateToCompare];
        historyFromDate = historyFromDate2;
        historyToDate   = historyToDate2;
        
        // Set the moodHistory for the two charts
        NSArray *moodHistory1 = [dbOps getDataBetweenDates:kTableName 
                                     withStartDate:historyFromDate 
                                       withEndDate:historyToDate];
        [graphView setMoodHistoryData:moodHistory1];
        NSLog(@"displayChart: moodhistorydata 1 count: %d", [moodHistory1 count]);
        moodHistory1 = nil;
        NSArray *moodHistory2 = [dbOps getDataBetweenDates:kTableName 
                                    withStartDate:dateFromCompare 
                                      withEndDate:dateToCompare]; 
        [graphView setMoodHistoryDataForChartTwo:moodHistory2];
        NSLog(@"displayChart: moodhistorydata 2 count: %d", [moodHistory2 count]);
        moodHistory2 = nil;
        dateFromCompare = nil;
        dateToCompare   = nil;
        [self reinitializeInterfaceAfterComparison];
    }
    
    NSLog(@"from: %@", historyFromDate);
    NSLog(@"to  : %@", historyToDate);
    [self.graphView setGraphDateFrom:historyFromDate];
    [self.graphView setGraphDateTo:historyToDate];
    [self.graphView setChartType:chartType];
    
    NSLog(@"displayChart: setChartType:%d, setMoodHistoryData", chartType);
    [self presentModalViewController:self.graphView animated:YES];  
    NSLog(@"displayChart: end");
}



-(void) displaySecondPeriodForComparison {

    // Save the chosen dates for period 1
    historyFromDate2                    = historyFromDate;
    historyToDate2                      = historyToDate;
    
    self.datePicker.hidden              = YES;
    self.labelFromDate.hidden           = YES;
    self.labelToDate.hidden             = YES;
    self.buttonChartLine.hidden         = YES;
    self.buttonChartPie.hidden          = YES;
    self.buttonChartPieCompare.hidden   = YES;
    self.buttonFromDateChosen.enabled   = YES;
    self.buttonToDateChosen.enabled     = YES;
    self.labelFromDate.text             = kEmptyString;
    self.labelToDate.text               = kEmptyString;
    self.labelInputPrompt.text          = kLabelSecondPeriod;
  
    [UIView transitionWithView:self.view
            duration:1.0
            options:UIViewAnimationOptionTransitionCurlUp
            animations:^{ 
            
                self.datePicker.hidden              = NO;
                self.labelFromDate.hidden           = NO;
                self.labelToDate.hidden             = NO;
                self.buttonChartCompareNow.hidden   = NO;
            }  
            completion:Nil];
     
}


-(IBAction) buttonChartCompareNowPressed:(id)sender {
    [self displayChart:kChartTypePieCompare];
}



-(void) reinitializeInterfaceAfterComparison {
    
    self.buttonChartCompareNow.hidden   = YES;
    self.buttonChartLine.hidden         = NO;
    self.buttonChartPie.hidden          = NO;
    self.buttonChartPieCompare.hidden   = NO;
    self.labelFromDate.text             = kEmptyString;
    self.labelToDate.text               = kEmptyString;
}



/**
 * calculate the height for the message
 */
-(CGFloat) labelHeight:(NSString *) text {
    CGSize maximumLabelSize = CGSizeMake((56 * 3) - 25,9999);
    CGSize expectedLabelSize = [text sizeWithFont:[UIFont systemFontOfSize: FONTSIZE] 
                                constrainedToSize:maximumLabelSize 
                                    lineBreakMode:UILineBreakModeWordWrap]; 
    return expectedLabelSize.height;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"My Mood history";

    self.graphView = [[GraphView alloc] init];
    
    dbOps = [DatabaseOperations dbOpsSingleton];

    [dbOps createTableNamed:kTableName
                 withField1:@"user"
                 withField2:@"time"
                 withField3:@"text"
                 withField4:@"emoticon"
                 withField5:@"picture"
                 withField6:@"sleep"];
    
    //historyView = [[EmotionsHistoryView alloc] init];
    // historyView.view.self.bounds = self.view.bounds;
    //self.navigationItem.title = @"Just a title";
    //[self.navigationController pushViewController:historyView animated:YES];

    // Set the date-range that you can allow the user to select from
    // TODO : @production - change this min date value for date picker to something appropriate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *minDate = [formatter dateFromString:@"2012-04-14 06:00"];
    [datePicker setMinimumDate:minDate];
    NSDate *maxDate = [[NSDate alloc] init];
    [datePicker setMaximumDate:maxDate];
    CGRect rect = self.datePicker.frame;
    rect.origin = CGPointMake(5.0, 25.0);
    self.datePicker.frame = rect;
    datePicker.transform = CGAffineTransformMakeScale(0.7, 0.5);
    
    UIImage *pieEnabled     = [UIImage imageNamed:kButtonPieEnabled];
    UIImage *pieDisabled    = [UIImage imageNamed:kButtonPieDisabled];
    [self.buttonChartPie setImage:pieEnabled  forState:UIControlStateNormal];
    [self.buttonChartPie setImage:pieDisabled forState:UIControlStateDisabled];
    
    UIImage *lineEnabled = [UIImage imageNamed:kButtonLineEnabled];
    UIImage *lineDisabled = [UIImage imageNamed:kButtonLineDisabled];
    [self.buttonChartLine setImage:lineEnabled  forState:UIControlStateNormal];
    [self.buttonChartLine setImage:lineDisabled forState:UIControlStateDisabled];
    
    pieEnabled = nil; pieDisabled = nil;
    lineEnabled = nil; lineDisabled = nil;
    
    UIImage *buttonFromDateEnabled  = [UIImage imageNamed:kButtonFromDateEnabled];
    UIImage *buttonFromDateDisabled = [UIImage imageNamed:kButtonFromDateDisabled];
    UIImage *buttonToDateEnabled    = [UIImage imageNamed:kButtonToDateEnabled];
    UIImage *buttonToDateDisabled   = [UIImage imageNamed:kButtonToDateDisabled];
    [self.buttonFromDateChosen setImage:buttonFromDateEnabled forState:UIControlStateNormal];
    [self.buttonFromDateChosen setImage:buttonFromDateDisabled forState:UIControlStateDisabled];
    [self.buttonToDateChosen setImage:buttonToDateEnabled forState:UIControlStateNormal];
    [self.buttonToDateChosen setImage:buttonToDateDisabled forState:UIControlStateDisabled];
    
    self.buttonChartLine.hidden         = NO;
    self.buttonChartPie.hidden          = NO;
    self.buttonChartPieCompare.hidden   = NO;
    self.buttonChartPie.enabled         = NO;
    self.buttonChartLine.enabled        = NO;
    self.buttonChartPieCompare.enabled  = NO;
    self.buttonToDateChosen.enabled     = YES;
    self.buttonFromDateChosen.enabled   = YES;
    self.buttonChartCompareNow.hidden   = YES;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.controllers = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.buttonFromDateChosen  setEnabled:YES];
    [self.buttonToDateChosen    setEnabled:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
