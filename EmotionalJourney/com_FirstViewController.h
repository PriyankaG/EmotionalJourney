//
//  com_FirstViewController.h
//  EmotionalJourney
//
//  Created by Administrator on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeScroller.h"
#import "AwesomeMenu.h"
#import "AwesomeMenuItem.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "NoteEntryView.h"
#import "PictureView.h"


@class NoteEntryView;


/**
 * Controller class for the First/Home View in the App
 * UITableViewDelegate, UITableViewDataSource : For the table which displays the user text
 * TimeScrollerDelegate: for the time/clock that shows the time dynamically as the screen is scrolled
 * UIImagePickerControllerDelegate, UINavigationControllerDelegate : For the image/video selection
 */
@interface com_FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, 
    TimeScrollerDelegate, 
    AwesomeMenuDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    UIActionSheetDelegate,
    UITextFieldDelegate,
    MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,
    UIPickerViewDelegate, UIPickerViewDataSource, 
    UITextViewDelegate,
    UIApplicationDelegate> {
    
    UITableView *table;
    NSMutableArray *arrayInput;
    NSMutableDictionary *dictionary;
    //UIScrollView *scrollView;
    TimeScroller * _timeScroller;
    int sleptWell;
}

@property (nonatomic, retain) IBOutlet NoteEntryView *noteEntryView;
@property (nonatomic, retain) IBOutlet UIImageView *backdrop;

@property (nonatomic, retain) IBOutlet UIView *animatedSubview;

// Table View
@property (nonatomic, retain) IBOutlet UITableView *table;

// Buttons representing Emotions
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionHappy;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionOverjoyed;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionRomantic;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionSad;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionDepressed;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionAngry;

//@property (nonatomic, retain) IBOutlet AwesomeMenuItem *menuItem1;
//@property (nonatomic, retain) IBOutlet AwesomeMenuItem *menuItem2;
//@property (nonatomic, retain) IBOutlet AwesomeMenuItem *menuItem3;
//@property (nonatomic, retain) IBOutlet AwesomeMenuItem *menuItem4;


// The magical time/clock :)
@property (nonatomic, retain)               TimeScroller            *_timeScroller;

// For the image / video selection feature
@property (nonatomic, strong)               UIImage                 *image;
@property (nonatomic, strong)               NSString                *text;
@property (nonatomic, assign)               CGRect                  imageFrame;
@property (nonatomic, strong)               MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong)               NSURL *movieURL;
@property (nonatomic, copy)                 NSString *lastChosenMediaType;
@property (nonatomic, retain)               MFMailComposeViewController *mailComposer;
@property (nonatomic, retain)               NSString *user;
@property (nonatomic, retain)               NSString *initialLabelText;

// User input text
@property (nonatomic, retain)   IBOutlet    NSArray *arrayInput;
// Dictionary to hold user inputs on emotions
@property (nonatomic, retain)   IBOutlet    NSMutableDictionary *dictionary;
@property (strong, nonatomic)   IBOutlet    UIPickerView *noteTextPicker;
@property (nonatomic, weak)     IBOutlet    UIImageView *imageView;

@property (nonatomic, retain)               NSDictionary    *commonNotesDict;
@property (nonatomic, retain)               NSArray         *commonNotesKeys;
@property (nonatomic, retain)               PictureView     *picFrameView;


// Initializes the NoteTextPicker, a custom picker object
-(void) initializeNoteTextPicker;
-(void) initializeCommonNotes;
-(void) initializeTextWriting;

// Triggered when the user presses the button to persist the input
-(IBAction) buttonPenThisPressed:(id)sender;
-(IBAction) buttonWritePressed:(id)sender;
-(IBAction) buttoCameraPressed:(id)sender;
-(IBAction) buttonCancelPressed:(id)sender;
// Triggered when the user taps anywhere in the bakground of the app
// This method will, in consequence, in order to dismiss the keypad
-(IBAction)backgroundTapped:(id)sender;
-(IBAction)textBeingEntered:(id)sender;
-(IBAction)history:(id)sender;
-(IBAction)textFieldEditingDone:(id)sender;
-(IBAction)sleepCheckBoxTapped:(id)sender;

// Triggered when the user chooses to shoot a pic/video with the device cam
//-(IBAction) shootPicOrVideo:(id)sender;
// Trigerred when the user chooses to select form already-existing pics or videos in the device
//-(IBAction)selectExistingPicOrVideo:(id)sender;
-(void)addPicOrVideo;

//-(void)labelTouched;
-(void)resetNoteViewElements;
// Adds the user's input to a data structure for persistence
-(void) addToInputArrayWithPicName: (NSString *) picName;
// Called once the user inputs data.This'll take care of the workflow after that point of time
-(void) actOnUserInput;
// Called when the app is started, in order to load the historical inputs of the user from persistent store
-(void) loadEarlierConversation;
// Schedules the local notification
-(void) scheduleLocalNotification;
-(void) expressedEmotion: (int)emotionCode;
-(void) loadNoteView;
-(void) initializeNoteView;
-(void) loadEmoticonNoteView;
-(void) initializeEmoticonNoteView;
-(void) resizeToEmoticonNoteView;
// For the 'add the photo / video' feature
- (void)updateDisplay;
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;
// Called when the user is done with entering the text in the text-field
-(void) saveText;
-(int) getSleepValue;
-(void)showEmailComposerWithText:(NSString *)text
                     withEmoticon:(UIImage *)emoticon
                     withPicture:(UIImage *)picture;
-(void) displayComposerSheetWithText:(NSString *) text
                         withEmoticon:(UIImage *) emoticon
                         withPicture:(UIImage *) picture;
-(void)launchMailAppOnDevice;
-(void) initializeEmoticonsMenu;
-(UIImage *) getEmoticonForCode: (int) emoticonCode;

-(void) animateBounce:(UIView *)view
                        withX:(float)xVal
                        withY:(float)yVal
                        withWd:(float)wdVal
                        withHt:(float)htVal
                        withDuration:(float)duration;

-(void) displayFullPic: (UIImage *)img;
-(void) testThis;

@end

