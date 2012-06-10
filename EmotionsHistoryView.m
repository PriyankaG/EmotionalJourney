//
//  EmotionsHistoryView.m
//  EmotionalJourney
//
//  Created by Administrator on 04/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EmotionsHistoryView.h"
#import "Utility.h"
#import "CPTImageLayer.h"

#define kEmotionHappy 1
#define kEmotionOverjoyed 2
#define kEmotionRomantic 3
#define kEmotionSad 4
#define kEmotionDepressed 5
#define kEmotionAngry 6
#define kEmotionsCount  6

#define EMOTION_HAPPY               @"Happy"
#define EMOTION_OVERJOYED           @"TooHappy"
#define EMOTION_ROMANTIC            @"Romantic"
#define EMOTION_SAD                 @"Sorrow"
#define EMOTION_DEPRESSED           @"Depressed"
#define EMOTION_ANGRY               @"Angry"

#define ICON_EMOTICON_HAPPY         @"Emoticon_Red_Happy.png"
#define ICON_EMOTICON_OVERJOYED     @"Emoticon_Red_Overjoyed.png"
#define ICON_EMOTICON_ROMANTIC      @"EmoticonRomantic.png"
#define ICON_EMOTICON_SAD           @"EmoticonSad.png"
#define ICON_EMOTICON_DEPRESSED     @"EmoticonDepressed.png"
#define ICON_EMOTICON_ANGRY         @"EmoticonAngry.png"

// TODO : deploy : change this at deploy time
#define kPlotDateStart      @"2012-04-14 12:00"

// Names of the attributes of a note
#define kNoteAttrTime       @"time"
#define kNoteAttrSleep      @"sleep"
#define kNoteAttrEmoticon   @"emoticon"

#define kSleptWell                  1
#define kDidntSleepWell             0

#define kGraphPadLeft       85.0
#define kGraphPadRight      20.0
#define kGraphPadTop        30.0
#define kGraphPadBottom     70.0


// PIE CHART PARAMETERS

#define kPieChartTitle          @"Your Emotion Pattern"
#define kPieChartCompareTitle   @"Your Emotion Pattern : Comparison of two periods"

#define kPiePadLeft             85.0
#define kPiePadRight            20.0
#define kPiePadTop              30.0
#define kPiePadBottom           70.0

#define kChartTypePie           0
#define kChartTypeLine          1
#define kChartTypeBar           2
#define kChartTypePieCompare    3
#define kChartTypePieCompareTwo 4


// LINE CHART PARAMETERS
#define kLineChartTitle             @"Your Emotion & Sleep Pattern Over Time"
// Emotions vs Time Plot
#define kEmotionsPlotIdentifier     @"Plot of Emotions Over Time"
// Sleep vs Time Plot
#define kSleepPlotIdentifier        @"Plot of Sleep Over Time"
#define kPieChartIdentifier         @"Pie Chart"
#define kPieChartCompareIdentifier  @"Pie Chart 2"
#define kLineChartXAxisTitle        @""
#define kLineChartYAxisTitle        @"Emotions"



@implementation EmotionsHistoryView

//@synthesize graph;
@synthesize moodHistoryData;
@synthesize labelChartTitle;
@synthesize labelChartPeriod;
@synthesize historyFromDate;
@synthesize historyToDate;
@synthesize lineChart;


NSArray *moodSleepHistory;
NSArray *moodHistData;
NSArray *moodHistData2;
NSArray *lineChartPlotXLabel;
NSMutableArray *lineChartPlotTimeLabel;
NSDate  *histFromDate;
NSDate  *histToDate;
int     chartType = -1;



-(NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot {
            
    if ((chartType == kChartTypePie) || (chartType == kChartTypePieCompare)) {
        
        NSLog(@"EmotionsHistoryView: numberOfRecordsForPlot-kChartTypePie,kChartTypePieCompare: MoodHistory count: %d", 
                                (int)[moodHistData count]);
        return [moodHistData count]; 
        
        
    } else if (chartType == kChartTypeLine) {
        
        NSLog(@"numberOfRecordsForPlot-kChartTypeLine: %d", [moodSleepHistory count]);
        return [moodSleepHistory count];
        
        
    } else if (chartType == kChartTypePieCompareTwo) {
        
        NSLog(@"EmotionsHistoryView.numberOfRecordsForPlot.kChartTypePieCompareTwo: MoodHistory Count %d", 
                            (int)[moodHistData2 count]);
        return [moodHistData2 count];
    }

    return 0;
}


-(NSNumber *) numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    if ((chartType == kChartTypePie) || 
        (chartType == kChartTypePieCompare) || 
        (chartType == kChartTypePieCompareTwo)) {
        
        
        NSArray *histData = moodHistData;
        if (plot.identifier == kPieChartCompareIdentifier) {
            histData    = moodHistData2;
        }
        
        NSString *moodRatio = [self getMoodRatioForMood:(int)index
                                            withHistory:histData];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *ratioNumber = [formatter numberFromString:moodRatio];
        NSLog(@"EmotionsHistoryView: numberForPlot identifier %@: returning %@ for index %d", 
              plot.identifier, ratioNumber, (int)index);
        return ratioNumber;

        
    } else if (chartType == kChartTypeLine) {
    
        NSDictionary *dict = [moodSleepHistory objectAtIndex:index];
        
        if (fieldEnum == CPTScatterPlotFieldX) {
            
            NSString *str = [dict objectForKey:kNoteAttrTime];
            // NSDate *thisDate = [Utility getDateFromString:str withFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
            double numOfDays = [Utility numOfDaysSinceTimeInterval:[str intValue]];
            NSLog(@"num days before ceil: %f", numOfDays);
            numOfDays = ceil(numOfDays);
            NSLog(@"num days after ceil: %f", numOfDays);
            /*
             @chart
            numOfDays = numOfDays * 6.0;
            if (index == 0) {
                numOfDays = 3.0;
            }
            */
            
            NSLog(@"numberForPlot.kChartTypeLine.CPTScatterPlotFieldX - for index %d : %f", index, numOfDays);
            return [NSNumber numberWithDouble:numOfDays];

        
        } else if (fieldEnum == CPTScatterPlotFieldY) {
 
            if (plot.identifier == kEmotionsPlotIdentifier) {
                
                NSString *str = [dict objectForKey:kNoteAttrEmoticon];
                NSLog(@"numberForPlot.kChartTypeLine - returning emoticon val %d for index %d", [str intValue], index);
                return [NSNumber numberWithInt:([str intValue]+2)];
                
                
            } else if (plot.identifier == kSleepPlotIdentifier) {
                
                NSString *str = [dict objectForKey:kNoteAttrSleep];
                NSLog(@"numberForPlot.kChartTypeLine - returning sleep val %d for index %d", [str intValue], index);
                return [NSNumber numberWithInt:([str intValue]+1)];
            }
        }
    }
    return 0;
}



-(CPTLayer *) dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
   
    // NSLog(@"EmotionsHistoryView: dataLabelForPlot");
    static CPTMutableTextStyle *textStyle = nil;
    NSString *currentlabel;
    
    if (chartType == kChartTypeLine) {
      
        currentlabel = [lineChartPlotXLabel objectAtIndex:index];
        NSLog(@"dataLabelForPlot %d : %@", index, [lineChartPlotXLabel objectAtIndex:index]);
        textStyle       = [[CPTMutableTextStyle alloc] init];
        textStyle.color = [CPTColor brownColor];
        textStyle.fontSize  = 10.0f;
        textStyle.fontName = @"Helevetica";
        CPTLayer *layer = [[CPTLayer alloc] 
                            initWithFrame:CGRectMake(10.0, 0.0, 70.0, 20.0)];
        CPTTextLayer *newLayer = nil;
        newLayer = [[CPTTextLayer alloc] initWithText:currentlabel style:textStyle];
        [layer addSublayer:newLayer];
        return layer;
        
        
    } else if ((chartType == kChartTypePie) || 
               (chartType == kChartTypePieCompare) || 
               (chartType == kChartTypePieCompareTwo)) {
        
        NSString *moodRatio;
        NSString *moodName;
        int indexInt = (int)index;
        NSArray *histData = moodHistData;
        if (plot.identifier == kPieChartCompareIdentifier) {
            histData = moodHistData2;
            NSLog(@"Setting histdata to moodHistData2 with count %d", 
                  [histData count]);
        }
        NSLog(@"dataLabelForPlot.pie %@ for mood type %d",
                                            plot.identifier, indexInt);
        
        moodRatio = [self getMoodRatioForMood:indexInt
                                  withHistory:histData];
        if ([moodRatio isEqualToString:@"0.00"]) {
            NSLog(@"moodratio is 0!!!!");
            return nil;
        } 
        
        switch (indexInt) {
            case (kEmotionHappy-1): {
                moodName    = EMOTION_HAPPY;
                break;
            }
            case (kEmotionOverjoyed-1): {
                moodName    = EMOTION_OVERJOYED;
                break;
            }
            case (kEmotionRomantic-1): {
                moodName    = EMOTION_ROMANTIC;
                break;
            }
            case (kEmotionSad-1): {
                moodName    = EMOTION_SAD; 
                break;
            }
            case (kEmotionDepressed-1): {
                moodName    = EMOTION_DEPRESSED;
                break;
            }
            case (kEmotionAngry-1): {
                moodName    = EMOTION_ANGRY;
                break;
            }
            default: {
                // do nothing
            }
        }
        
        NSArray *stringArray = [[NSArray alloc] initWithObjects:moodName, moodRatio, @"%", nil];
        currentlabel = [Utility concatenateStringsInArray:stringArray];
        
        NSLog(@"Mood ratio for mood type %d is %@", indexInt, currentlabel);
        
        if(!textStyle) {
            textStyle = [[CPTMutableTextStyle alloc] init];
            textStyle.color = [CPTColor grayColor]; 
            textStyle.fontSize  = 10.0f;
        }
        CPTLayer *layer = [[CPTLayer alloc] 
                           initWithFrame:CGRectMake(0.0, 0.0, 90.0, 20.0)];
        CPTTextLayer *newLayer = nil;
        newLayer = [[CPTTextLayer alloc] 
                    initWithText:currentlabel style:textStyle];
        [layer addSublayer:newLayer];
        return layer;
    }
    
    /* if (indexInt == 6) {
        UIImage *pie = pieChart.imageOfLayer;
        // For pdf -> NSData *pdfRepresentation = pieChart.dataForPDFRepresentationOfLayer;
        NSData *newPNG=UIImagePNGRepresentation(pie);
        NSString *filePath=[NSString stringWithFormat:@"%@/graph.png", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
        if([newPNG writeToFile:filePath atomically:YES]) {
            NSLog(@"Created new file successfully");
        }
    }
    */
    return nil;
}



-(CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)index {
     
    if (plot.identifier == kEmotionsPlotIdentifier) {
        
        CPTPlotSymbol *plotSymbol;
        CPTColor *symbolColor;
        NSDictionary *dict = [moodSleepHistory objectAtIndex:index];
        NSString *str = [dict objectForKey:kNoteAttrEmoticon];
        NSLog(@"symbolForScatterPlot.kChartTypeLine - emoticon val %d for index %d", [str intValue], index);
        int emoticon = [str intValue];
        
        switch (emoticon) {
            
            case kEmotionHappy: {
                plotSymbol      = [CPTPlotSymbol ellipsePlotSymbol];
                symbolColor     = [CPTColor colorWithComponentRed:255.0/255.0 green:105.0/255.0 blue:180.0/225.0 alpha:1.0];
                break;
            }
            case kEmotionOverjoyed: {
                plotSymbol      = [CPTPlotSymbol diamondPlotSymbol];
                symbolColor     = [CPTColor colorWithComponentRed:100.0/255.0 green:149.0/255.0 blue:237.0/255.0 alpha:1.0];
                break;
            }
            case kEmotionRomantic: {
                plotSymbol      = [CPTPlotSymbol rectanglePlotSymbol];
                symbolColor     = [CPTColor colorWithComponentRed:205.0/255.0 green:92.0/255.0 blue:92.0/255.0 alpha:1.0];
                break;
            }
            case kEmotionSad: {
                plotSymbol      = [CPTPlotSymbol pentagonPlotSymbol];
                symbolColor     = [CPTColor colorWithComponentRed:128.0/255.0 green:128.0/255.0 blue:0.0 alpha:1.0];
                break;
            }
            case kEmotionDepressed: {
                symbolColor     = [CPTColor colorWithComponentRed:160.0/255.0 green:82.0/255.0 blue:45.0/255.0 alpha:1.0];
                plotSymbol      = [CPTPlotSymbol trianglePlotSymbol];
                break;
            }
            case kEmotionAngry: {
                plotSymbol      = [CPTPlotSymbol starPlotSymbol];
                symbolColor     = [CPTColor colorWithComponentRed:219.0/255.0 green:112.0/255.0 blue:147.0/255.0 alpha:1.0];
                break;
            }
            default:
                break;
        }
        
        plotSymbol.fill          = [CPTFill fillWithColor:symbolColor];
        plotSymbol.size          = CGSizeMake(10.0, 10.0);
        return plotSymbol;
        
        
    } else if (plot.identifier == kSleepPlotIdentifier) {
        
        CPTPlotSymbol *plotSymbol;
        CPTColor *symbolColor;
        NSDictionary *dict = [moodSleepHistory objectAtIndex:index];
        NSString *str = [dict objectForKey:kNoteAttrSleep];
        NSLog(@"symbolForScatterPlot.kChartTypeLine - sleep val %d for index %d", [str intValue], index);
        int sleep = [str intValue];
        
        switch (sleep) {
            case kSleptWell: {
                plotSymbol      = [CPTPlotSymbol rectanglePlotSymbol];
                symbolColor     = [CPTColor colorWithComponentRed:32.0/255.0 green:178.0/255.0 blue:170.0/255.0 alpha:1.0];
                break;
            }
            case kDidntSleepWell: {
                plotSymbol      = [CPTPlotSymbol ellipsePlotSymbol];
                symbolColor     = [CPTColor colorWithComponentRed:139.0/255.0 green:0.0 blue:0.0 alpha:1.0];
                break;
            }
            default:
                break;
        }

        plotSymbol.fill             = [CPTFill fillWithColor:symbolColor];
        plotSymbol.size             = CGSizeMake(7.0, 7.0);
        return plotSymbol;
    }
}



-(CPTFill *) barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index {

    NSLog(@"barFillForBarPlot for index %d", (int)index);
    int indexInt = (int) index + 1;
    CPTGradient *gradientFill;
    
    switch (indexInt) {
        case kEmotionHappy: {
            gradientFill = [CPTGradient gradientWithBeginningColor:[CPTColor grayColor] 
                                                    endingColor:[CPTColor blueColor]];
            break;
        }
        case kEmotionOverjoyed: {
            gradientFill = [CPTGradient gradientWithBeginningColor:[CPTColor magentaColor] 
                                                       endingColor:[CPTColor purpleColor]];
            break;
        }
        case kEmotionRomantic: {
            gradientFill = [CPTGradient gradientWithBeginningColor:[CPTColor greenColor ] 
                                                       endingColor:[CPTColor cyanColor]];
            break;
        }
        case kEmotionSad: {
            gradientFill = [CPTGradient gradientWithBeginningColor:[CPTColor blackColor] 
               endingColor:[CPTColor brownColor]];
            break;
        }
        case kEmotionDepressed: {
            gradientFill = [CPTGradient gradientWithBeginningColor:[CPTColor darkGrayColor] 
               endingColor:[CPTColor grayColor]];
            break;
        }
        case kEmotionAngry: {
            gradientFill = [CPTGradient gradientWithBeginningColor:[CPTColor grayColor] 
               endingColor:[CPTColor redColor]];
            break;
        }
        default: {
            break;
        }
    }
    gradientFill.gradientType = CPTGradientTypeAxial;
    gradientFill.angle = 90;
    CPTFill *fill = [[CPTFill alloc] initWithGradient:gradientFill];
    return fill;
}



-(CPTFill *) sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    
    NSLog(@"EmotionsHistoryView: sliceFillForPieChart");
     
    /*
     CPTGradient *gradientFill = [CPTGradient gradientWithBeginningColor:[CPTColor grayColor] 
        endingColor:[CPTColor blueColor]];
         //colorWithComponentRed:70 green:130 blue:180 alpha:1]];
    gradientFill.gradientType = CPTGradientTypeAxial;
    gradientFill.angle = 90;
    */
    
    CPTColor *color = [CPTColor whiteColor];
    switch (index) {
        case (kEmotionHappy - 1): {
            color = [CPTColor colorWithComponentRed:255.0/255.0 green:182.0/255.0 blue:193.0/255.0 alpha:1.0];
            break;
        }
        case (kEmotionOverjoyed - 1): {
            color = [CPTColor colorWithComponentRed:176.0/255.0 green:196.0/255.0 blue:222.0/255.0 alpha:1.0];
            break;
        }
        case (kEmotionRomantic - 1): {
            color = [CPTColor colorWithComponentRed:218.0/255.0 green:165.0/255.0 blue:32.0/225.0 alpha:1.0];
            break;
        }
        case (kEmotionSad - 1): {
            color = [CPTColor colorWithComponentRed:255.0/255.0 green:239.0/255.0 blue:213.0/255.0 alpha:1.0];
            break;
        }
        case (kEmotionDepressed - 1): {
            color = [CPTColor colorWithComponentRed:128.0/255.0 green:128.0/255.0 blue:0.0 alpha:1.0];
            break;
        }
        case (kEmotionAngry - 1): {
            color = [CPTColor colorWithComponentRed:224.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];            
            break;
        }
        default:
            break;
    }
    
    CPTFill *fill = [[CPTFill alloc] initWithColor:color];
    return fill;
}



-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    
    NSString *legendTitle;
    
    switch (index) {
            
        case (kEmotionHappy - 1): {
            legendTitle = EMOTION_HAPPY;
            break;
            
        } case (kEmotionOverjoyed - 1): {
            legendTitle = EMOTION_OVERJOYED;
            break;
            
        } case (kEmotionRomantic - 1): {
            legendTitle = EMOTION_ROMANTIC;
            break;
            
        } case (kEmotionSad - 1): {
            legendTitle = EMOTION_SAD;
            break;
            
        } case (kEmotionDepressed - 1): {
            legendTitle = EMOTION_DEPRESSED;
            break;
            
        } case (kEmotionAngry - 1): {
            legendTitle = EMOTION_ANGRY;            
            break;
            
        } default: {
            legendTitle = EMOTION_HAPPY;
            break;
        }
    }
    
    NSLog(@"Legend title for index %d is %@", index, legendTitle);
    return legendTitle;
}



/**
 * Initialize the graph for display
 * @created 4th May 2012
 */
-(void) initializeGraph {
   
    NSLog(@"emotionsHistoryView - initializeGraph: chart type: %d", chartType);

    if (chartType == kChartTypeLine) {
        [self initializeLineChart];
        
    } else if (chartType == kChartTypePie) {
        
        pieChart                = [[CPTPieChart alloc] init];
        pieChart.pieRadius      = 60.0;
        pieChart.frame          = CGRectMake(20.0, 0.0, 80.0, 80.0);
        [self initializePieChart];
        
    } else if (chartType == kChartTypePieCompare) {
        
        NSLog(@"PieChart from %@ to %@", self.historyFromDate, self.historyToDate);
        pieChart                = [[CPTPieChart alloc] init];
        pieChart.pieRadius      = 45.0;
        pieChart.frame          = CGRectMake(0.0, 0.0, 80.0, 80.0);
        [self initializePieChart];
        
    } else if (chartType == kChartTypePieCompareTwo) {
        
        NSLog(@"PieChart2 from %@ to %@", self.historyFromDate, self.historyToDate);
        pieChart2                = [[CPTPieChart alloc] init];
        pieChart2.pieRadius      = 45.0;
        pieChart2.frame          = CGRectMake(0.0, 0.0, 80.0, 80.0);
        [self initializePieChartTwo];
        
    }
}



/**
 * Draws a line chart of:
 *          1. Emotions over time
 *          2. Sleep pattern over time
 * The 'time period' over which the data is plotted is the one chosen by the user in the 'History' page
 * 
 * @created 29th May 2012
 */
-(void) initializeLineChart {

    NSLog(@"initializeLineChart:begin");
    
    chartType = kChartTypeLine;

    // If you make sure your dates are calculated at noon, you shouldn't have to
    // worry about daylight savings. If you use midnight, you will have to adjust
    // for daylight savings time.
    NSDate *today       = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *minDate = [formatter dateFromString:kPlotDateStart];
    NSTimeInterval oneDay   = 24.0 * 60.0 * 60.0;
    // NSTimeInterval oneHour  = 60 * 60;
    
    // CHART THEME
    lineChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [lineChart applyTheme:theme];

    // Set Chart Title
    [self setChartTitle:kLineChartTitle];
    
    
    // AXES
    NSTimeInterval xLow       = 0.0f;
    NSDate *thisDate = [Utility getDateFromString:kPlotDateStart withFormat:@"yyyy-MM-dd HH:mm"];
    int numOfDaysSinceStart   = [Utility numOfDaysSinceDate:thisDate];
    
    /*
     NSUInteger moodSleepCount = [moodSleepHistory count];
    NSLog(@"initializeLineChart: moodSleepCount %d", [moodSleepHistory count]);
    double xAxisLength = moodSleepCount;
     */
    NSLog(@"x axis len: %d", numOfDaysSinceStart+1);
    double yAxisLength = kEmotionsCount+2;
    double yAxisStart = 0.0;

    
    // Set up the hosting view
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *) self;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
        
    // Set up the padding
    lineChart.plotAreaFrame.masksToBorder = NO;
    lineChart.paddingLeft   = kGraphPadLeft;
    lineChart.paddingTop    = kGraphPadTop;
    lineChart.paddingRight  = kGraphPadRight;
    lineChart.paddingBottom = kGraphPadBottom;
    
    hostingView.hostedGraph              = lineChart;
    
    // Set up the plot space
    CPTXYPlotSpace *plotSpace       = (CPTXYPlotSpace *) lineChart.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange                = [CPTPlotRange 
                                                plotRangeWithLocation:CPTDecimalFromDouble(xLow) 
                                                length:CPTDecimalFromInt([self getLineChartXRange])];
    plotSpace.yRange                = [CPTPlotRange 
                                                plotRangeWithLocation:CPTDecimalFromDouble(yAxisStart) 
                                                length:CPTDecimalFromDouble(yAxisLength)];
    CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(yAxisStart) length:CPTDecimalFromDouble(yAxisLength+1.0)];
    plotSpace.globalYRange = globalYRange;
    
    CPTPlotRange *globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(xLow) length:CPTDecimalFromDouble(numOfDaysSinceStart+1.0)];
    plotSpace.globalXRange = globalXRange;

    
    
    // Set up the axes
    CPTXYAxisSet *axisSet           = (CPTXYAxisSet *) lineChart.axisSet;
    
    CPTXYAxis *x                    = axisSet.xAxis;
    x.majorIntervalLength           = CPTDecimalFromFloat(oneDay);
    x.majorTickLength               = 1.0;
    x.axisLabels                    = [self getXLabelSetForLineChart:x];
    x.labelRotation                 = M_PI / 2;
    x.title                         = kLineChartXAxisTitle;
    x.titleOffset                   = 1.0;
    //x.orthogonalCoordinateDecimal   = CPTDecimalFromString(@"1");
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterShortStyle;
    // TODO : deploy : check what time zone you intend to set
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    timeFormatter.referenceDate = today;
    x.labelFormatter            = timeFormatter;
    x.labelingPolicy                = CPTAxisLabelingPolicyNone;

    CPTXYAxis *y                    = axisSet.yAxis;
    y.majorIntervalLength           = CPTDecimalFromString(@"15");
    y.minorTicksPerInterval         = 0;
    y.title                         = kLineChartYAxisTitle;
    y.titleLocation                 = [[NSDecimalNumber numberWithInt:5] decimalValue];
    y.titleOffset                   = 27.0;
    y.axisLabels                    = [self getYLabelSetForLineChart:y];
    y.labelingPolicy                = CPTAxisLabelingPolicyNone;
    y.majorTickLength               = 2.0;
    //y.orthogonalCoordinateDecimal   = CPTDecimalFromString(@"1");
    
    // Line style for the plot 'time vs emotion'
    CPTMutableLineStyle *lineStyle  = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth             = 2.0f;
    lineStyle.lineColor             = 
                [CPTColor 
                    colorWithComponentRed:112.0/255.0 green:128.0/255.0 blue:144.0/255.0 alpha:1.0];
    //lineStyle.dashPattern           = [NSArray arrayWithObjects:[NSNumber numberWithFloat:2.0f], 
    //                                   [NSNumber numberWithFloat:2.0f], nil];

    

    // ----------------- Plot of the time vs emotion ---------------------------------
    CPTScatterPlot *plotOfEmoticon  = [[CPTScatterPlot alloc] init];
    plotOfEmoticon.dataLineStyle    = lineStyle;
    plotOfEmoticon.identifier       = kEmotionsPlotIdentifier;
    //plotOfEmoticon.title            = @"Emotion over Time";
    plotOfEmoticon.dataSource       = self;

    /*
    plotOfEmoticon.shadowOffset = CGSizeMake(0.0, -1.0); 
    plotOfEmoticon.shadowColor = [[UIColor lightGrayColor] CGColor]; 
    plotOfEmoticon.shadowRadius = 1.0f; 
    plotOfEmoticon.shadowOpacity = 1.0; 
     */
    
    CPTMutableShadow *shadow1   = [CPTMutableShadow shadow];
    shadow1.shadowOffset        = CGSizeMake(0,-1);
    shadow1.shadowColor         = [CPTColor colorWithComponentRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:0.3];
    plotOfEmoticon.shadow       = shadow1;
    
    [lineChart addPlot:plotOfEmoticon toPlotSpace:plotSpace];
    
    
    
    // Line style for the plot 'time vs emotion'
    CPTMutableLineStyle *lineStyle2  = [CPTMutableLineStyle lineStyle];
    lineStyle2.lineWidth             = 3.0f;
    lineStyle2.lineColor             = 
                [CPTColor colorWithComponentRed:85.0/255.0 green:107.0/255.0 blue:47.0/255.0 alpha:1.0];
    // ----------------- Plot of the time vs sleep pattern ---------------------------------
    CPTScatterPlot *plotOfSleep     = [[CPTScatterPlot alloc] init];
    plotOfSleep.dataLineStyle       = lineStyle2;
    plotOfSleep.title               = @"Sleep vs Time";
    plotOfSleep.identifier          = kSleepPlotIdentifier;
    //plotOfSleep.title               = @"Plot of sleep over time";
    plotOfSleep.dataSource          = self;
    
    [lineChart addPlot:plotOfSleep toPlotSpace:plotSpace];

    NSLog(@"initializeLineChart: end");
}



/**
 * Returns a set of custom labels for the X-Axis for the 'Emotion & Sleep vs Time' LineChart
 * Each label represents the date on which the note was recorded.
 *
 * @created 31st May 2012
 */
-(NSSet *) getXLabelSetForLineChart: (CPTXYAxis *) xyAxis {
    
    NSLog(@"getXLabelSetForLineChart:begin");
    
    int numOfPlots = [moodSleepHistory count];
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:numOfPlots];
    lineChartPlotTimeLabel = [[NSMutableArray alloc] init];
    
    for ( int i = 0; i < numOfPlots; i++ ) {
                
        NSDictionary *dict = [moodSleepHistory objectAtIndex:i];
        NSString *str = [dict objectForKey:kNoteAttrTime];
        NSDate *thiDate = [NSDate dateWithTimeIntervalSince1970:[str intValue]];
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"yyyy-MM-dd"];
        NSString *str2 = [formatter2 stringFromDate:thiDate];
        NSLog(@"getXLabelSetForLineChart %d : formatted str2:%@", i, str2);
        
        NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
        [formatter3 setDateFormat:@"HH:mm"];
        NSString *str3 = [formatter3 stringFromDate:thiDate];
        NSLog(@"getXLabelSetForLineChart %d : formatted str3:%@", i, str3);
        [lineChartPlotTimeLabel addObject:str3];
        
        NSString *stri  = [dict objectForKey:kNoteAttrTime];
        double numDays  = [Utility numOfDaysSinceTimeInterval:[stri intValue]];
        int numOfDays   =  ceil(numDays);
        NSLog(@"numberForPlot.kChartTypeLine.CPTScatterPlotFieldX - %d", numOfDays);
        
        CPTLayer *layer = [[CPTLayer alloc] initWithFrame:CGRectMake(0.0, 0.0, 66.0, 20.0)];
        CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:str2];
        [layer addSublayer:textLayer];
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithContentLayer:layer];
        newLabel.tickLocation = [[NSNumber numberWithInt:numOfDays] decimalValue];
        /*
        newLabel.tickLocation = [[NSNumber numberWithInt:((numOfDays*3)+6)] decimalValue];
        if (i == 0) {
            newLabel.tickLocation = [[NSNumber numberWithInt:6] decimalValue];
        }
        */
        newLabel.offset = xyAxis.labelOffset + xyAxis.majorTickLength;
        [customLabels addObject:newLabel];
    }
    NSLog(@"lineChartPlotTimeLabel len: %d", [lineChartPlotTimeLabel count]);
    lineChartPlotXLabel = [[NSArray alloc] initWithArray:lineChartPlotTimeLabel];
    return [NSSet setWithArray:customLabels];
}



/**
 * Returns a set of custom labels for the Y-Axis for the 'Emotion & Sleep vs Time' LineChart
 * Each label represents one of the six emotions thro' an emoticon
 * @created 31st May 2012
 */
-(NSSet *) getYLabelSetForLineChart: (CPTXYAxis *) xyAxis {
    
    NSLog(@"getEmotionYLabelSetForLineChart:begin");
    
    CPTLayer *layer;
    CPTImageLayer *imgLayer;
    CPTAxisLabel *newLabel;
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:8];

    // Label 'Poor Sleep'
    CPTMutableTextStyle *style1    = [[CPTMutableTextStyle alloc] init];
    style1.fontName         = @"Helevetica";
    style1.fontSize         = 10.0;
    style1.color            = [CPTColor grayColor];  
    CPTLayer *layer7 = [[CPTLayer alloc] 
                            initWithFrame:CGRectMake(0.0, 0.0, 66.0, 20.0)];
    CPTTextLayer *textLayer1 = [[CPTTextLayer alloc] 
                                initWithText:@"Poor Sleep"];
    [layer7 addSublayer:textLayer1];
    CPTAxisLabel *newLabel7 = [[CPTAxisLabel alloc] initWithContentLayer:layer7];
    newLabel7.tickLocation = [[NSNumber numberWithInt:1] decimalValue];
    newLabel7.offset = xyAxis.labelOffset + xyAxis.majorTickLength;
    [customLabels addObject:newLabel7];
    
    // Label 'Sound Sleep'
    CPTMutableTextStyle *style2    = [[CPTMutableTextStyle alloc] init];
    style2.fontName         = @"Helevetica";
    style2.fontSize         = 10.0;
    style2.color            = [CPTColor grayColor];  
    CPTLayer *layer8 = [[CPTLayer alloc] 
                            initWithFrame:CGRectMake(0.0, 0.0, 72.0, 20.0)];
    CPTTextLayer *textLayer2 = [[CPTTextLayer alloc] 
                                initWithText:@"Sound Sleep"];
    [layer8 addSublayer:textLayer2];
    CPTAxisLabel *newLabel8 = [[CPTAxisLabel alloc] initWithContentLayer:layer8];
    newLabel8.tickLocation = [[NSNumber numberWithInt:2] decimalValue];
    newLabel8.offset = xyAxis.labelOffset + xyAxis.majorTickLength;
    [customLabels addObject:newLabel8];
    
    
    // Label 'Happy'
    layer = [[CPTLayer alloc] initWithFrame:CGRectMake(0.0, 0.0, 15.0, 15.0)];
    imgLayer = [[CPTImageLayer alloc] 
                initWithImage:[UIImage imageNamed:ICON_EMOTICON_HAPPY]];
    [layer addSublayer:imgLayer];
    newLabel = [[CPTAxisLabel alloc] initWithContentLayer:layer];
    newLabel.tickLocation = [[NSNumber numberWithInt:3] decimalValue];
    newLabel.offset = xyAxis.labelOffset + xyAxis.majorTickLength;
    [customLabels addObject:newLabel];


    // Label 'Overjoyed'
    CPTLayer *layer2 = 
        [[CPTLayer alloc] initWithFrame:CGRectMake(0.0, 0.0, 15.0, 15.0)];
    CPTImageLayer *imgLayer2 = [[CPTImageLayer alloc] 
         initWithImage:[UIImage imageNamed:ICON_EMOTICON_OVERJOYED]];
    [layer2 addSublayer:imgLayer2];
    CPTAxisLabel *newLabel2 = [[CPTAxisLabel alloc] initWithContentLayer:layer2];
    newLabel2.tickLocation = [[NSNumber numberWithInt:4] decimalValue];
    newLabel2.offset = xyAxis.labelOffset + xyAxis.majorTickLength;
    [customLabels addObject:newLabel2];

    
    // Label 'Romantic'
    CPTLayer *layer3 = 
        [[CPTLayer alloc] initWithFrame:CGRectMake(0.0, 0.0, 15.0, 15.0)];
    CPTImageLayer *imgLayer3 = [[CPTImageLayer alloc] 
            initWithImage:[UIImage imageNamed:ICON_EMOTICON_ROMANTIC]];
    [layer3 addSublayer:imgLayer3];
    CPTAxisLabel *newLabel3 = [[CPTAxisLabel alloc] initWithContentLayer:layer3];
    newLabel3.tickLocation = [[NSNumber numberWithInt:5] decimalValue];
    newLabel3.offset = xyAxis.labelOffset + xyAxis.majorTickLength;
    [customLabels addObject:newLabel3];

    
    // Label 'Sad'
    CPTLayer *layer4 = 
        [[CPTLayer alloc] initWithFrame:CGRectMake(0.0, 0.0, 15.0, 15.0)];
    CPTImageLayer *imgLayer4 = 
        [[CPTImageLayer alloc] 
            initWithImage:[UIImage imageNamed:ICON_EMOTICON_SAD]];
    [layer4 addSublayer:imgLayer4];
    CPTAxisLabel *newLabel4 = [[CPTAxisLabel alloc] initWithContentLayer:layer4];
    newLabel4.tickLocation = [[NSNumber numberWithInt:6] decimalValue];
    newLabel4.offset = xyAxis.labelOffset + xyAxis.majorTickLength;
    [customLabels addObject:newLabel4];
    
    
    // Label 'Depressed'
    CPTLayer *layer5 = 
        [[CPTLayer alloc] initWithFrame:CGRectMake(0.0, 0.0, 15.0, 15.0)];
    CPTImageLayer *imgLayer5 = 
        [[CPTImageLayer alloc] 
            initWithImage:[UIImage imageNamed:ICON_EMOTICON_DEPRESSED]];
    [layer5 addSublayer:imgLayer5];
    
    CPTAxisLabel *newLabel5 = [[CPTAxisLabel alloc] initWithContentLayer:layer5];
    newLabel5.tickLocation = [[NSNumber numberWithInt:7] decimalValue];
    newLabel5.offset = xyAxis.labelOffset + xyAxis.majorTickLength;
    [customLabels addObject:newLabel5];

    
    // Label 'Angry'
    CPTLayer *layer6 = 
        [[CPTLayer alloc] initWithFrame:CGRectMake(0.0, 0.0, 15.0, 15.0)];
    CPTImageLayer *imgLayer6 = 
        [[CPTImageLayer alloc] 
            initWithImage:[UIImage imageNamed:ICON_EMOTICON_ANGRY]];
    [layer6 addSublayer:imgLayer6];
    
    CPTAxisLabel *newLabel6 = [[CPTAxisLabel alloc] initWithContentLayer:layer6];
    newLabel6.tickLocation = [[NSNumber numberWithInt:8] decimalValue];
    newLabel6.offset = xyAxis.labelOffset + xyAxis.majorTickLength;
    [customLabels addObject:newLabel6];

    NSLog(@"getEmotionYLabelSetForLineChart:end");
    
    return [NSSet setWithArray:customLabels];
}



/** 
 * Initialize the pie chart for display
 * @created 5th May 2012
 */
-(void) initializePieChart {
    
    NSLog(@"EmotionsHistoryView: initializePieChart; moodhistdata count: %d", [moodHistData count]);

    graph = [[CPTXYGraph alloc] init];
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    graph.plotAreaFrame.masksToBorder = NO;

    hostingView = (CPTGraphHostingView *) self;
    hostingView.hostedGraph = graph;  
    
    pieChart.dataSource         = self;
    pieChart.shadowOffset       = CGSizeMake(8, 8);
    // pieChart.paddingLeft    = kPiePadLeft;
    // pieChart.paddingTop     = kPiePadTop;
    // pieChart.paddingRight   = kPiePadRight;
    // pieChart.paddingBottom  = kPiePadBottom;
    pieChart.identifier     = kPieChartIdentifier;
    pieChart.startAngle     = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionCounterClockwise;
    pieChart.labelOffset        = -0.3;
    
    if (chartType != kChartTypePieCompare) {
        
        [self setChartTitle:kPieChartTitle];
        pieChart.labelRotation = 0.8;
    
        CPTMutableTextStyle *legendTextStyle = [CPTTextStyle textStyle];
        legendTextStyle.fontSize = 10.0f;
        legendTextStyle.color = [CPTColor blackColor];
        CPTLegend *theLegend = [CPTLegend legendWithPlots:[NSArray arrayWithObject:[graph plotAtIndex:0]]];
        theLegend.numberOfColumns = 2;
        theLegend.textStyle = legendTextStyle;
        theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
        theLegend.borderLineStyle = [CPTLineStyle lineStyle];
        theLegend.cornerRadius = 5.0;
        graph.legend    = theLegend;
        graph.legendAnchor = CPTRectAnchorRight;
        graph.legendDisplacement = CGPointMake(-26.0, -125.0);
        
    } else {
        [self setChartTitle:kPieChartCompareTitle];
    }
    
    [graph addPlot:pieChart];

    graph.axisSet.hidden    = YES;
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet;
    axisSet.xAxis.labelingPolicy    = CPTAxisLabelingPolicyNone;
    axisSet.yAxis.labelingPolicy    = CPTAxisLabelingPolicyNone;
    
    NSLog(@"added pie chart to the graph view");
}



/** 
 * Initialize the second pie chart for display (for comparison)
 * @created 7th June 2012
 */
-(void) initializePieChartTwo {
    
    NSLog(@"EmotionsHistoryView: initializePieChartTwo; moodhistdata count: %d", [moodHistData2 count]);
    
    graph2 = [[CPTXYGraph alloc] init];
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph2 applyTheme:theme];
    graph2.plotAreaFrame.masksToBorder = NO;
    
    hostingView2 = (CPTGraphHostingView *) self;
    hostingView2.hostedGraph = graph2;  
    
    [self setChartTitle:kPieChartCompareTitle];
    pieChart2.dataSource        = self;
    pieChart2.shadowOffset      = CGSizeMake(8, 8);
    // pieChart.paddingLeft     = kPiePadLeft;
    // pieChart2.paddingTop     = 0.0;
    // pieChart.paddingRight    = kPiePadRight;
    // pieChart2.paddingBottom  = 10.0;
    pieChart2.identifier        = kPieChartCompareIdentifier;
    pieChart2.startAngle        = M_PI_4;
    pieChart2.sliceDirection    = CPTPieDirectionCounterClockwise;
    // pieChart2.centerAnchor   = CGPointMake(40.0, 20.0);
    pieChart2.borderColor       = [[UIColor lightGrayColor] CGColor];
    pieChart2.borderWidth       = 1.0;
    NSLog(@"piechart x:%f, y:%f, width:%f, height:%f", 
          pieChart2.frame.origin.x, pieChart2.frame.origin.y,
          pieChart2.frame.size.width, pieChart2.frame.size.height);
    //[self setChartTitle:kPieChartTitle];
    
    pieChart2.labelOffset       = 0.0;
    
    [graph2 addPlot:pieChart2];
    
    
    CPTMutableTextStyle *legendTextStyle = [CPTTextStyle textStyle];
    legendTextStyle.fontSize   = 8.0f;
    legendTextStyle.color      = [CPTColor darkGrayColor];
    CPTLegend *theLegend       = [CPTLegend 
                                  legendWithPlots:[NSArray 
                                    arrayWithObject:[graph2 plotAtIndex:0]]];
    theLegend.numberOfColumns  = 2;
    theLegend.textStyle        = legendTextStyle;
    theLegend.fill             = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle  = [CPTLineStyle lineStyle];
    theLegend.cornerRadius     = 5.0;
    graph2.legend              = theLegend;
    graph2.legendAnchor        = CPTRectAnchorRight;
    graph2.legendDisplacement  = CGPointMake(-1.0, -65.0);
     
    
    graph2.axisSet.hidden       = YES;
    CPTXYAxisSet *axisSet       = (CPTXYAxisSet *) graph2.axisSet;
    axisSet.xAxis.labelingPolicy= CPTAxisLabelingPolicyNone;
    axisSet.yAxis.labelingPolicy= CPTAxisLabelingPolicyNone;
    
    NSLog(@"added pie chart2 to the graph view2");
}



-(void) initializeBarChart {
    
    chartType = kChartTypeBar;
    
    double xAxisStart = 0.0;
    double xAxisLength = kEmotionsCount;
    double yAxisStart = 0.0;
    
    // Calculate total
    int moodTotal = 0;
    NSNumber *currentMoodCount;
    for (int index=0; index < [moodHistData count]; index++) {
        currentMoodCount = [moodHistData objectAtIndex:index];
        moodTotal = moodTotal + [currentMoodCount intValue];
        NSLog(@"initializeGraph: Adding %@ to the total moodcount %d", 
              currentMoodCount, moodTotal);
    }
    double yAxisLength = 100.0;
    
    //graph = [[CPTXYGraph alloc] init];
    CPTTheme *theme;
    //= [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //[graph applyTheme:theme];
    
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *) self;
    // hostingView.hostedGraph = graph;  
    
    
    /*
     CPTBarPlot *plot = [[CPTBarPlot alloc] initWithFrame:CGRectZero];
     plot.plotRange = [CPTPlotRange 
     plotRangeWithLocation:CPTDecimalFromDouble(xAxisStart) 
     length:CPTDecimalFromDouble(xAxisLength)];
     plot.dataSource = self;
     [graph addPlot:plot];
     */
    
    CPTXYGraph *barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [barChart applyTheme:theme];
    // hostingView = (CPTGraphHostingView *)self;
    
    barChart.plotAreaFrame.masksToBorder = NO;
    barChart.paddingLeft   = kGraphPadLeft;
    barChart.paddingTop    = kGraphPadTop;
    barChart.paddingRight  = kGraphPadRight;
    barChart.paddingBottom = kGraphPadBottom;
    
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) barChart.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange 
                        plotRangeWithLocation:CPTDecimalFromDouble(xAxisStart) 
                        length:CPTDecimalFromDouble(xAxisLength)];
    plotSpace.yRange = [CPTPlotRange 
                        plotRangeWithLocation:CPTDecimalFromDouble(yAxisStart) 
                        length:CPTDecimalFromDouble(yAxisLength)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisLineStyle               = nil;
    x.majorTickLineStyle          = nil;
    x.minorTickLineStyle          = nil;
    x.majorIntervalLength         = CPTDecimalFromString(@"20");
    x.minorTicksPerInterval       = 0;
    //x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    x.title                       = @"My Emotional States";
    x.titleLocation               = CPTDecimalFromFloat(7.5f);
    //x.titleOffset                 = 5.0f;
    
    // Define some custom labels for the data elements
    x.labelRotation  = M_PI / 2;
    // x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    /*
     NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1], [NSDecimalNumber numberWithInt:5], [NSDecimalNumber numberWithInt:10], [NSDecimalNumber numberWithInt:15], [NSDecimalNumber numberWithInt:20], nil];
     NSArray *xAxisLabels         = [NSArray arrayWithObjects:@"Happy", @"Overjoyed", @"Romantic", @"Sad", @"Depressed", @"Angry", nil];
     NSUInteger labelLocation     = 0;
     NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
     for ( NSNumber *tickLocation in customTickLocations ) {
     CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
     newLabel.tickLocation = [tickLocation decimalValue];
     newLabel.offset       = x.labelOffset + x.majorTickLength;
     newLabel.rotation     = M_PI / 4;
     [customLabels addObject:newLabel];
     }
     x.axisLabels = [NSSet setWithArray:customLabels];
     */
    
    CPTXYAxis *y                  = axisSet.yAxis;
    y.axisLineStyle               = nil;
    y.majorTickLineStyle          = nil;
    y.minorTickLineStyle          = nil;
    y.minorTicksPerInterval       = 0;
    y.majorIntervalLength         = CPTDecimalFromString(@"20");
    //y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    y.title                       = @"Number of times I was in the state";
    y.titleOffset                 = 40.0f;
    //y.titleLocation               = CPTDecimalFromFloat(150.0f);
    
    
    // Second bar plot
    CPTBarPlot *barPlot= [CPTBarPlot 
                          tubularBarPlotWithColor:[CPTColor blueColor]        
                          horizontalBars:NO];
    barPlot.dataSource      = self;
    barPlot.plotRange = [CPTPlotRange 
                         plotRangeWithLocation:CPTDecimalFromDouble(xAxisStart) 
                         length:CPTDecimalFromDouble(xAxisLength)];
    //barPlot.baseValue       = CPTDecimalFromString(@"0");
    barPlot.barOffset       = CPTDecimalFromFloat(0.25f);
    barPlot.barWidth=CPTDecimalFromFloat(0.5f);
    barPlot.barCornerRadius = 2.0f;
    barPlot.identifier      = @"Self-Awareness Plot";
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    hostingView.hostedGraph              = barChart;
}


/**
 * Sets the mood history data (i.e. the count of the various mood types)
 * so that they can be used to chart it.
 * @created 5th May 2012
 */
-(void) setMoodHistoryData:(NSArray *)moodHistory {
    moodHistData = moodHistory;
    NSLog(@"EmotionsHistoryView: setMoodHistoryData count: %d", [moodHistData count]);
}


-(void) setMoodHistoryDataTwo:(NSArray *)moodHistory {
    moodHistData2 = moodHistory;
    NSLog(@"EmotionsHistoryView: setMoodHistoryData2 count: %d", [moodHistData2 count]);
}


-(void) setMoodSleepHistory:(NSArray *)moodSleepHist {
    NSLog(@"EmotionsHistoryView: setMoodSleepHistory with count %d", [moodSleepHist count]);
    moodSleepHistory = moodSleepHist;
}


-(NSString *) getMoodRatioForMood: (int) moodType
                      withHistory:(NSArray *)histData {
    
    NSUInteger index;
    NSNumber *currentMoodCount;
    int moodOfInterest;
    NSLog(@"getMoodRatioForMood: Calculating the total mood count");
    bool calcCount = false;
    int     moodTotal = 0;

    // Is the total being calculated for the first time? 
    // If yes, set 'calcCount' to true
    if (moodTotal == 0) {
        calcCount = true;
    }

    for (index=0; index < [histData count]; index++) {
        
            currentMoodCount = [histData objectAtIndex:index];
        
            if (calcCount) {
                moodTotal = moodTotal + [currentMoodCount intValue];
                NSLog(@"getMoodRatioForMood: Adding %@ to the total moodcount", currentMoodCount);
            }
            // Check if this' the mood type for which the ratio needs to be calculated
            if (index == moodType) {
                moodOfInterest = [currentMoodCount intValue];
                NSLog(@"getMoodRatioForMood: setting mood of interest to %d", moodOfInterest);
            }
    }
    
    NSLog(@"getMoodRatioForMood: Total Mood Count: %d, MoodOfInterest:%d", moodTotal, moodOfInterest);

    float moodRatio;
    if (moodOfInterest == 0) {
        moodRatio   = 0.00;
    } else {
        moodRatio   = (float)moodOfInterest / (float)moodTotal * 100.0;
    }
    
    NSLog(@"getMoodRatioForMood: Mood Ratio for mood %d with count %d : %f", index, moodOfInterest, moodRatio);
    //currentMoodCount = [NSNumber numberWithFloat:moodRatio];
    NSString *moodRatioStr = [NSString stringWithFormat:@"%.02f",moodRatio];
    return moodRatioStr;
}



/**
 * 
 * @created 5th June 2012
 */
-(int) getLineChartXRange {

    // Start Date : Get the date when the first note was logged
    NSDictionary *dict1     = [moodSleepHistory objectAtIndex:0];
    NSString *str1          = [dict1 objectForKey:kNoteAttrTime];
    int startDateInt        = [str1 intValue];
    
    NSDictionary *dict2     = [moodSleepHistory objectAtIndex:([moodSleepHistory count]-1)];
    NSString *str2          = [dict2 objectForKey:kNoteAttrTime];
    int endDateInt          = [str2 intValue];
    
    int numOfDaysAsInterval = endDateInt - startDateInt;
    double numDays          = (double) numOfDaysAsInterval / (24.0*60.0*60.0);
    int numOfDays           = ceil(numDays);
    NSLog(@"getLineChartXRange : %d", numOfDays);
    
    return numOfDays;
}


/**
 * Returns the graph as an image
 * @return  UIImage     The Graph as Image
 */
-(UIImage *) getGraphAsImage {
    if (chartType == kChartTypePie){
        return [pieChart imageOfLayer];
        
    } else if (chartType == kChartTypeLine) {
        NSLog(@"getGraphAsImage: line chart");
        return [lineChart imageOfLayer];
    }
    return nil;
}



-(void) setChartTitle: (NSString *) chartTitle {
    
    NSLog(@"setChartTitle: Set chart title %@", chartTitle);
    self.labelChartTitle.text = chartTitle;
    
    // Convert the dates to the format "MMM dd, yyyy", for example Jun 28, 2012
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    NSString *fromDateStr       = [formatter stringFromDate:histFromDate];
    NSString *toDateStr         = [formatter stringFromDate:histToDate];
    NSLog(@"histfromdate: %@", histFromDate);
    NSLog(@"histtodate: %@", histToDate);
    // Append them to make a string to be displayed; something like "Jan 01, 2012 to Jun 28, 2012"
    NSString *str1              = [fromDateStr stringByAppendingString:@" "];
    NSString *str2              = [str1 stringByAppendingString:@"to "];
    NSString *str3            = [str2 stringByAppendingString:toDateStr];
    NSString *period;
    if (chartType == kChartTypePieCompare) {
        period = [@"Period 1 : " stringByAppendingString:str3];
    } else if (chartType == kChartTypePieCompareTwo) {
        period = [@"Period 2 : " stringByAppendingString:str3];
    } else {
        period = str3;
    }
    
    [self.labelChartPeriod setText:period];
    NSLog(@"EmotionsHistoryView: setChartTitle - self.labelChartPeriod: %@, chartTitle: %@", self.labelChartPeriod.text, self.labelChartTitle.text);
}



-(void) setChartType: (int)type {
    NSLog(@"EmotionsHistoryView-setChartType: %d", type);
    chartType = type;
}



-(void) setHistoryFromDate: (NSDate *) date {
    NSLog(@"EmotionsHistoryView.setHistoryFromDate: set to date %@", date);
    historyFromDate = date;
    histFromDate = date;
}


-(void) setHistoryToDate  : (NSDate *) date {
    NSLog(@"EmotionsHistoryView.setHistoryToDate: set to date %@", date);
    historyToDate = date;
    histToDate = date;
}



/*
-(id) init {
    self = [super init];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/


#pragma mark - View lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    // return (interfaceOrientation == UIInterfaceOrientationPortrait);
    // TODO : @deploy - check this!!! whether it works
    return YES;
}

@end

