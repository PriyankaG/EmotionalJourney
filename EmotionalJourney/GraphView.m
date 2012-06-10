//
//  GraphView.m
//  EmotionalJourney
//
//  Created by Administrator on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "Utility.h"

// TODO : @deploy : change this if the App name changes
#define     kMailSubject    @"Self-Aware App"
#define kChartTypePieCompare        3
#define kChartTypePieCompareTwo     4

@implementation GraphView

//@synthesize gView;
@synthesize buttonBack;
@synthesize emotionsHistoryView;
@synthesize graphDateFrom;
@synthesize graphDateTo;
@synthesize emotionsHistoryView1;
@synthesize emotionsHistoryView2;

NSDate  *histFromDateCompare;
NSDate  *histToDateCompare;
int chartType;


-(IBAction) buttonBackPressed: (id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


-(IBAction) buttonMailPressed: (id)sender {
    
    // TODO : @test : test the dave/delete draft feature for 'mail' in device
    
    NSLog(@"user wants to email the graph");
    
    UIImage *img = [self.emotionsHistoryView getGraphAsImage];
    NSData *graphAsPng = UIImagePNGRepresentation(img);
    MFMailComposeViewController *mailCtrlr = [[MFMailComposeViewController alloc] init];
    mailCtrlr.mailComposeDelegate = self;
    [mailCtrlr setSubject:kMailSubject];
    
    /*
     NSArray *toRecipients = [NSArray arrayWithObject:@"to@firm.com"];
    NSArray *ccRecipients = [NSArray arrayWithObject:@"cc@firm.com"];
    NSArray *bccRecipients = [NSArray arrayWithObject:@"bcc@firm.com"];
    [mailCtrlr setToRecipients:toRecipients];
    [mailCtrlr setCcRecipients:ccRecipients];
    [mailCtrlr setBccRecipients:bccRecipients];
    */
    
    [mailCtrlr addAttachmentData:graphAsPng mimeType:@"image/png" fileName:@"MyEmotionsGraph.png"];
    NSArray *array = [NSArray arrayWithObjects:@"My Emotions Graph :\n", 
                      @"From", 
                      [Utility getDateAsString:graphDateFrom], 
                      @"\nto", 
                      [Utility getDateAsString:graphDateTo],
                      @"\n\nThank You, \nPriyanka\nmail.priyanka@zoho.com",
                      nil];
    NSString *emailBody = [Utility concatenateStringsInArray:array]; 
    [mailCtrlr setMessageBody:emailBody isHTML:NO];
    [self presentModalViewController:mailCtrlr animated:YES];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    [self dismissModalViewControllerAnimated:YES];
    NSLog (@"mail finished");
}

-(void) setChartType:(int)type {
    chartType = type;
    NSLog(@"GraphView: setChartType to %d", chartType);

    if (chartType != kChartTypePieCompare) {
        [emotionsHistoryView setChartType:chartType];
        [emotionsHistoryView setHistoryFromDate:self.graphDateFrom];
        [emotionsHistoryView setHistoryToDate:self.graphDateTo];
        
    } else {
        
        // Initialize PieChart 1
        [emotionsHistoryView1 setChartType:chartType];
        [emotionsHistoryView1 setHistoryFromDate:self.graphDateFrom];
        [emotionsHistoryView1 setHistoryToDate:self.graphDateTo];
        NSLog(@"GraphView.setChartType: Setting chart1 from: %@ and to: %@", 
                        self.graphDateFrom, self.graphDateTo);
        
        // Initialize PieChart 2
        [emotionsHistoryView2 setChartType:chartType];
        [emotionsHistoryView2 setHistoryFromDate:histFromDateCompare];
        [emotionsHistoryView2 setHistoryToDate:histToDateCompare];
        NSLog(@"GraphView.setChartType: Setting chart2 from: %@ and to: %@",
                        histFromDateCompare, histToDateCompare);
    }
}


-(void) setFromDate: (NSDate *) fromDate {
    emotionsHistoryView.historyFromDate = fromDate;
}


-(void) setMoodHistoryData:(NSArray *)moodHistory {
    
    NSLog(@"GraphView: setMoodHistoryData count: %d", [moodHistory count]);
    
    if (chartType == kChartTypePieCompare) {
        [emotionsHistoryView1 setMoodHistoryData:moodHistory];
         
    } else {
        [emotionsHistoryView setMoodHistoryData:moodHistory];
    }
}


-(void) setMoodHistoryDataForChartTwo:(NSArray *)moodHistory {
    NSLog(@"GraphView.setMoodHistoryDataForChartTwo: moodhistory count: %d", [moodHistory count]);
    [emotionsHistoryView2 setMoodHistoryDataTwo:moodHistory];
}


-(void) setMoodSleepHistory:(NSArray *)moodSleepData {
    [emotionsHistoryView setMoodSleepHistory:moodSleepData];
    NSLog(@"GraphView-setMoodSleepHistory:count-%d",[moodSleepData count]);
}


-(void) setHistoryFromDateForComparison:(NSDate *)dateFrom {
    NSDate *inputDate   = dateFrom;
    histFromDateCompare = inputDate;
    NSLog(@"GraphView.setHistoryFromDateForComparison:%@", histFromDateCompare);
}


-(void) setHistoryToDateForComparison:(NSDate *)dateTo {
    NSDate *inputDate   = dateTo;
    histToDateCompare   = inputDate;
}


-(id) init {
    self = [super init];
    emotionsHistoryView     = [[EmotionsHistoryView alloc] init];
    emotionsHistoryView1    = [[EmotionsHistoryView alloc] init];
    emotionsHistoryView2    = [[EmotionsHistoryView alloc] init];
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    emotionsHistoryView     = [[EmotionsHistoryView alloc] init];
    emotionsHistoryView1    = [[EmotionsHistoryView alloc] init];
    emotionsHistoryView2    = [[EmotionsHistoryView alloc] init];
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*if (chartType != kChartTypePieCompare) {
        [emotionsHistoryView initializeGraph];
    
    } else {
        [emotionsHistoryView1 initializeGraph];
        [emotionsHistoryView2 initializeGraph];
    }
     */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    emotionsHistoryView     = nil;
    emotionsHistoryView1    = nil;
    emotionsHistoryView2    = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void) viewDidAppear:(BOOL)animated {
    
    [UIView transitionWithView:self.view
      duration:1.5
       options:UIViewAnimationOptionTransitionCurlUp
        animations:^{ 
        
        if (chartType == kChartTypePieCompare) {
            
            // Initialize PieChart 1
            [emotionsHistoryView1 setChartType:chartType];
            [emotionsHistoryView1 setHistoryFromDate:self.graphDateFrom];
            [emotionsHistoryView1 setHistoryToDate:self.graphDateTo];
            NSLog(@"GraphView.viewDidAppear:ChartType %d - Setting chart1 from: %@ and to: %@", 
                  chartType, self.graphDateFrom, self.graphDateTo);
            [emotionsHistoryView1 initializeGraph];
            emotionsHistoryView1    = nil;
            
            // Initialize PieChart 2
            [emotionsHistoryView2 setChartType:kChartTypePieCompareTwo];
            [emotionsHistoryView2 setHistoryFromDate:histFromDateCompare];
            [emotionsHistoryView2 setHistoryToDate:histToDateCompare];
            NSLog(@"GraphView.viewDidAppear: Setting chart2 from: %@ and to: %@",histFromDateCompare, histToDateCompare);
            [emotionsHistoryView2 initializeGraph];
            emotionsHistoryView2        = nil;
            emotionsHistoryView.hidden  = YES;
            emotionsHistoryView1.hidden = NO;
            emotionsHistoryView2.hidden = NO;
            
        } else {
            [emotionsHistoryView initializeGraph];
            emotionsHistoryView1.hidden = YES;
            emotionsHistoryView2.hidden = YES;
            emotionsHistoryView.hidden  = NO;
        }
    }  
    completion:NULL];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

