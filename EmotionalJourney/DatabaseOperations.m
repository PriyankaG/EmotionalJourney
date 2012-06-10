//
//  DatabaseOperations.m
//  EmotionalJourney
//
//  Created by Administrator on 23/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatabaseOperations.h"
#import "Utility.h"

#define kEmotionHappy       1
#define kEmotionOverjoyed   2
#define kEmotionRomantic    3
#define kEmotionSad         4
#define kEmotionDepressed   5
#define kEmotionAngry       6
#define kEmptyString        @""

// Names of the attributes of a note
#define kNoteAttrTime       @"time"
#define kNoteAttrSleep      @"sleep"
#define kNoteAttrEmoticon   @"emoticon"

// DB Fields' order
#define kDbFieldTime            1
#define kDbFieldEmoticon        3
#define kDbFieldSleep           5



@implementation DatabaseOperations

@synthesize database;
@synthesize arrayInput;

static DatabaseOperations *dbOps = nil;
NSInteger rowsCount = 0;
NSInteger emoticon2Count = 0;
NSInteger emoticon3Count = 0;
NSInteger emoticon4Count = 0;
NSInteger emoticon5Count = 0;
NSInteger emoticon6Count = 0;
NSInteger emoticon7Count = 0;


+(DatabaseOperations *) dbOpsSingleton {
    if (dbOps == nil) {
        dbOps = [[DatabaseOperations alloc] init];
        [dbOps openDB];
    }
    return dbOps;
}


// Fetch the database from the device
+(NSString *) filePath {
    NSLog(@"filepath");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"databaseEmotionalJourney.sql"];
}


// Open the Database, if it already exists; else, create a new one
-(void) openDB {
    
    NSLog(@"openDB : Opening the DB");
    
    if (sqlite3_open([[DatabaseOperations filePath] UTF8String], &database) != SQLITE_OK ) {
        NSLog(@"openDB : closing DB; failure to open");
        sqlite3_close(database);
        NSAssert(0, @"Database failed to open.");
        
    } else {
        NSLog(@"openDB : opened the DB");
        NSLog(@"Successfully opened the database");
    }
}


/**
 * Closes the database connection
 * @return dbClosure  (int) - The result of the attempt to close the database connection
 */
-(int) closeDB {
    NSLog(@"close db");
    int dbClosure = sqlite3_close(database);
    
    if (dbClosure == SQLITE_OK) {
        NSLog(@"Closed the database connection successfully");
        
    } else {
        NSLog(@"Could not close the database connection");
    }
    
    return dbClosure;
}



/**
 * Create the database table, if not already exists, to persist data
 * tableName  (NSString)  -  Name of the table
 * field1     (NSString)  -  first column's name   : user
 * field2     (NSString)  -  second column's name  : time
 * field3     (NSString)  -  third column's name   : text
 * field4     (NSString)  -  fourth column's name  : emoticon
 * field5     (NSString)  -  fifth column's name   : picture
 * field6     (NSString)  -  sixth column's name   : sleep
 */
-(void) createTableNamed:(NSString *) tableName
              withField1:(NSString *) field1
              withField2:(NSString *) field2
              withField3:(NSString *) field3
              withField4:(NSString *) field4
              withField5:(NSString *) field5 
              withField6:(NSString *) field6 {
    
    NSLog(@"create table");
    char *error;
    NSString *createQuery = 
                [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT, '%@' INTEGER, '%@' TEXT, '%@' INTEGER, '%@' BLOB, '%@' INTEGER);", tableName, field1, field2, field3, field4, field5, field6];
    
    if (sqlite3_exec(database, [createQuery UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Table could not be created.");
        NSLog(@"Table creation failed");
        
    } else {
        NSLog(@"Table created successfully");
    }
    
    self.arrayInput = [[NSMutableArray alloc] init];
}



/**
 * Insert data into the table. Input the data entered by the user.
 * 
 * @param tableName   (NSString)   - the table into which the data is inserted into
 * @param withField1  (NSString)   - user
 * @param field1Value (NSString)   - user name
 * @param withField2  (NSString)   - time
 * @param field2Value (int)        - time value
 * @param withField3  (NSString)   - the name of the 2nd field i.e. 'sleep' here
 * @param field3Value (NSString)   - the value chosen by the user for 'sleep', which can be either 'yes' or 'no'
 *
 * @created 23rd Apr 2012
 */
-(void) insertRecordIntoTableNamed: (NSString *) tableName
                         withField1:(NSString *)field1 
                        field1Value:(NSString *)field1Value
                         withField2: (NSString *) field2
                        field2Value: (int) field2Value
                         withField3: (NSString *) field3
                        field3Value: (NSString *) field3Value
                         withField4: (NSString *) field4
                        field4Value: (int) field4Value 
                         withField5: (NSString *) field5
                        field5Value: (NSString *) field5Value 
                         withField6: (NSString *) field6
                        field6Value: (int) field6Value {
    
    NSLog(@"insertRecord: Entered");    
    NSString *query = [NSString stringWithFormat:
                       @"INSERT OR REPLACE INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@') VALUES (?,?,?,?,?,?)", 
                       tableName, 
                       field1, field2, field3, field4, field5, field6];
    const char *queryInsertion = [query UTF8String];
    

    // Now, insert the placeholder values
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, queryInsertion, -1, &statement, nil) == SQLITE_OK ) {
        // user
        sqlite3_bind_text(statement, 1, [field1Value UTF8String], -1, NULL);
        // time
        sqlite3_bind_int(statement, 2, field2Value);         
        // text
        sqlite3_bind_text(statement, 3, [field3Value UTF8String], -1, NULL);
        // emoticon
        sqlite3_bind_int(statement, 4, field4Value);
        
        // picture location
        if (field5Value == nil) {
            field5Value = kEmptyString;
        }
        sqlite3_bind_text(statement, 5, [field5Value UTF8String], -1, NULL);
                                                                       
                                                                
       // value of 'sleep'
       sqlite3_bind_int(statement, 6, field6Value);
                                                                       
                                                                       
        // Convert the picture, if any, to bytes
        /*
        if ( (field5Value != nil) && (field5Value != [NSNull null]) ) {
            NSData *imageData = UIImagePNGRepresentation(field5Value);        
            sqlite3_bind_blob(statement, 5, 
                              [imageData bytes], [imageData length], NULL);
            NSLog(@"Inserted the pic into DB");
            
        } else {
            sqlite3_bind_blob(statement, 5, nil, -1, NULL);
            NSLog(@"no pic to insert into DB");
        }
        */
        
        // Convert the person's picture, if any, to bytes
        /*
        if ( (field6Value != nil) && (field6Value != [NSNull null]) ) {
            NSData *imageData = UIImagePNGRepresentation(field6Value);        
            sqlite3_bind_blob(statement, 6, 
                              [imageData bytes], [imageData length], NULL);
            NSLog(@"Inserted the person-pic into DB. size:%f", field6Value.size.height);
            
        } else {
            sqlite3_bind_blob(statement, 6, nil, -1, NULL);
            NSLog(@"no person-pic to insert into DB");
        }
         */
    }
    NSLog(@"Inserted new record into the table with the values %d, %@, %d, %@, %d", 
                            field2Value, field3Value, field4Value, field5Value, field6Value);
    
    // Execute the statement
    if ( sqlite3_step ( statement ) != SQLITE_DONE ) {
        NSAssert(0, @"Error updating table");
    }
    sqlite3_finalize(statement);
}


// TODO: change/add comments to methods
/** 
 * Fetches all the data from the specified table
 * 
 * @param  tableName  (NSString)  - the table name from which to fetch the values
 * @return (NSArray)              - an array with the values:
 *                                      1. Total num of rows in the table
 *                                      2. Count of rows with the value of emoticon1
 *                                      3. Count of rows with the value of emoticon2
 *                                      4. Count of rows with the value of emoticon3
 *                                                                      in that order
 */
-(NSMutableArray *) getAllRowsFromTableNamed: (NSString *) tableName {
    
    NSLog(@"getAllRowsFromTable: Entered");
    sqlite3_stmt *statement;
    rowsCount = 0;
    emoticon2Count = 0;
    emoticon3Count = 0;
    emoticon4Count = 0;
    emoticon5Count = 0;
    emoticon6Count = 0;
    emoticon7Count = 0;
    arrayInput = [[NSMutableArray alloc] init];
    
    NSString *queryFetch = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    
    // Fetch the data from the table
    if (sqlite3_prepare_v2 ( database, [queryFetch UTF8String], -1, &statement, nil ) == SQLITE_OK) {
 
        NSLog(@"getAllRowsFromTable: got the query executed");
        
        // Iterate through the rows
        while (sqlite3_step(statement) == SQLITE_ROW) {
        
            NSLog(@"getAllRowsFromTable: Stepping through the rows");
            rowsCount = rowsCount+1;
            
            // Get the 1st field's value of 'user'
            char *field1 = (char *) sqlite3_column_text(statement, 0);
            if ((field1 == NULL) || (field1 == nil)) {
                field1 = "";
            }
            NSString *field1Str = [[NSString alloc] initWithUTF8String: field1];
            //NSLog(@"got user: %@", field1Str);
            
            // Get the 2nd field's value i.e. of 'time'
            int field2 = sqlite3_column_int (statement, 1);
            //NSLog(@"got time: %d", field2);
            
            // Get the 3rd field's value of 'text'
            char *field3 = (char *) sqlite3_column_text(statement, 2);
            if ((field3 == NULL) || (field3 == nil)) {
                field3 = "";
            }
            NSString *field3Str = [[NSString alloc] initWithUTF8String: field3];
            //NSLog(@"got field3 value: %@", field3Str);
            
            // Get the 4th value, i.e., that of 'emoticon'
            int field4 = (int) sqlite3_column_int(statement, 3);
            // Make a count of each emoticon type
            [self countEmoticons:field4];
            
            
            // The 5th field - the picture location
            char *field5 = (char *) sqlite3_column_text(statement, 4);
            if ((field5 == NULL) || (field5 == nil)) {
                field5 = "";
            }
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];
            
            
            // Get the 6th value, i.e., that of 'sleep'
            int field6 = (int) sqlite3_column_int(statement, 5);
            

            // Get the 5th field i.e. the picture, if any
            /*
            UIImage *field5 = nil;
            NSData *picData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 4) length:sqlite3_column_bytes(statement, 4)];
            NSLog(@"NSData pic size: %d", (int)picData.length);
            if ( (((int)picData.length) == 0 ) || (picData == NULL) || (picData == nil)) {
                NSLog(@"getAllRowsFromTable: No picture present");
                field5 = [NSNull null];
            } else {
                NSLog(@"getAllRowsFromTable: Picture present");
                field5 = [UIImage imageWithData:picData];
            }
            */
            
            
            // Get the 6th field i.e. the person-picture, if any
            /*
            UIImage *field6 = nil;
            
             NSData *personPicData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 5) length:sqlite3_column_bytes(statement, 5)];
            if ( (((int)personPicData.length) == 0 ) || (personPicData == NULL) || (personPicData == nil)) {
                NSLog(@"getAllRowsFromTable: No person-picture present");
                field6 = [NSNull null];
            } else {
                NSLog(@"getAllRowsFromTable: Person-Picture present");
                field6 = [UIImage imageWithData:personPicData];
            }
            */
            // Display them
            NSString *str = [[NSString alloc] 
                                    initWithFormat:@"%d - %d - %@ - %@ - %d", 
                                    field2, field4, field3Str, field5Str, field6];
            NSLog(@"getAllRowsFromTable: %@", str);
            /*
             if(personPicData != nil) {
                NSLog(@"getAllRowsFromTable: person pic present");
            }
             */
            [self addToArrayField1:field1Str
                            Field2:field2
                            Field3:field3Str
                            Field4:field4
                            Field5:field5Str
                            Field6:field6];
            
            // Now, time to be a good Memory Citizen!
            field1Str = nil;
            field3Str = nil;
            field5Str = nil;
            str = nil;
            field5 = nil;
        }
        
        // delete the compiled statement from memory
        sqlite3_finalize(statement);
        
        NSLog(@"Num of rows:%d ; Emoticon2:%d ; Emoticon3:%d ; Emoticon4:%d ; Emoticon5:%d ; Emoticon6:%d ; Emoticon7:%d", 
              rowsCount, emoticon2Count, emoticon3Count,
              emoticon4Count, emoticon5Count, emoticon6Count, emoticon7Count);
        NSLog(@"Num Returned: %d", [arrayInput count]); 
        return arrayInput;        
    }
    return nil;
}



/**
 * Keeps a count of the emoticon types' occurrence-frequency
 * @param 
 *
 */
-(void) countEmoticons: (int) field2 {
    
    if (field2 == kEmotionHappy) {
        emoticon2Count = emoticon2Count + 1;
        
    } else if (field2 == kEmotionOverjoyed) {
        emoticon3Count = emoticon3Count + 1;
    
    } else if (field2 == kEmotionRomantic) {
        emoticon4Count = emoticon4Count + 1;
        
    } else if (field2 == kEmotionSad) {
        emoticon5Count = emoticon5Count + 1;
        
    } else if (field2 == kEmotionDepressed) {
        emoticon6Count = emoticon6Count + 1;
        
    } else if (field2 == kEmotionAngry) {
        emoticon7Count = emoticon7Count + 1;
    }
}

             

/**
 * The data fetched from the DB (i.e. the user's emotion-notes until now
 * are loaded to a data structure for use within the App
 * @param   - the DB fields and their values
 * @created - April 2012
 */
-(void) addToArrayField1: (NSString *) field1
                Field2: (int) field2
                Field3: (NSString *) field3
                Field4: (int) field4
                Field5: (NSString *) field5
                Field6:(int)field6 {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            field1,                           @"user",
                            [NSNumber numberWithInt:field2],  @"time",
                            field3,                           @"text",           
                            [NSNumber numberWithInt:field4],  @"emoticon",
                            field5,                           @"picture", 
                            [NSNumber numberWithInt:field6],  @"sleep",
                            nil];
    [arrayInput insertObject:dict atIndex:0];
    NSLog(@"Added data %d - %d - %@ - %@ - %d from DB to Array; new array size:%d", field2, field4, field3, field5, field6, [arrayInput count]);
}



-(NSArray *) getMoodSleepBetweenDates: (NSString *) tableName 
                   withStartDate: (NSDate *) dateStart
                     withEndDate: (NSDate *) dateEnd {
    
    NSLog(@"getMoodSleepBetweenDates: Entered");
    sqlite3_stmt *statement;
    NSMutableArray *arrayResults = [[NSMutableArray alloc] init];
    
    int intStartDate = [Utility getDateAsInt:dateStart];
    int intEndDate   = [Utility getDateAsInt:dateEnd];
    
    NSLog(@"Start date %@ as int: %d", dateStart, intStartDate);
    NSLog(@"End date %@ as int  : %d", dateEnd, intEndDate);
    
    NSString *queryFetch = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE (time >= %d) AND (time <= %d)", tableName, intStartDate, intEndDate];
    
    NSLog(@"getMoodSleepBetweenDates: created query");
    
    // Fetch the data from the table
    if (sqlite3_prepare_v2 ( database, [queryFetch UTF8String], -1, &statement, nil ) == SQLITE_OK) {
        
        NSLog(@"getMoodSleepBetweenDates: prepared stmt");
        
        //int field1;
        //char *field2;
        //NSString *field2Str;
        //NSString *str;
        // NSInteger rowsCount = 0;
        
        
        // Iterate through the rows
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSLog(@"getMoodSleepBetweenDates: stepping thro result");
            
            //rowsCount = rowsCount+1;
            
            // Get the 2nd field's field's value i.e. of 'time'
            int field2 = sqlite3_column_int (statement, kDbFieldTime);
            //NSLog(@"got time: %d", field2);
            
            // Get the 6th field's value, i.e., that of 'sleep'
            int field6 = (int) sqlite3_column_int(statement, kDbFieldSleep);
            
            // Get the 4th field's value of 'emoticon'
            int field4 = sqlite3_column_int(statement, kDbFieldEmoticon);
            
           // Display 'em
            NSString *str = [[NSString alloc] initWithFormat:@"%d - %d - %d", field2, field4, field6];
            NSLog(@"%@", str);
            
            NSDictionary *dict = [[NSDictionary alloc] 
                                    initWithObjectsAndKeys:[NSNumber numberWithInt:field2], kNoteAttrTime,
                                                        [NSNumber numberWithInt:field4], kNoteAttrEmoticon,
                                                        [NSNumber numberWithInt:field6], kNoteAttrSleep, nil];
            [arrayResults addObject:dict];
        }
        
        // delete the compiled statement from memory
        sqlite3_finalize(statement);
        
        //NSLog(@"getMoodSleepBetweenDates: Num of rows:%d ; Mood2:%d ; Mood3:%d", rowsCount, mood2Count, mood3Count);
        //NSLog(@"getMoodSleepBetweenDates: Mood4:%d ; Mood5:%d ; Mood6:%d ; Mood7:%d", mood4Count, mood5Count, mood6Count, mood7Count);
        
        // Now, time to be a good Memory Citizen!
        //field2Str = nil;
        //field2 = nil;
        //str = nil;
        
    }
    NSArray *msArray = [[NSArray alloc] initWithArray:arrayResults];
    NSLog(@"DatabaseOperations.getMoodSleepBetweenDates: %d", [msArray count]);
    return msArray;
}



/**
 * Fetches the data that fall between the given dates
 * @param  tableName  NSString  The table from which the data is fetched
 * @param  dateStart  NSDate    The date 'from' which to fetch the data
 * @param  dateEnd    NSDate    The date 'until' which to fetch the data
 * @return NSArray    Array with the count of each mood type between the given dates
 * @created 5th May 2012
 * @sf(read)
 */
-(NSArray *) getDataBetweenDates: (NSString *) tableName 
                          withStartDate: (NSDate *) dateStart
                            withEndDate: (NSDate *) dateEnd {
    
    NSLog(@"getDataBetweenDates: Entered");
    sqlite3_stmt *statement;
    NSMutableArray *arrayResults = [[NSMutableArray alloc] init];
    
    int intStartDate = [Utility getDateAsInt:dateStart];
    int intEndDate   = [Utility getDateAsInt:dateEnd];
    
    NSLog(@"Start date %@ as int: %d", dateStart, intStartDate);
    NSLog(@"End date %@ as int  : %d", dateEnd, intEndDate);
    
    NSString *queryFetch = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE (time >= %d) AND (time <= %d)", tableName, intStartDate, intEndDate];
    
    //NSLog(@"getDataBetweenDates: created query");
    
    // Fetch the data from the table
    if (sqlite3_prepare_v2 ( database, [queryFetch UTF8String], -1, &statement, nil ) == SQLITE_OK) {
        
        //NSLog(@"getDataBetweenDates: prepared stmt");
        
        int field1;
        char *field2;
        NSString *field2Str;
        NSString *str;
        NSInteger rowsCount = 0;
        NSInteger mood2Count = 0;
        NSInteger mood3Count = 0;
        NSInteger mood4Count = 0;
        NSInteger mood5Count = 0;
        NSInteger mood6Count = 0;
        NSInteger mood7Count = 0;
        
        
        // Iterate through the rows
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            //NSLog(@"getDataBetweenDates: stepping thro result");
            
            rowsCount = rowsCount+1;
            
            // Get the value of 'emoticon'
            field1 = sqlite3_column_int(statement, 3);
            //field1Str = [[NSString alloc] initWithUTF8String: field1];
            
            
            switch (field1) {
                    
                case kEmotionHappy:
                    mood2Count = mood2Count + 1;
                    break;
                    
                case kEmotionOverjoyed:
                    mood3Count = mood3Count + 1;
                    break;
                    
                case kEmotionRomantic:
                    mood4Count = mood4Count + 1;
                    break;
                    
                case kEmotionSad:
                    mood5Count = mood5Count + 1;
                    break;
                    
                case kEmotionDepressed:
                    mood6Count = mood6Count + 1;
                    break;
                    
                case kEmotionAngry:
                    mood7Count = mood7Count + 1;
                    break;
                    
                default:
                    break;
            }
            
            // Get the value of 'text'
            field2 = (char *) sqlite3_column_text(statement, 1);
            field2Str = [[NSString alloc] initWithUTF8String: field2];
            
            // Get the 'date'
            //field3 = (char *) sqlite3_column_text(statement, 2);
            //field3Str = [[NSString alloc] initWithUTF8String: field3];
            
            // Display 'em
            str = [[NSString alloc] initWithFormat:@"%d - %@", field1, field2Str];
            //NSLog(@"%@", str);
        }
        
        // delete the compiled statement from memory
        sqlite3_finalize(statement);
        
        NSLog(@"Num of rows:%d ; Mood2:%d ; Mood3:%d", rowsCount, mood2Count, mood3Count);
        NSLog(@"Mood4:%d ; Mood5:%d ; Mood6:%d ; Mood7:%d", mood4Count, mood5Count, mood6Count, mood7Count);
        
        // Now, time to be a good Memory Citizen!
        field2Str = nil;
        field2 = nil;
        str = nil;
        
        return [[NSArray alloc] initWithObjects:
                                        [NSNumber numberWithInteger:(mood2Count)],
                                        [NSNumber numberWithInteger:(mood3Count)],
                                        [NSNumber numberWithInteger:(mood4Count)],
                                        [NSNumber numberWithInteger:(mood5Count)],
                                        [NSNumber numberWithInteger:(mood6Count)],
                                        [NSNumber numberWithInteger:(mood7Count)],
                                        nil];
    }
    return arrayResults;
}

@end
