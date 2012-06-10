//
//  NotificationView.m
//  EmotionalJourney
//
//  Created by Administrator on 08/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationView.h"
#import "Utility.h"

@implementation NotificationView


@synthesize notifyIntervalPicker;
@synthesize remindPeriodKeys;
@synthesize remindTimeKeys;
@synthesize reminderList;
@synthesize table;
@synthesize buttonAddNotification;
@synthesize buttonDeleteNotification;
@synthesize buttonAddThisReminder;
@synthesize labelExistingReminders;
@synthesize labelAddReminder;
@synthesize imageViewExistingReminders;

#define kNotificationInterval       @"notificationinterval"
#define kNotificationTime           @"notificationtime"
#define kExistingNotification       @"existingnotification.plist"
#define kPlistFile                  @"plist"
#define kFieldPeriodicity           @"periodicity"
#define kFieldTime                  @"time"
#define kDateFormat                 @"yyyy-MM-dd HH:mm:ss"
// Periodicity for the notification
#define kPeriodDaily                @"Daily"
#define kPeriodWeekly               @"Weekly"
#define kPeriodFortnightly          @"Fortnightly"
#define kPeriodMonthly              @"Monthly"

#define kComponentInterval          0
#define kComponentTime              1



-(void) initializeView {
    [self loadExistingReminders];
    [self initializeIntervalPicker];
    [self initializeReminderIntervals];
    [self initializeTable];
    self.buttonAddThisReminder.hidden   = YES;
    self.labelAddReminder.hidden        = YES;
    // self.notificationList = [[NSMutableArray alloc] init];
}


/**
 * Loads the list of notification intervals from a plist
 * @created 9th June 2012
 */
-(void) initializeReminderIntervals {
    
    // Initialize notification intervals
    NSString *path = [[NSBundle mainBundle] 
                              pathForResource:kNotificationInterval 
                              ofType:kPlistFile];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    self.remindPeriodKeys = array;
    array = nil;
    int cnt = [self.remindTimeKeys count];   
    NSLog(@"num of keys in notification interval:%d", cnt);

    // Initialize notification time
    path = [[NSBundle mainBundle] 
                      pathForResource:kNotificationTime 
                      ofType:kPlistFile];
    array = [[NSArray alloc] initWithContentsOfFile:path];
    self.remindTimeKeys = array;
    array = nil;
    cnt = [self.remindTimeKeys count];   
    NSLog(@"num of keys in reminder time:%d", cnt);
}


-(void) initializeIntervalPicker {
    NSLog(@"initializeIntervalPicker");
    self.notifyIntervalPicker = 
        [[UIPickerView alloc] 
            initWithFrame:(CGRectMake(40.0,70.0,240.0,70.0))];
    self.notifyIntervalPicker.showsSelectionIndicator = YES;  
    self.notifyIntervalPicker.hidden        = YES;
    self.notifyIntervalPicker.delegate      = self;
    self.notifyIntervalPicker.dataSource    = self;
    [self.notifyIntervalPicker reloadComponent:0];
    [self.view addSubview:self.notifyIntervalPicker];
}


-(void) initializeTable {
    NSLog(@"initializeTable");
    self.table.dataSource   = self;
    self.table.delegate     = self;
    self.table.hidden       = NO;
}


-(IBAction) toggleEdit:(id)sender {
    [self.table setEditing:!self.table.editing animated:YES];
    
    if (self.table.editing) {
        [self.buttonDeleteNotification setTitle:@"Done" forState:UIControlStateNormal];
    } else {
        [self.buttonDeleteNotification setTitle:@"-" forState:UIControlStateNormal];
    }
}


- (IBAction) showAddReminder:(id)sender {
    
    self.notifyIntervalPicker.hidden    = NO;
    self.buttonAddThisReminder.hidden   = NO;
    self.labelExistingReminders.frame   = 
        CGRectMake(10.0,300.0,147.0,21.0);
    self.imageViewExistingReminders.frame =
        CGRectMake(0.0,289.0,320.0,45.0);
    self.buttonAddNotification.frame =
        CGRectMake(220.0,289.0,44.0,44.0);
    self.buttonDeleteNotification.frame =
        CGRectMake(272.0,289.0,44.0,44.0);
    self.table.frame    = 
        CGRectMake(0.0,334.0,320.0,123.0);
    
    self.table.alpha                        = 0.5;
    self.buttonAddNotification.alpha        = 0.5;
    self.buttonDeleteNotification.alpha     = 0.5;
    self.imageViewExistingReminders.alpha   = 0.5;
    self.labelExistingReminders.alpha       = 0.5;
    self.labelAddReminder.hidden            = NO;
}



- (IBAction) addReminder:(id)sender {

    NSString *intervalSelected = [self.remindPeriodKeys 
                    objectAtIndex:[self.notifyIntervalPicker selectedRowInComponent:kComponentInterval]];
    NSString *timeSelected = [self.remindTimeKeys 
                    objectAtIndex:[self.notifyIntervalPicker selectedRowInComponent:kComponentTime]];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:        intervalSelected, kFieldPeriodicity,
        timeSelected,     kFieldTime,
        nil];
    [self.reminderList insertObject:dict atIndex:0];
    NSLog(@"Added notification interval %@ for time %@ ; list count %d",[[self.reminderList objectAtIndex:0] objectForKey:kFieldPeriodicity], timeSelected, [self.reminderList count]);
    [self.table reloadData];
    
    [self persistThisReminder:intervalSelected withTime:timeSelected];
    [self scheduleLocalNotificationForPeriodicity:intervalSelected forTime:[timeSelected intValue]];
    [self reinitializeUIAfterReminderAddition];
    
    // Be a good memory citizen please!
    timeSelected = nil;
    intervalSelected = nil;
    dict = nil;
}



-(void) persistThisReminder:(NSString *)periodicity 
                   withTime:(NSString *)time {
    
    NSString  *plistPath = [NSHomeDirectory() stringByAppendingPathComponent:kExistingNotification];
    if (! [self.reminderList writeToFile:plistPath atomically:YES] ) {
        // @error
        NSLog(@"ERROR: Could not write the reminder to the file!");
    }
}



-(void) reinitializeUIAfterReminderAddition {
    
    self.buttonAddThisReminder.hidden   = YES;
    self.notifyIntervalPicker.hidden    = YES;
    self.labelAddReminder.hidden        = YES;
    
    self.labelExistingReminders.frame   = 
            CGRectMake(9.0,57.0,147.0,21.0);
    self.imageViewExistingReminders.frame =
            CGRectMake(0.0,44.0,320.0,47.0);
    self.buttonAddNotification.frame =
            CGRectMake(220.0,45.0,44.0,44.0);
    self.buttonDeleteNotification.frame =
            CGRectMake(272.0,45.0,44.0,44.0);
    self.table.frame    = CGRectMake(0.0,88.0,320.0,315.0);
    self.table.alpha    = 1.0;
}



-(void) loadExistingReminders {
    
    NSPropertyListFormat format;
    NSString *errorDesc = nil;
    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent:kExistingNotification];
    NSData *plistXML = [[NSFileManager defaultManager] 
                                contentsAtPath:plistPath];
    NSMutableArray *temp = 
        (NSMutableArray *)[NSPropertyListSerialization
            propertyListFromData:plistXML
            mutabilityOption:NSPropertyListMutableContainersAndLeaves
            format:&format 
            errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error when loading existing notifications from plist file. %@", errorDesc);
    }
    self.reminderList = temp;
    if ( (self.reminderList == nil) || ([self.reminderList count] == 0) ) {
        NSLog(@"Initializing reminderList as 'existing reminders' file is empty");
        self.reminderList = [[NSMutableArray alloc] init];
        
    } else {
        NSLog(@"reminderList length: %d", [self.reminderList count]);
    }
    temp = nil;
    [table reloadData];
}



/**
 * Schedules a local notification
 */
-(void) scheduleLocalNotificationForPeriodicity:
                (NSString *) periodicity 
                    forTime:(int) time {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification == nil) {
        return;
    }
    
    NSCalendarUnit *calUnit; 
    if ([periodicity stringByAppendingString:kPeriodDaily]) {
        calUnit = NSDayCalendarUnit;
    } else if ([periodicity stringByAppendingString:kPeriodWeekly]) {
        calUnit = NSWeekCalendarUnit;
    } else if ([periodicity stringByAppendingString:kPeriodMonthly]) {
        calUnit = NSMonthCalendarUnit;
    }
    [notification setRepeatInterval:calUnit];
    [notification setFireDate:[self getDateWithHour:time]];
    [notification setTimeZone:[NSTimeZone defaultTimeZone]];
    notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"Just a local notification", nil)];
    notification.alertAction = NSLocalizedString(@"View Details", nil);
    //notification.soundName = @"glass.wav";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    notification = nil;
}



-(NSDate *) getDateWithHour: (int)hour {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    int year = [components year];
    int month = [components month];
    int day = [components day];
    hour = 10;
    
    NSLog(@"%d %d %d", year, month, day);
    NSString *yearStr   = [NSString stringWithFormat:@"%d", year];
    NSString *monthStr  = [NSString stringWithFormat:@"%d", month];
    NSString *dayStr    = [NSString stringWithFormat:@"%d", day];
    NSString *hourStr   = [NSString stringWithFormat:@"%d", hour];
    NSString *str1      = [yearStr stringByAppendingString:@"-"];
    NSString *str2      = [str1 stringByAppendingString:monthStr];
    NSString *str3      = [str2 stringByAppendingString:@"-"];
    NSString *str4      = [str3 stringByAppendingString:dayStr];
    NSString *str5      = [str4 stringByAppendingString:@" "];
    NSString *str6      = [str5 stringByAppendingString:hourStr];
    NSString *remind    = [str6 stringByAppendingString:@":00:00"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateFormat];
    NSDate *remindOn = [formatter dateFromString:remind];
    NSLog(@"First reminder set on: %@ , str: %@", remindOn, remind);
    return remindOn;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
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
    NSLog(@"NotificationView.viewDidLoad");
    [self initializeView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void) viewDidAppear:(BOOL)animated {
    [self initializeView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark UIPickerViewDelegate methods

- (NSString*)pickerView:(UIPickerView*)pv titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == kComponentInterval) {
        return [self.remindPeriodKeys objectAtIndex:row];
        
    } else {
        return [self.remindTimeKeys objectAtIndex:row];
    }
}



#pragma mark UIPickerViewDataSource methods

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView*)pickerView {
	return 2;
}


- (NSInteger) pickerView:(UIPickerView*)pickerView
            numberOfRowsInComponent:(NSInteger)component {
    
    if (component == kComponentInterval) {
        
        int cnt = [self.remindPeriodKeys count];
        NSLog(@"pickerView component 0 - num of rows:%d",cnt);
        return cnt;
        
    } else {
        int cnt = [self.remindTimeKeys count];
        NSLog(@"pickerView component 1 - num of rows:%d",cnt);
        return cnt;
    }
}


-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *theView = (UILabel *)view;
    if (!theView) {
        theView = [[UILabel alloc] init];
        theView.textColor = [UIColor darkGrayColor];
        theView.font = [UIFont fontWithName:@"Helevetica" size:8.0];
        theView.textAlignment = UITextAlignmentLeft;
    }
    
    if (component == kComponentInterval) {
        theView.frame = CGRectMake(15.0, 0.0, 120.0, 40.0);
        theView.text = [self.remindPeriodKeys objectAtIndex:row];
        
    } else {
        theView.frame = CGRectMake(10.0, 0.0, 40.0, 40.0);
        theView.text = [self.remindTimeKeys objectAtIndex:row];
    }
    
    return theView;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row 
       inComponent:(NSInteger)component {
    
    int selectedIndex = [pickerView selectedRowInComponent:component];
    NSInteger selection = row;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component){
        case kComponentInterval: 
            return 130.0f;
        case kComponentTime: 
            return 50.0f;
    }
    return 0.0f;
}



#pragma mark -
#pragma mark Table Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection table : %d",[self.reminderList count]);
    return [self.reminderList count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *NotificationCellIdentifier = @"NotificationCellIdentifier";
    UITableViewCell *cell = 
        [tableView dequeueReusableCellWithIdentifier: NotificationCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NotificationCellIdentifier];
    }
    NSInteger row = [indexPath row];
    NSDictionary *dict = [self.reminderList objectAtIndex:row];
    NSString *interval = [dict objectForKey:kFieldPeriodicity];
    NSString *time = [dict objectForKey:kFieldTime];
    NSArray *array = [[NSArray alloc] initWithObjects:@"Periodicity:", interval, @" Time:", time, @"hrs", nil];
    NSString *reminderStr = [Utility concatenateStringsInArray:array];
    cell.textLabel.text = reminderStr;
    cell.textLabel.font = [UIFont fontWithName:@"Helevetica" size:10.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    NSLog(@"NotificationView.cellForRowAtIndexPath: returning text %@ for row %d", [self.reminderList objectAtIndex:row], row);
    return cell;
}




#pragma mark -
#pragma mark Table View Data Source Methods 

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    [self.reminderList removeObjectAtIndex:row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
