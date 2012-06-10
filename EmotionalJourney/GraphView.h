//
//  GraphView.h
//  EmotionalJourney
//
//  Created by Administrator on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "EmotionsHistoryView.h"

@class EmotionsHistoryView;

@interface GraphView : UIViewController <MFMailComposeViewControllerDelegate, MFMailComposeViewControllerDelegate> 

    @property (strong, nonatomic) IBOutlet EmotionsHistoryView *emotionsHistoryView;
    @property (strong, nonatomic) IBOutlet EmotionsHistoryView *emotionsHistoryView1;
    @property (strong, nonatomic) IBOutlet EmotionsHistoryView *emotionsHistoryView2;

    //@property (strong, nonatomic) IBOutlet UIView *gView;
    @property (strong, nonatomic) IBOutlet  UIButton    *buttonBack;
    @property (strong, nonatomic)           NSDate      *graphDateFrom;
    @property (strong, nonatomic)           NSDate      *graphDateTo;

    -(void)         setChartType:           (int)       type;
    -(void)         setFromDate:            (NSDate *)  fromDate;
    -(void)         setHistoryFromDateForComparison:
                                            (NSDate *)  date;
    -(void)         setHistoryToDateForComparison:
                                            (NSDate *)  date;
    -(void)         setMoodHistoryData:     (NSArray *) moodHistory;
    -(void)         setMoodHistoryDataForChartTwo:
                                            (NSArray *)     moodHistory;
    -(void)         setMoodSleepHistory:    (NSArray *)     moodSleepData;
    -(void)         setHistoryFromDateForComparison:(NSDate *)date;
    -(void)         setHistoryToDateForComparison:(NSDate *)date;
    -(void)         showGraph;
    
    -(IBAction)     buttonBackPressed:              (id)    sender;
    -(IBAction)     buttonMailPressed:              (id)    sender;
    
@end

