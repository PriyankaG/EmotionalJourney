//
//  EmotionsHistoryView.h
//  EmotionalJourney
//
//  Created by Administrator on 04/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "GraphView.h"

@class GraphView;

@interface EmotionsHistoryView : CPTGraphHostingView <CPTPlotDataSource> {
    CPTGraphHostingView *hostingView;
    CPTXYGraph          *graph;
    CPTPieChart         *pieChart;
    
    CPTGraphHostingView *hostingView2;
    CPTXYGraph          *graph2;
    CPTPieChart         *pieChart2;
}

//@property (nonatomic, retain)   CPTXYGraph      *graph;
@property (nonatomic, retain)   NSArray         *moodHistoryData;
@property (nonatomic, retain)   NSDate          *historyFromDate;
@property (nonatomic, retain)   NSDate          *historyToDate;
@property (nonatomic, retain)   IBOutlet        UILabel     *labelChartTitle;
@property (nonatomic, retain)   IBOutlet        UILabel     *labelChartPeriod;
@property (nonatomic, retain)  CPTXYGraph *lineChart;

-(void)         initializeGraph;
-(void)         initializePieChart;
-(void)         initializePieChartTwo;
-(void)         initializeBarChart;
-(void)         initializeLineChart;

-(NSString *)   getMoodRatioForMood: (int)moodType 
                            withHistory:(NSArray *)histData;
-(NSSet *)      getXLabelSetForLineChart: (CPTXYAxis *) xyAxis;
-(NSSet *)      getYLabelSetForLineChart: (CPTXYAxis *) xyAxis;
-(int)          getLineChartXRange;
-(UIImage *)    getGraphAsImage;
-(void)         setMoodHistoryData:(NSArray *)moodHistory;
-(void)         setMoodHistoryDataTwo:(NSArray *)moodHistory;
-(void)         setMoodSleepHistory:(NSArray *)moodSleepHist;
-(void)         setChartType: (int)type;
-(void)         setChartTitle: (NSString *) chartTitle;
-(void)         setHistoryFromDate: (NSDate *) date;
-(void)         setHistoryToDate  : (NSDate *) date;

@end
