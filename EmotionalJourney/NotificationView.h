//
//  NotificationView.h
//  EmotionalJourney
//
//  Created by Administrator on 08/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationView : UIViewController <
            UIPickerViewDelegate,   UIPickerViewDataSource, 
            UITableViewDelegate,    UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView    *notifyIntervalPicker;
@property (strong, nonatomic) IBOutlet UITableView     *table;
@property (strong, nonatomic) IBOutlet UIButton        *buttonAddNotification;
@property (strong, nonatomic) IBOutlet UIButton        *buttonDeleteNotification;
@property (strong, nonatomic) IBOutlet UIButton        *buttonAddThisReminder;
@property (strong, nonatomic) IBOutlet UIImageView      *imageViewExistingReminders;
@property (strong, nonatomic) IBOutlet UILabel          *labelExistingReminders;
@property (strong, nonatomic) IBOutlet UILabel          *labelAddReminder;

@property (nonatomic, retain) NSArray           *remindPeriodKeys;
@property (nonatomic, retain) NSArray           *remindTimeKeys;
@property (strong, nonatomic) NSMutableArray    *reminderList;

// Action Methods
- (IBAction) toggleEdit:        (id)sender;
- (IBAction) showAddReminder:   (id)sender;
- (IBAction) addReminder:       (id)sender;

// Initialization Methods
-(void) initializeView;
-(void) initializeIntervalPicker;
-(void) initializeTimePicker;
-(void) initializeTable;
-(void) initializeReminderIntervals;

-(void) loadExistingReminders;
-(void) persistThisReminder: (NSString *) periodicity
                   withTime: (NSString *) time;
-(void) reinitializeUIAfterReminderAddition;
-(void) scheduleLocalNotificationForPeriodicity: (NSString *) periodicity forTime: (int) time;
-(NSDate *) getDateWithHour: (int)hour;

@end
