//
//  Utility.h
//  EmotionalJourney
//
//  Created by Administrator on 23/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

// Date Operations
+(int)          getDateAsInt:               (NSDate *)  inputDate;
+(NSDate *)     getIntAsDate:               (int)       intDate;
+(NSString *)   getDateAsString:            (NSDate *)  thisDate;
+(NSString *)   getDateAsString: (NSDate *)thisDate
                   withFormat: (NSString *)dateFormat;
+(NSDate *)     getDateFromString:          (NSString *) strDate
                       withFormat:    (NSString *) format;
+(int)          numOfDaysSinceDate:         (NSDate *)  inputDate;
+(double)          numOfDaysSinceTimeInterval: (int)  inputTimeInterval;
+(NSString *)   getIntAsString:             (int)       integer;
+(NSString *)   concatenateStringsInArray:  (NSArray *) stringArray;
+(int)          validateEmoticon:       (int)       emoticonCode;

+(NSString *) storeImageLocally: (UIImage *)img;

@end
