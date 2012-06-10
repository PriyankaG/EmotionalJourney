//
//  Utility.m
//  EmotionalJourney
//
//  Created by Administrator on 23/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"

#define kEmotionHappy 1
#define kEmotionOverjoyed 2
#define kEmotionRomantic 3
#define kEmotionSad 4
#define kEmotionDepressed 5
#define kEmotionAngry 6


@implementation Utility


+(int) getDateAsInt: (NSDate *) inputDate {
    
    NSTimeInterval interval = [inputDate timeIntervalSince1970];
    //NSLog(@"getDateAsInt - Time Interval: %f", interval);
    return (int)interval;
}


+(NSDate *) getIntAsDate: (int) intDate {
    NSDate *dateNow = [NSDate dateWithTimeIntervalSince1970:intDate];
    //NSLog(@"getIntAsDate - Date converted from time interval: %@", dateNow);
    return dateNow;
}


+(NSString *) getDateAsString: (NSDate *) thisDate {
    NSDate *dateInput = thisDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterMediumStyle;
    return [formatter stringFromDate:dateInput];
}


+(NSString *) getDateAsString: (NSDate *)thisDate
                   withFormat: (NSString *)dateFormat {
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:dateFormat];
    return [formatter1 stringFromDate:thisDate];
}


+(int) numOfDaysSinceDate: (NSDate *)inputDate {
    NSDate *today = [NSDate date];
    NSTimeInterval timeIntervalSinceMinDate = [today timeIntervalSinceDate:inputDate];
    int numOfDays = (int) timeIntervalSinceMinDate / (24*60*60);
    NSLog(@"num ofdays since start: %d", numOfDays);
    return numOfDays;
}


+(double) numOfDaysSinceTimeInterval: (int) inputTimeInterval {
    NSDate *today = [NSDate date];
    NSDate *thatDay = [NSDate dateWithTimeIntervalSince1970:inputTimeInterval];
    int timeIntFromToday = [today timeIntervalSince1970] - inputTimeInterval;
    double numOfDays = (double) timeIntFromToday / (24.0*60.0*60.0);
    NSLog(@"numOfDaysSinceTimeInterval: %f", numOfDays);
    return numOfDays;
}


+(NSDate *) getDateFromString:(NSString *) strDate
                       withFormat:(NSString *) format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *dateFromStr = [formatter dateFromString:strDate];
    return dateFromStr;
}


/** 
 * Utility method that returns the given 'int' as 'NSString'
 * @param   integer  int   The 'int' that has to be converted to type 'NSString'
 * @return  NSString       The 'int' that's been converted to 'NSString'
 * @created 6th May 2012
 */
+(NSString *) getIntAsString: (int) integer {
    return [[NSNumber numberWithInt:integer] stringValue];
}


/**
 * Utility method to concatenate three given strings
 * @param   string1  NSString  The first string to be concatenated
 * @param   string2  NSString  The second string to be concatenated
 * @param   string3  NSString  The third string to be concatenated
 * @return  NSString           The concatenated string
 * @created 6th May 2012
 */
+(NSString *) concatenateStringsInArray: (NSArray *) stringArray {

    NSMutableString *concatString = [[NSMutableString alloc] init];
    
    for (int index=0; index < [stringArray count]; index++) {
        [concatString appendString:[stringArray objectAtIndex:index]];
        [concatString appendString:@" "];
        // NSLog(@"added string:%@", [stringArray objectAtIndex:index]);
    }    
    // NSLog(@"concatenated string: %@", concatString);
    return concatString;
}


+(int) validateEmoticon: (int) emoticonCode {
    if ((emoticonCode == kEmotionHappy)     ||
        (emoticonCode == kEmotionOverjoyed) ||
        (emoticonCode == kEmotionRomantic)  ||
        (emoticonCode == kEmotionSad)       || 
        (emoticonCode == kEmotionDepressed) ||
        (emoticonCode == kEmotionAngry)) {
        // it's valid then
    } else {
        emoticonCode = -1;
    }
    return emoticonCode;
}



/**
 * Stores the image locally
 * Image name: current date/time in the format 'yyyyMMdd_HHmm'
 * Image type: stored as JPG file
 * Only the image name gets stored in the db
 * @param   img   UIImage     The image that's to be stored locally
 * @return        NSString    The name of the image in the local store
 * @created 28th May 2012
 */
+(NSString *) storeImageLocally: (UIImage *)img {
    
    NSDate *now = [NSDate date];
    NSString *name = [@"Documents/" stringByAppendingString:[Utility getDateAsString:now withFormat:@"yyyyMMdd_HHmm"]];
    NSString *imgName = [name stringByAppendingString:@".jpg"];
    NSLog(@"Storing image with the name %@", imgName);
    NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:imgName];
    [imgData writeToFile:jpgPath atomically:YES]; 
    return jpgPath;
}


@end
