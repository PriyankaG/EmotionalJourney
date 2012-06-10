//
//  DatabaseOperations.h
//  EmotionalJourney
//
//  Created by Administrator on 23/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DatabaseOperations : NSObject

// The Singleton DB instance
+(DatabaseOperations *) dbOpsSingleton;

@property (nonatomic) sqlite3 *database;
@property (nonatomic, retain) NSMutableArray *arrayInput;


// Method to create the table in DB, with three fields/columns
-(void) createTableNamed:(NSString *) tableName
              withField1:(NSString *) field1
              withField2:(NSString *) field2
              withField3:(NSString *) field3
              withField4:(NSString *) field4
              withField5:(NSString *) field5
              withField6:(NSString *) field6;


// Method to fetch the database that's present in the device
-(NSString *) filePath; 

// Method to open the database
-(void) openDB;

-(NSMutableArray *) getAllRowsFromTableNamed: (NSString *) tableName;

-(void) insertRecordIntoTableNamed: (NSString *) tableName

                        withField1: (NSString *) field1
                       field1Value: (NSString *) field1Value

                        withField2: (NSString *) field2
                       field2Value: (int)        field2Value

                        withField3: (NSString *) field3
                       field3Value: (NSString *) field3Value

                        withField4: (NSString *) field4
                       field4Value: (int)        field4Value

                        withField5: (NSString *) field5
                       field5Value: (NSString *)  field5Value

                        withField6: (NSString *) field6
                       field6Value: (int)        field6Value;


// Method to close the database
-(int) closeDB;

// Keeps a count of the emoticon types' occurrence-frequency
-(void) countEmoticons: (int) field2;

-(void) addToArrayField1: (NSString *)  field1
                  Field2: (int)         field2
                  Field3: (NSString *)  field3
                  Field4: (int)         field4
                  Field5: (NSString *)   field5
                  Field6: (int)         field6;


-(NSArray *) getDataBetweenDates: (NSString *) tableName 
                          withStartDate: (NSDate *) dateStart
                            withEndDate: (NSDate *) dateEnd;

-(NSArray *) getMoodSleepBetweenDates: (NSString *) tableName 
                        withStartDate: (NSDate *) dateStart
                          withEndDate: (NSDate *) dateEnd;

@end
