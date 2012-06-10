//
//  com_FirstViewController.m
//  EmotionalJourney
//
//  Created by Administrator on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "com_FirstViewController.h"
#import "com_SecondViewController.h"
#import "DatabaseOperations.h"
#import "Utility.h"
#import "TimeScroller.h"
#import "EmotionNoteTableCell.h"
#import "ImageNoteTableCell.h"
#import "TextNoteTableCell.h"

@class NoteEntryView;

#define kEmotionHappy               1
#define kEmotionOverjoyed           2
#define kEmotionRomantic            3
#define kEmotionSad                 4
#define kEmotionDepressed           5
#define kEmotionAngry               6
// basic emotions : joy, sadness, anger, fear, surprise and disgust

#define kActPhoto                   0
#define kActText                    1
#define kActEmoticon                2
#define kActPerson                  3

#define kSleptWell                  1
#define kDidntSleepWell             0

// Height for various cell types
#define kEmotionNoteCellHt          290.0
#define kImageNoteCellHt            226.0
#define kTextNoteCellHt             120.0

// For cell type 'ImageNoteCell'
#define kImageNoteImageViewX        73.0
#define kImageNoteImageViewY        24.0
#define kImageNoteImageViewWd       130.0
#define kImageNoteImageViewHt       130.0
#define kImageNoteFrameX            54.0
#define kImageNoteFrameY            8.0
#define kImageNoteFrameWd           256.0
#define kImageNoteFrameHt           188.0


// For cell type 'EmotionNoteCell'
#define kEmotionNoteImageViewX      73.0
#define kEmotionNoteImageViewY      71.0
#define kEmotionNoteImageViewWd     130.0
#define kEmotionNoteImageViewHt     130.0
#define kEmotionNoteFrameX          54.0
#define kEmotionNoteFrameY          8.0
#define kEmotionNoteFrameWd         256.0
#define kEmotionNoteFrameHt         247.0


// For the cell type 'TextNoteCell'
#define kTextNoteImageViewX         54.0
#define kTextNoteImageViewY         7.0
#define kTextNoteImageViewWd        256.0
#define kTextNoteImageViewHt        78.0
//#define kTextNotePersonPicWd      43.0
//#define kTextNotePersonPicHt      47.0


// For the Emoticons' Menu
#define kEmoticonsMenuX           13.0
#define kEmoticonsMenuY           33.0
#define kEmoticonsMenuWd          20.0
#define kEmoticonsMenuHt          20.0
#define kEmoticonsMenuAnimDur     0.2

// For the Live Note
#define kNoteViewX                0.0
#define kNoteViewY                44.0
#define kNoteViewWd               320.0
#define kNoteViewHt               307.0
#define kNoteImageX               0.0
#define kNoteImageY               0.0
#define kNoteImageWd              320.0
#define kNoteImageHt              307.0

#define kPicLiveWd                67.0
#define kPicLiveHt                67.0

#define kPicBorderWdSmall          1.0
#define kPicBorderWdBig            2.0
#define kPicCornerRadiusSmall      10.0
#define kPicCornerRadiusBig        20.0


// For the small note which shows just the emoticon
#define kSmallNoteX                 0.0
#define kSmallNoteY                 0.0
#define kSmallNoteWd                320.0
#define kSmallNoteHt                50.0

#define kSmallNoteYForMainView      43.0

// For the small and big views of the table
#define kTableSmallX                0.0
#define kTableSmallY                364.0
#define kTableSmallWd               320.0
#define kTableSmallHt               40.0

#define kTableBigX                  0.0
#define kTableBigY                  93.0
#define kTableBigWd                 320.0
#define kTableBigHt                 440.0


// Note View Animations

// Small to big note view
#define kNoteBigX                   0.0
#define kNoteBigY                   0.0
#define kNoteBigWd                  320.0
#define kNoteBigHt                  321.0
#define kNoteBigImage               @"Background_White_HorizontalTexture_320-350.png"

// For the Common Notes' Picker
#define kCommonNotes                @"thecommonnotes"
#define kPlistFile                  @"plist"
#define kCategoryComponent          0
#define kNotesComponent             1

#define kTextFieldLimit             35.0

#define kTableName                  @"emotionrrys"

//#define DUMMY_PERSON_PIC          @"DummyPersonPic.png"
#define DUMMY_PIC                   @"ImageView_Camera.png"
#define DUMMY_EMOTICON              @"DummyEmoticon.png"
#define DUMMY_TEXT                  @"How do I feel now?"
#define ICON_EMOTICON_HAPPY         @"Emoticon_Red_Happy.png"
#define ICON_EMOTICON_OVERJOYED     @"Emoticon_Red_Overjoyed.png"
#define ICON_EMOTICON_ROMANTIC      @"EmoticonRomantic.png"
#define ICON_EMOTICON_SAD           @"EmoticonSad.png"
#define ICON_EMOTICON_DEPRESSED     @"EmoticonDepressed.png"
#define ICON_EMOTICON_ANGRY         @"EmoticonAngry.png"
#define BUTTON_HISTORY              @"Button_History_Red.png"
#define BUTTON_SLEEP_UNSELECTED     @"Button_CheckBox.png"
#define BUTTON_SLEEP_SELECTED       @"Button_Check_Red_Right.png"
#define BUTTON_PENTHIS_ENABLED      @"Button_Red_Round_Tick.png"
#define BUTTON_PENTHIS_DISABLED     @"Button_Grey_Round_Tick.png"
#define BUTTON_CANCEL_ENABLED       @"Button_Red_Round_X.png"
#define BUTTON_CANCEL_DISABLED      @"Button_Grey_Round_X.png"

#define BUTTON_WRONF
//#define BUTTON_RESET_ENABLED        @"Button_Reset_Red.png"
//#define BUTTON_RESET_DISABLED       @"Button_Reset_Grey.png"

#define kEmptyString                @""




@implementation com_FirstViewController

@synthesize noteEntryView;
@synthesize animatedSubview;
@synthesize table;
@synthesize buttonEmotionHappy;
@synthesize buttonEmotionOverjoyed;
@synthesize buttonEmotionRomantic;
@synthesize buttonEmotionSad;
@synthesize buttonEmotionDepressed;
@synthesize buttonEmotionAngry;
@synthesize arrayInput;
@synthesize dictionary;
@synthesize imageView;
@synthesize imageFrame;
@synthesize image;
//@synthesize personPic;
@synthesize text;
@synthesize moviePlayer;
@synthesize movieURL;
@synthesize lastChosenMediaType;
@synthesize mailComposer;
@synthesize _timeScroller;
@synthesize user;
@synthesize backdrop;
@synthesize initialLabelText;
@synthesize noteTextPicker;
@synthesize commonNotesDict;
@synthesize commonNotesKeys;
@synthesize picFrameView;


int myEmotionNum;
/*
 * 0 => No-op mode (reset/init value)
 * 1 => Photo Selection Mode
 * 2 => Person Selection Mode
 */
// int picCode;
int currentTime;
int rowHasPicture;
DatabaseOperations *dbOps;
UILocalNotification *notification;
static UIImage *shrinkImage(UIImage *original, CGSize size);


/**
 * Called when the button's pressed
 * sender : the button which's pressed, consequently invoking this
 */
-(IBAction) buttonPenThisPressed:(id)sender {
        
    NSLog(@"buttonPenThisPressed: begin");
    NSLog(@"buttonPenThisPressed:self.text: %@", self.text);

    // Reset everything please!!!
    // Re-initialize the 'Live Note' with placeholders
    self.noteEntryView.textLive.text = DUMMY_TEXT;
    // self.noteEntryView.personPicLive.image = [UIImage imageNamed:DUMMY_PERSON_PIC];
    self.noteEntryView.emoticonLive.image = [UIImage imageNamed:DUMMY_EMOTICON];
    [self actOnUserInput];
    
    [self loadEmoticonNoteView];
    NSLog(@"buttonPenThisPressed: end");
}



/**
 * Triggered when the 'Cancel' button's pressed
 * @created 25th May 2012
 */
-(IBAction)buttonCancelPressed:(id)sender {
    [self resetNoteViewElements];
    // self.noteEntryView.buttonCancel.hidden = YES;
    [self loadEmoticonNoteView];
}



/**
 * Triggered when the 'Reset' button's pressed
 * @created 25th May 2012
 */
/*
 -(IBAction)buttonResetPressed:(id)sender {
    
    [self resetNoteViewElements];
}

*/

-(void) resetNoteViewElements {
    self.noteEntryView.textFieldUserInput.text  = kEmptyString;
    self.noteEntryView.textLive.text            = DUMMY_TEXT;
    self.noteEntryView.picLive.image            = [UIImage imageNamed:DUMMY_PIC];
    self.noteEntryView.emoticonLive.image       = nil;
    self.noteEntryView.buttonReset.enabled      = NO;
}


/**
 * Called after the user has selected an emoticon.
 * This loads the rest of the add-in's (like text,pic) that can be associated with the note.
 * @created 19th May 2012 
 */
-(void) expressedEmotion: (int)emotionCode {
    
    myEmotionNum = emotionCode;
    
    switch (emotionCode) {

        case kEmotionHappy: {
            NSLog(@"Am happy");
            myEmotionNum = kEmotionHappy;
            noteEntryView.emoticonLive.image = [UIImage imageNamed:ICON_EMOTICON_HAPPY];
            break;
        } 
            
        case kEmotionOverjoyed: {
            NSLog(@"Am overjoyed");
            myEmotionNum = kEmotionOverjoyed;
            noteEntryView.emoticonLive.image = [UIImage imageNamed:ICON_EMOTICON_OVERJOYED];
            break;
        } 
            
        case kEmotionRomantic: {
            NSLog(@"Am feeling romantic");
            myEmotionNum = kEmotionRomantic;
            noteEntryView.emoticonLive.image = [UIImage imageNamed:ICON_EMOTICON_ROMANTIC];
            break;
        } 
            
        case kEmotionSad: {
            NSLog(@"Am sad");
            myEmotionNum = kEmotionSad;
            noteEntryView.emoticonLive.image = [UIImage imageNamed:ICON_EMOTICON_SAD];
            break;
        } 
            
        case kEmotionDepressed: {
            NSLog(@"Am feeling depressed");
            myEmotionNum = kEmotionDepressed;
            noteEntryView.emoticonLive.image = [UIImage imageNamed:ICON_EMOTICON_DEPRESSED];
            break;
        } 
            
        case kEmotionAngry: {
            NSLog(@"Am angry");
            myEmotionNum = kEmotionAngry;
            noteEntryView.emoticonLive.image = [UIImage imageNamed:ICON_EMOTICON_ANGRY];
            break;
        } 
            
        // @logicalerror
        default: {
            NSLog(@"ERROR: Invalid emoticon chosen!");
            break;
        }
    }        
    
    [self loadNoteView];
    //[self initializeNoteView];
    
    /*
    [UIView transitionWithView:emoticonsView
                      duration:1.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ 
                        self.emoticonsView.hidden = YES;                          
                        self.awesomeMenu.hidden = NO;
                    }  
                    completion:NULL]; 
     */
    //[textFieldUserInput becomeFirstResponder];
            
            
    noteEntryView.emoticonLive.contentMode = UIViewContentModeScaleAspectFit;
}



/**
 * Loads the note view, wherein the user can select additional details, if required,
 * to add to the Emotion-Note
 * The 'Viswaroopa effect' ! ;)
 * @created 19th May 2012
 */
-(void) loadNoteView {
    
    self.noteEntryView.liveNoteImageSmall.image     = [UIImage imageNamed:kNoteBigImage];
    self.noteEntryView.emoticonsMenu.hidden         = YES;
    
    [UIView transitionWithView:self.noteEntryView.liveNoteViewSmall
                    duration:0.7
                    options:UIViewAnimationOptionCurveLinear
                    animations:^{ 
                        //self.noteEntryView.liveNoteImageSmall.transform = 
                          // CGAffineTransformMakeScale(1.0f, 5.6f);
                        self.noteEntryView.liveNoteViewSmall.frame = 
                                CGRectMake(kNoteBigX, kNoteBigY, 
                                           kNoteBigWd,kNoteBigHt);

                        self.noteEntryView.liveNoteImageSmall.frame =
                                CGRectMake(kNoteBigX, kNoteBigY, 
                                           kNoteBigWd,kNoteBigHt);
                        // Make the table view small
                        self.table.frame = 
                        CGRectMake(kTableSmallX, kTableSmallY, kTableSmallWd, kTableSmallHt);

                    }  
                    completion:^(BOOL finished){
                       [self initializeNoteView];
                    }];
}



/**
 * Initializes the note view
 * @created May2012
 */
-(void) initializeNoteView {

    // Initialize the 'Live Note' with placeholders
    
    // TO HIDE
    self.noteEntryView.liveNoteViewSmall.hidden     = YES;
    self.noteEntryView.liveNoteImageSmall.hidden    = YES;
    self.backdrop.hidden = YES;
    self.noteEntryView.emoticonsMenu.hidden         = YES;
    
    // IT'S SHOW TIME, FOLKS! :)
    self.noteEntryView.frame  = 
            CGRectMake(kNoteViewX, kNoteViewY, kNoteViewWd, kNoteViewHt);
    self.noteEntryView.liveNoteViewBig.frame = 
            CGRectMake(kNoteImageX, kNoteImageY, kNoteImageWd, kNoteImageHt);
    self.table.frame = 
            CGRectMake(kTableSmallX, kTableSmallY, kTableSmallWd, kTableSmallHt);
    self.noteEntryView.textFieldUserInput.delegate  = self;
    self.noteEntryView.textLive.text                = DUMMY_TEXT;

    self.noteEntryView.liveNoteViewBig.hidden       = NO;
    self.noteEntryView.picLive.hidden               = NO;
    // self.noteEntryView.personPicLive.hidden = NO;
    self.noteEntryView.emoticonLive.hidden          = NO;
    self.noteEntryView.buttonPenThis.hidden         = NO;
    self.noteEntryView.buttonCamera.hidden          = NO;
    self.noteEntryView.buttonCancel.hidden          = NO;
    self.noteEntryView.buttonSleep.hidden           = NO;
    self.noteEntryView.labelSleep.hidden            = NO;
    self.noteEntryView.buttonCancel.enabled         = YES;
    self.noteEntryView.buttonSleep.imageView.image  = [UIImage imageNamed:BUTTON_SLEEP_UNSELECTED];
    self.noteEntryView.buttonPencil.hidden          = NO;
    sleptWell = kDidntSleepWell;
    
    [self initializeTextWriting];
}



/**
 * Loads the small view which just allows for emoticon selection
 * Animates this change (reverse-Viswaroopa effect! ;) )
 */
-(void) loadEmoticonNoteView {
    
    [self initializeEmoticonNoteView];
    [UIView transitionWithView:self.noteEntryView.liveNoteViewBig
                      duration:0.7
                       options:UIViewAnimationCurveLinear
                    animations:^{ 
                        self.noteEntryView.liveNoteViewBig.frame =
                                CGRectMake(kSmallNoteX, kSmallNoteYForMainView, 
                                           kSmallNoteWd,kSmallNoteHt);
                        self.noteEntryView.frame = 
                                CGRectMake(kSmallNoteX, kSmallNoteYForMainView, 
                                           kSmallNoteWd, kSmallNoteHt);
                         
                        self.table.frame = 
                                CGRectMake(kTableBigX, kTableBigY, 
                                           kTableBigWd, kTableBigHt);
                    }  
                    completion:^(BOOL finished){
                    }];
    [self resizeToEmoticonNoteView];
    
   /* [UIView transitionWithView:self.noteEntryView.liveNoteViewSmall
                      duration:1.0
                       options:UIViewAnimationOptionCurveLinear
                    animations:^{ 
                        //self.noteEntryView.liveNoteImageSmall.transform = 
                        // CGAffineTransformMakeScale(1.0f, 5.6f);
                        self.noteEntryView.liveNoteViewSmall.frame = 
                            CGRectMake(kNoteBigX, kNoteBigY, 
                                   kNoteBigWd,kNoteBigHt);
                        
                        self.noteEntryView.liveNoteImageSmall.frame =
                        CGRectMake(kNoteBigX, kNoteBigY, 
                                   kNoteBigWd,kNoteBigHt);
                        // Make the table view small
                        self.table.frame = 
                        CGRectMake(kTableSmallX, kTableSmallY, kTableSmallWd, kTableSmallHt);
                        
                    }  
                    completion:^(BOOL finished){
                        [self initializeNoteView];
    */
}



/**
 * Makes the big-note-view go away
 * & initializes the small-note-view, which has just the emoticon
 * @created 22nd May 2012
 */
-(void) initializeEmoticonNoteView {
    
    NSLog(@"initializeEmoticonNoteView:begin");
    
    // Hide 'em!
    self.noteEntryView.liveNoteViewBig.hidden       = YES;
    self.noteEntryView.textLive.hidden              = YES;
    self.noteEntryView.picLive.hidden               = YES;
    self.noteEntryView.textFieldUserInput.hidden    = YES;
    self.noteEntryView.buttonSaveText.hidden        = YES;
    self.noteEntryView.buttonPenThis.hidden         = YES;
    self.noteEntryView.buttonCancel.hidden          = YES;
    //self.noteEntryView.buttonReset.hidden           = YES;
    self.noteEntryView.buttonCamera.hidden          = YES;
    self.noteEntryView.buttonPencil.hidden          = YES;
    self.noteEntryView.textBorderImage.hidden       = YES;
    self.noteTextPicker.hidden                      = YES;
    self.noteEntryView.labelSleep.hidden            = YES;
    self.noteEntryView.buttonSleep.hidden           = YES;
    self.noteEntryView.emoticonLive.hidden          = YES;
    
    // Show 'em!!!
    self.noteEntryView.liveNoteViewSmall.hidden     = NO;
    self.noteEntryView.liveNoteImageSmall.hidden    = NO;
    self.noteEntryView.emoticonsMenu.hidden         = NO;

    NSLog(@"initializeEmoticonNoteView: end");
}



-(void) resizeToEmoticonNoteView {
    
    self.noteEntryView.frame = 
                    CGRectMake(kSmallNoteX, kSmallNoteYForMainView, 
                               kSmallNoteWd, kSmallNoteHt);
    self.noteEntryView.liveNoteViewSmall.frame =
                    CGRectMake(kSmallNoteX, kSmallNoteY, kSmallNoteWd, kSmallNoteHt);
    self.noteEntryView.liveNoteImageSmall.frame =
                    CGRectMake(kSmallNoteX, kSmallNoteY, kSmallNoteWd, kSmallNoteHt);
    self.table.frame = 
                    CGRectMake(kTableBigX, kTableBigY, kTableBigWd, kTableBigHt);
}



/**
 * Loads the list of common notes (under various categories like 'Family', 'Work', etc
 * from a plist
 * @created 25th May 2012
 */
-(void) initializeCommonNotes {
    
    NSString *path = [[NSBundle mainBundle] 
                      pathForResource:kCommonNotes 
                      ofType:kPlistFile];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.commonNotesDict = dict;
    dict = nil;
    int cnt = [[commonNotesDict allKeys] count];   
    NSLog(@"num of keys in common notes:%d", cnt);
    NSArray *array = [[self.commonNotesDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    self.commonNotesKeys = array;
    array = nil;
}


-(IBAction) backgroundTapped:(id)sender {
    NSLog(@"background tapped");
    [self.noteEntryView.textFieldUserInput resignFirstResponder];
}


/**
 * Method that will act on the user input, once the button's pressed.
 * 1. This updates the UI to reflect user's entry.
 * 2. Persists the data into the database
 *
 * @created Apr 23, 2012
 */
-(void) actOnUserInput {
    
    NSLog(@"actOnUserInput:start");
    
    NSString *pictureName = nil;
    if (self.image != nil) {
        NSLog(@"actOnUserInput: User input has an image");
        pictureName = [Utility storeImageLocally:self.image];
    }
    /* if (self.personPic != nil) {
        NSLog(@"actOnUserInput: User input has a person-pic");
         NSLog(@"actOnUserInput:self.personpic:%f", self.personPic.size.height);
    }
    */
    // Add the user input to the in-memory data structure 'arayInput'
    // and also persist the new note/record into the DB
    [self addToInputArrayWithPicName:[pictureName copy]];
    [dbOps insertRecordIntoTableNamed:kTableName
                           withField1:@"user" field1Value:@""
                           withField2:@"time" field2Value:currentTime 
                           withField3:@"text" field3Value:self.text
                           withField4:@"emoticon" field4Value:myEmotionNum
                           withField5:@"picture" field5Value:[pictureName copy]
                           withField6:@"sleep" field6Value:self.getSleepValue];
   
    NSLog(@"actOnUserInput: inserted rec in db");
    // [dbOps getAllRowsFromTableNamed:kTableName];
    
    [table reloadData];
    
    // Reset everything please!!! Reminents aren't any good!
    self.image = nil;
    myEmotionNum = -1;
    self.text = nil;
    NSLog(@"actOnUserInput:end");
}



/**
 * Adds the user input to a dictionary
 */
-(void) addToInputArrayWithPicName:(NSString *)picName {
    
    NSLog(@"addToInputArray:start");

    NSDate *now = [NSDate date];
    currentTime = [Utility getDateAsInt:now];
    NSLog(@"addToInputArray: currentTime = %d", currentTime);
    NSLog(@"addToInputArray: currentTime converted: %@", [Utility getIntAsDate:currentTime]);
    
    NSString *currentText = self.text;
    if ((currentText == nil) || (currentText == NULL) || (currentText.length == 0)) {
        currentText = kEmptyString;
    }
    int emoticonCode = myEmotionNum;    

    // TODO @user - user value is empty for now
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
        @"",                                         @"user",
        [NSNumber numberWithInt:currentTime],        @"time",
        currentText,                                 @"text", 
        [NSNumber numberWithInt:emoticonCode],       @"emoticon", 
        picName,                                     @"picture",
        sleptWell,                                   @"sleep",
        nil];
    [arrayInput insertObject:dict atIndex:0];
    NSLog(@"addToInputArray: Added '%@' - %d -%@ - %d to User-Input-Array", 
          [[arrayInput objectAtIndex:0] objectForKey:@"text"],
          [[[arrayInput objectAtIndex:0] objectForKey:@"emoticon"] intValue],
          [[arrayInput objectAtIndex:0] objectForKey:@"picture"],
          [[[arrayInput objectAtIndex:0] objectForKey:@"sleep"] intValue]);
    
    if (self.image != nil) {
        NSLog(@"addToInputArray: This note has a pic");
    } else {
        NSLog(@"addToInputArray: This note does not have a pic");
    }
    /*
     if (self.personPic != nil) {
        NSLog(@"addToInputArray: This note has a person-pic");
        NSLog(@"addToInputArray:self.personpic:%f", self.personPic.size.height);
    } else {
        NSLog(@"addToInputArray: This note does not have a person-pic");
    }
    */
    dict = nil;
    NSLog(@"addToInputArray:end");

}



/**
 * Loads the user's data, stored in earlier visits
 * @created 24th Apr 2012
 */
-(void) loadEarlierConversation {
    NSLog(@"Loading earlier conversations");
    NSMutableArray *array = [dbOps getAllRowsFromTableNamed:kTableName];
    NSLog(@"loadEarlierConversation: Array size:%d", [array count]);
    self.arrayInput = [[NSMutableArray alloc] initWithArray:array];
    [table reloadData];
}



/**
 * Triggered when the sleep check box is toggled
 * Sets it to the opposite oif the current state
 *
 * @created 27th May 2012
 */
-(IBAction)sleepCheckBoxTapped:(id)sender {
    
    self.noteEntryView.buttonSleep.selected = !self.noteEntryView.buttonSleep.selected;
    
    if (sleptWell == kDidntSleepWell) {
        sleptWell = kSleptWell;
        NSLog(@"User set the sleep param to 'slept well'");
        
    } else {
        sleptWell = kDidntSleepWell;
    }
}

          
-(int) getSleepValue {
    return sleptWell;
}

     
/**
 * Schedules a local notification
 */
-(void) scheduleLocalNotification {
    
    notification = [[UILocalNotification alloc] init];
    if (notification == nil) {
        return;
    }
    [notification setFireDate:[[NSDate date] dateByAddingTimeInterval:60]];
    [notification setTimeZone:[NSTimeZone defaultTimeZone]];
    notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"Just a local notification", nil)];
    notification.alertAction = NSLocalizedString(@"View Details", nil);
    //notification.soundName = @"glass.wav";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


/**
 * Method that's called (automatically) soon after the modal window 
 * (action sheet) is shown and the user chooses one of the buttons.
 * The modal window is shown when the user chooses to add a image/video
 */
-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSLog(@"Clicked button index: %d", buttonIndex);
    
    if (buttonIndex == 1) {
        NSLog(@"The user wants to choose from existing photo library");
        [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];

    } else if (buttonIndex == 2) {
        NSLog(@"The user wants to shoot a picture right now");
        [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];

    }
    
    else if (buttonIndex == [actionSheet cancelButtonIndex]) { // index 0
        NSLog(@"User chose to cancel adding a video/pic");
    }
    
    // [self updateDisplay];
}



/**
 * Method to add a pic or video to the emotion-note
 * @created May 2012
 */
-(void)addPicOrVideo {
    
    // picCode = code;
    NSLog(@"addPicOrVideo: The user has chosen to add a pic/video");
    self.image = nil;
    imageFrame = [imageView frame];
    
    // TODO : for now, let's support only photo. 
    // video-support can be added later
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:@"Capture your moment with a photo"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"Add an existing picture"];
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:@"Capture one right now"];
    }
    [actionSheet showFromRect:CGRectMake(28.0, 58.0, 67.0, 67.0) inView:self.noteEntryView animated:YES];
}



-(IBAction)buttoCameraPressed:(id)sender {
       
    [self addPicOrVideo];
}



/**
 * This can be called from viewDidAppear
 * is called both when the view is first created and 
 * then again after the user picks an image or video and dismisses the image picker.
 * Because of this dual usage, it needs to make a few checks to see what's what 
 * and set up the GUI accordingly. The MPMoviePlayerController doesn't let us change the URL it reads from, 
 * so each time we want to display a movie, we'll need to make a new controller. All of that is handled here. 
 */
// TODO: disabled for now as the support is only for photo (not video) now
- (void)updateDisplay {
    
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        imageView.image = image;
        imageView.hidden = NO; 
        moviePlayer.view.hidden = YES;
        
    } else if ([lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]) { 
    
        [self.moviePlayer.view removeFromSuperview]; 
        self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        moviePlayer.view.frame = imageFrame; 
        moviePlayer.view.clipsToBounds = YES; 
        [self.view addSubview:moviePlayer.view]; 
        imageView.hidden = YES;
    } 
}



/**
 * This is the one that both of our action methods call.
 * It creates and configures an image picker, using the passed-in sourceType 
 * to determine whether to bring up the camera or the media library.
 */
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType { 

    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && ([mediaTypes count] > 0)) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    
    } else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Error accessing media"
                              message:@"Device doesn't support the media source"
                              delegate:nil
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:nil];
        [alert show];
    }
}



/**
 * Intializes the spring-like menu
 * @created  
 */
/*
-(void) initializeSpringMenu {
    NSLog(@"InitializeSpringMenu: entered");
    UIImage *imageAddPhoto    = [UIImage imageNamed:@"Button_Pic.png"];
    UIImage *imageAddPerson   = [UIImage imageNamed:@"Button_Person.png"];
    UIImage *imageAddText     = [UIImage imageNamed:@"Button_Text.png"];
    UIImage *imageAddEmoticon = [UIImage imageNamed:@"Button_Emoticon.png"];

    menuItem1 = [[AwesomeMenuItem alloc] 
                            initWithImage:imageAddPhoto
                            highlightedImage:nil
                            ContentImage:imageAddPhoto
                            highlightedContentImage:nil];
    menuItem2 = [[AwesomeMenuItem alloc] 
                            initWithImage:imageAddText
                            highlightedImage:nil
                            ContentImage:imageAddText 
                            highlightedContentImage:nil];
    menuItem3 = [[AwesomeMenuItem alloc] 
                            initWithImage:imageAddEmoticon
                            highlightedImage:nil
                            ContentImage:imageAddEmoticon 
                            highlightedContentImage:nil];
    menuItem4 = [[AwesomeMenuItem alloc] 
                            initWithImage:imageAddPerson
                            highlightedImage:nil
                            ContentImage:imageAddPerson 
                            highlightedContentImage:nil];
    
    // Now, setup the menu and the options
    awesomeMenu = [[AwesomeMenu alloc] 
                    initWithFrame:CGRectMake(15.0, 35.0, 25.0, 25.0) 
                    menus:[NSArray arrayWithObjects:menuItem1, menuItem2, menuItem3, menuItem4, nil]];
    awesomeMenu.startPoint = CGPointMake(15.0, 35.0);
    awesomeMenu.rotateAngle = 90.0;
    awesomeMenu.menuWholeAngle = M_PI / 2;
    awesomeMenu.timeOffset = 0.036f;
    // Set the distance between the "Add" button and Menu Items
    awesomeMenu.endRadius = 110.0f;
    
    awesomeMenu.farRadius = 140.0f;
    awesomeMenu.nearRadius = 110.0f;
    
    //awesomeMenu = [[AwesomeMenu alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    awesomeMenu.delegate = self;
    //awesomeMenu.frame = CGRectMake(10, 3, 50, 50);
    //awesomeMenu.bounds = CGRectMake(10, 3, 50, 50);
    //[self presentModalViewController:awesomeMenu //animated:YES];
    [self.view addSubview:awesomeMenu];
    NSLog(@"initializeSpringMenu: Done initializing it");
}


- (void)AwesomeMenuItemTouchesEnd:(AwesomeMenuItem *)item {
    [awesomeMenu AwesomeMenuItemTouchesEnd:item];
    NSLog(@"awesome menu item touches ended");
}
*/



/**
 * Initializes the menu that displays the emoticons to choose from
 * @created 19th May 2012
 */
-(void) initializeEmoticonsMenu {
    
    NSLog(@"InitializeEmoticonsMenu: entered");
    UIImage *picEmoticonHappy       = [UIImage imageNamed:ICON_EMOTICON_HAPPY];
    UIImage *picEmoticonOverjoyed   = [UIImage imageNamed:ICON_EMOTICON_OVERJOYED];
    UIImage *picEmoticonRomantic    = [UIImage imageNamed:ICON_EMOTICON_ROMANTIC];
    UIImage *picEmoticonSad         = [UIImage imageNamed:ICON_EMOTICON_SAD];
    UIImage *picEmoticonDepressed   = [UIImage imageNamed:ICON_EMOTICON_DEPRESSED];
    UIImage *picEmoticonAngry       = [UIImage imageNamed:ICON_EMOTICON_ANGRY];

    self.noteEntryView.emoticonHappy     = [[AwesomeMenuItem alloc] 
                            initWithImage:picEmoticonHappy
                            highlightedImage:nil
                            ContentImage:picEmoticonHappy
                            highlightedContentImage:nil];
    self.noteEntryView.emoticonOverjoyed = [[AwesomeMenuItem alloc] 
                            initWithImage:picEmoticonOverjoyed
                            highlightedImage:nil
                            ContentImage:picEmoticonOverjoyed 
                            highlightedContentImage:nil];
    self.noteEntryView.emoticonRomantic  = [[AwesomeMenuItem alloc] 
                            initWithImage:picEmoticonRomantic
                            highlightedImage:nil
                            ContentImage:picEmoticonRomantic 
                            highlightedContentImage:nil];
    self.noteEntryView.emoticonSad       = [[AwesomeMenuItem alloc] 
                            initWithImage:picEmoticonSad
                            highlightedImage:nil
                            ContentImage:picEmoticonSad 
                            highlightedContentImage:nil];
    self.noteEntryView.emoticonDepressed = [[AwesomeMenuItem alloc] 
                            initWithImage:picEmoticonDepressed
                            highlightedImage:nil
                            ContentImage:picEmoticonDepressed 
                            highlightedContentImage:nil];
    self.noteEntryView.emoticonAngry     = [[AwesomeMenuItem alloc] 
                            initWithImage:picEmoticonAngry
                            highlightedImage:nil
                            ContentImage:picEmoticonAngry 
                            highlightedContentImage:nil];
    
    // Now, setup the menu and the options
    self.noteEntryView.emoticonsMenu     = [[AwesomeMenu alloc] 
                            initWithFrame:CGRectMake(
                                         kEmoticonsMenuX, kEmoticonsMenuY, 
                                         kEmoticonsMenuWd, kEmoticonsMenuHt)  
                            menus:[NSArray arrayWithObjects:self.noteEntryView.emoticonHappy, 
                                    self.noteEntryView.emoticonOverjoyed,
                                    self.noteEntryView.emoticonRomantic, 
                                    self.noteEntryView.emoticonSad, 
                                    self.noteEntryView.emoticonDepressed,
                                    self.noteEntryView.emoticonAngry, 
                                    nil]];
    self.noteEntryView.emoticonsMenu.startPoint = CGPointMake(kEmoticonsMenuX, kEmoticonsMenuY);
    self.noteEntryView.emoticonsMenu.rotateAngle = 90.0;
    self.noteEntryView.emoticonsMenu.menuWholeAngle = M_PI / 1.5;
    self.noteEntryView.emoticonsMenu.timeOffset = 0.050f;
    // Set the distance between the "emoticon" button and Menu Items
    self.noteEntryView.emoticonsMenu.endRadius = 110.0f;
    self.noteEntryView.emoticonsMenu.farRadius = 180.0f;
    self.noteEntryView.emoticonsMenu.nearRadius = 110.0f;
    self.noteEntryView.emoticonsMenu.delegate = self;
    [self.view addSubview:self.noteEntryView.emoticonsMenu];
    NSLog(@"initializeSpringMenu: Done initializing it");
}



/**
 * Initializes the text field
 * @created 21st May 2012
 */
-(void) initializeTextWriting {
    
    self.noteEntryView.textLive.hidden              = NO;
    self.noteEntryView.textBorderImage.hidden       = NO;
    self.noteEntryView.textFieldUserInput.hidden    = YES;
    self.noteEntryView.buttonSaveText.hidden        = YES;
    self.noteTextPicker.hidden                      = YES;

    CGRect rect = self.noteTextPicker.frame;
    rect.origin = CGPointMake(0.0, 95.0);
    self.noteTextPicker.frame = rect;
    noteTextPicker.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
    NSInteger category = [self.noteTextPicker selectedRowInComponent:kCategoryComponent];        
    NSString *str = [self.commonNotesKeys objectAtIndex:category];
    NSArray *array = [self.commonNotesDict objectForKey:str];
    if (category < array.count ) {
        self.noteEntryView.textFieldUserInput.text = [array objectAtIndex:category];
    } else {
        self.noteEntryView.textFieldUserInput.text = kEmptyString;
    }
}



-(IBAction)buttonWritePressed:(id)sender {
    
    [UIView transitionWithView:self.noteEntryView.textFieldUserInput  
          duration:0.7
           options:UIViewAnimationOptionTransitionCrossDissolve
        animations:^{ 
            self.noteEntryView.textFieldUserInput.hidden    = NO;
            self.noteEntryView.buttonSaveText.hidden        = NO;
            self.noteTextPicker.hidden                      = NO;
            self.noteEntryView.buttonCamera.hidden          = YES;
            self.noteEntryView.buttonPencil.hidden          = YES;
            self.noteEntryView.picLive.hidden               = YES;
            self.noteEntryView.buttonPenThis.enabled        = NO;
            self.noteEntryView.buttonCancel.enabled         = NO;
        }
        completion:NULL];              
    [self.noteTextPicker becomeFirstResponder]; 
}



- (void)AwesomeMenuItemTouchesEnd:(AwesomeMenuItem *)item {
    [self.noteEntryView.emoticonsMenu AwesomeMenuItemTouchesEnd:item];
    NSLog(@"emoticons menu item touches ended");
}



// tag:springmenu
/**
 * Responds to the selection i.e. user choice in the menu
 * @param  menu  AwesomeMenu  The menu instance of interest
 * @param  idx   NSInteger    The choice in the menu that the user selected
 * @created 13th May 2012
 */
/*- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
 {
 NSLog(@"Select the index : %d",idx);
 
 int userAct = (int) idx;
 
 
 switch (userAct) {
 
 case kActPhoto: {
 NSLog(@"didSelectIndex: User has chosen to add a photo");
 picCode = 1;
 [self addPicOrVideo];
 self.buttonPenThis.hidden = NO;
 break;
 }
 
 case kActEmoticon: {
 NSLog(@"didSelectIndex: User has chosen to add an emoticon");
 [UIView transitionWithView:emoticonsView  
 duration:1.5
 options:UIViewAnimationOptionTransitionCrossDissolve
 animations:^{ 
 self.emoticonsView.hidden = NO;
 self.awesomeMenu.hidden = YES;
 }  
 completion:NULL];
 self.buttonPenThis.hidden = NO;
 break;
 }    
 
 case kActText: {
 NSLog(@"didSelectIndex: Usr has chosen to add some text");
 [UIView transitionWithView:self.textFieldUserInput  
 duration:1.5
 options:UIViewAnimationOptionTransitionCrossDissolve
 animations:^{ 
 self.textFieldUserInput.hidden = NO;
 }  
 completion:NULL];              
 [self.textFieldUserInput becomeFirstResponder];
 break;
 }
 
 case kActPerson: {
 NSLog(@"didSelectIndex: User has chosen to associate the note with a person");
 picCode = 2;
 [self addPicOrVideo];
 self.buttonPenThis.hidden = NO;
 break;
 }
 
 default: {
 break;
 }
 }
 }
 */


/**
 * This is called automatically once the user selects an emoticon from the emoticons' menu
 * @created 19th May 2012
 */
- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)index {
    int emoticonChosen = (int)index + 1;
    NSLog(@"Emoticon chosen by the user : %d",emoticonChosen);
    [self expressedEmotion:emoticonChosen];
}



- (IBAction)history:(id)sender {
    [UIView transitionWithView:self.tabBarController.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{ 
                       self.tabBarController.selectedIndex = 1;
                    }  
                    completion:NULL];
}


-(void) initializeNoteTextPicker {
    
    noteTextPicker = [[UIPickerView alloc] init];
    noteTextPicker.delegate = self;
    noteTextPicker.dataSource = self;
    noteTextPicker.showsSelectionIndicator = YES;
    [self.view addSubview:noteTextPicker];
    noteTextPicker.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark NSApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Key 'UIApplicationLaunchOptionsLocalNotificationKey' for local notifications
}



#pragma mark - View lifecycle

- (void) viewDidLoad {
 
    [super viewDidLoad];
    [self testThis];
    self.title = @"Home";
    
    // TODO : support only photo (not video) for now
    // tag:video
    self.lastChosenMediaType = (NSString *)kUTTypeImage;
    
    // Initialize the 'Live Note' with placeholders
    self.noteEntryView.homeView = self;
    self.initialLabelText = self.noteEntryView.textLive.text;
    [self initializeEmoticonNoteView];
    [self resizeToEmoticonNoteView];
    
    //Set the max char limit on the text field
    // self.noteEntryView.textFieldUserInput.delegate = self;
        
    //self.textLive.text = DUMMY_TEXT;
    //self.picLive.image = [UIImage imageNamed:DUMMY_PIC];
    //self.personPicLive.image = [UIImage imageNamed:DUMMY_PERSON_PIC];
    //self.emoticonLive.image = [UIImage imageNamed:DUMMY_EMOTICON];
    
    // picCode = 0;
    myEmotionNum    = -1;
    //table.frame     = CGRectMake(0.0, 94.0, 320.0, 319.0);
    _timeScroller   = [[TimeScroller alloc] initWithDelegate:self];
    
    self.picFrameView = [[PictureView alloc] init];
    
    //UIImage *cancelEnabled  = [UIImage imageNamed:BUTTON_RESET_ENABLED];
    //UIImage *cancelDisabled = [UIImage imageNamed:BUTTON_RESET_DISABLED];
    //[self.noteEntryView.buttonReset setImage:cancelEnabled  forState:UIControlStateNormal];
    //[self.noteEntryView.buttonReset setImage:cancelDisabled forState:UIControlStateDisabled];
    
    //UIImage *cancelEnabled  = [UIImage imageNamed:BUTTON_RESET_ENABLED];
    //UIImage *cancelDisabled = [UIImage imageNamed:BUTTON_RESET_DISABLED];
    //[self.noteEntryView.buttonReset setImage:cancelEnabled  forState:UIControlStateNormal];
    //[self.noteEntryView.buttonReset setImage:cancelDisabled forState:UIControlStateDisabled];
    
    UIImage *sleepSelected = [UIImage imageNamed:BUTTON_SLEEP_SELECTED];
    UIImage *sleepUnselected = [UIImage imageNamed:BUTTON_SLEEP_UNSELECTED];
    [self.noteEntryView.buttonSleep setImage:sleepUnselected  forState:UIControlStateNormal];
    [self.noteEntryView.buttonSleep setImage:sleepSelected forState:UIControlStateSelected];

    UIImage *okEnabled = [UIImage imageNamed:BUTTON_PENTHIS_ENABLED];
    UIImage *okDisabled = [UIImage imageNamed:BUTTON_PENTHIS_DISABLED];
    [self.noteEntryView.buttonPenThis setImage:okEnabled  forState:UIControlStateNormal];
    [self.noteEntryView.buttonPenThis setImage:okDisabled forState:UIControlStateDisabled];

    UIImage *cancelEnabled = [UIImage imageNamed:BUTTON_CANCEL_ENABLED];
    UIImage *cancelDisabled = [UIImage imageNamed:BUTTON_CANCEL_DISABLED];
    [self.noteEntryView.buttonCancel setImage:cancelEnabled  forState:UIControlStateNormal];
    [self.noteEntryView.buttonCancel setImage:cancelDisabled forState:UIControlStateDisabled];
    
    rowHasPicture = 0;
    dictionary = [[NSMutableDictionary alloc] init];
    NSLog(@"viewDidLoad: Home View");
    dbOps = [DatabaseOperations dbOpsSingleton];
    NSLog(@"got the singleton");
    [dbOps createTableNamed:kTableName
                 withField1:@"user"
                 withField2:@"time" 
                 withField3:@"text"
                 withField4:@"emoticon"
                 withField5:@"picture"
                 withField6:@"sleep"];
    
    [self initializeEmoticonsMenu];
    [self scheduleLocalNotification];
    // Load the user's data from previous encounters
    [self loadEarlierConversation];
    
    // Tag:Nav
    // UIImage *history = [UIImage imageNamed:BUTTON_HISTORY];
    UIImageView *imagView = 
                [[UIImageView alloc] initWithFrame:self.navigationController.navigationBar.frame];
    imagView.contentMode = UIViewContentModeLeft;
    imagView.image = [UIImage imageNamed:BUTTON_HISTORY];
    [self.navigationController.navigationBar insertSubview:imagView atIndex:0];
    
    /*UIBarButtonItem *historyButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"History" 
                                      style:UIBarButtonItemStylePlain 
                                      target:self 
                                      [action:@selector(history:)];
     */
    //self.navigationItem.rightBarButtonItem = historyButton;
    //historyButton.image.size = CGRectMake(0, 0, 5, 3);
    [self initializeNoteTextPicker];

    // Load the plist file that has the common notes
    [self initializeCommonNotes];
    
    [self animateBounce:self.noteEntryView.emoticonsMenu 
                    withX:kEmoticonsMenuX withY:kEmoticonsMenuY 
                    withWd:kEmoticonsMenuWd withHt:kEmoticonsMenuHt 
                    withDuration:kEmoticonsMenuAnimDur];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Be a good Memory Citizen please!
    self.arrayInput = nil;
    self.noteEntryView.buttonPenThis = nil;
    self.buttonEmotionHappy = nil;
    self.buttonEmotionSad = nil;
    self.noteEntryView.buttonSaveText = nil;
    self.noteEntryView.textFieldUserInput = nil;
    self.imageView = nil;
    self.moviePlayer = nil;
    self.image = nil;
    self.commonNotesDict                    = nil;
    self.commonNotesKeys                    = nil;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




#pragma mark -
#pragma mark Table View Data Source Methods

-(NSInteger) tableView:(UITableView *)tableView 
                numberOfRowsInSection:(NSInteger)section {

    return [self.arrayInput count];
}



-(UITableViewCell *) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     * Here, we deal with different types of cells to meet varying display needs:
     * Type 1 : EmotionNoteTableCell
     *     One that takes the call when the table row has all the info present
     * Type 2 : ImageNoteTableCell
     *     One that handles the display when the cell has only an image, & no text
     * Type 3 : TextNoteTablle Cell
     *     The default one (if 1 or 2 doesn't fit the bill)
     */
    
    static NSString *SimpleTableIdentifier   = @"SimpleTableIdentifier";
    static NSString *ImageCellIdentifier     = @"ImageCellIdentifier";
    static NSString *TextCellIdentifier      = @"TextCellIdentifier";

    static BOOL nibsRegistered = NO;
    
    // Load the nib files
    if(!nibsRegistered) {
        UINib *cellNib = [UINib nibWithNibName:@"EmotionNoteTableCell" bundle:nil];
        [table registerNib:cellNib forCellReuseIdentifier:SimpleTableIdentifier];
        
        UINib *imageCellNib = [UINib nibWithNibName:@"ImageNoteTableCell" bundle:nil];
        [table registerNib:imageCellNib forCellReuseIdentifier:ImageCellIdentifier];
        
        UINib *textCellNib = [UINib nibWithNibName:@"TextNoteTableCell" bundle:nil];
        [table registerNib:textCellNib forCellReuseIdentifier:TextCellIdentifier];
        
        nibsRegistered = YES;
    }
    
    // Get the data, to be displayed, for the cell
    NSUInteger row = [indexPath row];
    NSString *noteText = 
      [[arrayInput objectAtIndex:row] objectForKey:@"text"];
    int emoticon = 
      [[[arrayInput objectAtIndex:row] objectForKey:@"emoticon"] intValue];
    int sleep =
        [[[arrayInput objectAtIndex:row] objectForKey:@"sleep"] intValue];
    NSLog(@"cell sleep:%d", sleep);
    
    NSString *picPath = [[arrayInput objectAtIndex:row] objectForKey:@"picture"];
    //NSString *picData = [[NSString alloc] initWithContentsOfFile:picPath 
      //                                              encoding:NSUTF8StringEncoding error:nil];
    UIImage *pic = [[UIImage alloc] initWithContentsOfFile:picPath];

    /* UIImage *cellPersonPic = 
      [[arrayInput objectAtIndex:row] objectForKey:@"personpic"];
     */
    //NSLog(@"cellpersonpic size:%f", cellPersonPic.size.height);

    
    // -----------------------------------------------------------------------------
    // -------------------------  Type : ImageNoteTableCell ----------------------
    // -----------------------------------------------------------------------------
    if (((noteText == NULL) || (noteText == nil) || (noteText.length == 0)) && ((pic != nil) && (pic != [NSNull null]))) {
        
         NSLog(@"Type: ImageNoteTableCell for index %d", (int)row);
        
        ImageNoteTableCell *imageCell = 
                [tableView dequeueReusableCellWithIdentifier:ImageCellIdentifier];
        [imageCell setFirstViewController:self];

        // Set the emoticon
        imageCell.noteEmoticon = [self getEmoticonForCode:emoticon];
        imageCell.noteSleep = sleep;
        
        UIImage *cellImage = [pic copy];
        imageCell.noteImage = 
                shrinkImage(cellImage, 
                            CGSizeMake(kImageNoteImageViewWd, kImageNoteImageViewHt));
        imageCell.imageOriginal = cellImage;
        cellImage = nil;
        imageCell.noteImageView.frame = 
                CGRectMake(
                           kImageNoteImageViewX, kImageNoteImageViewY,
                           kImageNoteImageViewWd, kImageNoteImageViewHt);
        [imageCell.noteImageView.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [imageCell.noteImageView.layer setBorderWidth:kPicBorderWdBig];
        CALayer *l = [imageCell.noteImageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:kPicCornerRadiusBig];
        l = nil;
        
        // Display the person's pic
        /* if ((cellPersonPic != nil) && (cellPersonPic !=[NSNull null])){
            NSLog(@"has a person pic");
            UIImage *cellPerson = [cellPersonPic copy];
            imageCell.notePersonPic = 
                shrinkImage(cellPerson, CGSizeMake(kNotePersonPicWd, kNotePersonPicHt));
            cellPerson = nil;        
        }
        */
        
        imageCell.picView.frame = 
                CGRectMake(
                           kImageNoteFrameX, kImageNoteFrameY, 
                           kImageNoteFrameWd, kImageNoteFrameHt);
        
        rowHasPicture = 1;
        
        return imageCell;
    } 

    // -----------------------------------------------------------------------------
    // -------------------------  Type : EmotionNoteTableCell ----------------------
    // -----------------------------------------------------------------------------
    else if (((noteText != nil) && (noteText.length != 0)) && ((pic != nil) && (pic != [NSNull null])) ) {
        
        NSLog(@"Type: EmotionNoteTableCell for index %d", (int)row);
        EmotionNoteTableCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        [cell setFirstViewController:self];
 
        // Display the text
        cell.noteText = noteText;
        
        // Display the emoticon
        if (emoticon != -1) {
            cell.noteEmotion = [self getEmoticonForCode:emoticon];
        }
        cell.noteSleep = sleep;

        // Display the picture
        UIImage *cellImage = [pic copy];
        cell.noteImage = shrinkImage(cellImage, 
                                     CGSizeMake(kEmotionNoteImageViewWd, kEmotionNoteImageViewHt));
        cell.imageOriginal = cellImage;
        cellImage = nil;        
        
        cell.noteImageView.frame = 
                        CGRectMake(kEmotionNoteImageViewX, kEmotionNoteImageViewY,
                                   kEmotionNoteImageViewWd, kEmotionNoteImageViewHt);
        [cell.noteImageView.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [cell.noteImageView.layer setBorderWidth:kPicBorderWdBig];
        CALayer *l = [cell.noteImageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:kPicCornerRadiusBig];
        l = nil;
        
        cell.picView.frame = CGRectMake(kEmotionNoteFrameX, kEmotionNoteFrameY, 
                                        kEmotionNoteFrameWd, kEmotionNoteFrameHt);
        
        // Display the person's pic
        /*
         if ((cellPersonPic != nil)  && (cellPersonPic !=[NSNull null])) {
            UIImage *cellPerson = [cellPersonPic copy];
            cell.notePersonPic = 
                shrinkImage(cellPerson, CGSizeMake(kNotePersonPicWd, kNotePersonPicHt));
            cellPerson = nil;        
        }
        */
        //cell..frame = CGRectMake(85.0, 77.0, 185.0, 185.0);
        //cell.picView.frame = CGRectMake(57.0, 6.0, 255.0, 285.0);
        
        //cell.noteImageView.clipsToBounds = YES;
        //cell.noteImageView.layer.cornerRadius = 3.0;
        //cell.noteImageView.layer.masksToBounds = YES;
        //cell.noteImageView.layer.borderColor = [UIColor blackColor].CGColor;
        //imageView.layer.borderWidth = 1.0;
        rowHasPicture = 1;
        
        return cell;
    }
    
    // -----------------------------------------------------------------------------
    // -------------------  Type : Default: TextNoteTableCell ----------------------
    // -----------------------------------------------------------------------------
    else {
        NSLog(@"Type: TextNoteTableCell for index %d", (int)row);
        TextNoteTableCell *textCell = 
                [tableView dequeueReusableCellWithIdentifier:TextCellIdentifier];
        [textCell setFirstViewController:self];
        
        if ((noteText == nil) || (noteText.length == 0)) {
            textCell.noteTextLabel.hidden = YES;
        } else {
            textCell.noteTextLabel.hidden = NO;
            textCell.noteText = noteText;
        }
        if (emoticon != -1) {
            textCell.noteEmotionView.image = 
                        [self getEmoticonForCode:emoticon];
        }
        
        textCell.noteSleep = sleep;

        textCell.picView.frame = CGRectMake(
                                        kTextNoteImageViewX, kTextNoteImageViewY, 
                                        kTextNoteImageViewWd, kTextNoteImageViewHt);
        
        // Display the person's pic
        /*
        if ( (cellPersonPic != nil) && (cellPersonPic != [NSNull null]) ){
            NSLog(@"Text note cell display: person pic is there");
            UIImage *cellPerson = [cellPersonPic copy];
            textCell.notePersonPic = 
                shrinkImage(cellPerson, 
                    CGSizeMake(kTextNotePersonPicWd, kTextNotePersonPicHt));
            cellPerson = nil;        
        }
        */
        rowHasPicture = 0;

        return textCell;
    }

    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
    
    NSUInteger row      = [indexPath row];
    NSString *pic       = [[arrayInput objectAtIndex:row] objectForKey:@"picture"];
    NSString *cellText  = [[arrayInput objectAtIndex:row] objectForKey:@"text"];
    
    if ( (pic != nil)  && (pic.length != 0) && 
        ( (cellText == nil) || (((int)cellText.length) == 0)) ) {
        return kImageNoteCellHt;
        
    } else if ( (pic != nil) && (pic.length != 0) && (cellText != nil) && (cellText.length != 0) ) {
        return kEmotionNoteCellHt;
        
    } else {
        return kTextNoteCellHt;
    }
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)] autorelease];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, headerView.frame.size.width-120.0, headerView.frame.size.height)];
    
    headerLabel.textAlignment = UITextAlignmentRight;
    headerLabel.text = [titleArray objectAtIndex:section];
    headerLabel.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:headerLabel];
    [headerLabel release];
    
    return headerView;
    
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  30.0;
}
*/



/**
 * Displays the picture in full view
 * @param   UIImage     img     The image (original) to be displayed full-screen
 * @created 28th May 2012
 */
-(void) displayFullPic: (UIImage *)img {
    
    NSLog(@"displayFullPic: begin");
    // self.picFrameView.frame           = CGRectMake(0.0, 44.0, 320.0, 440.0);  
    // self.picFrameView.imageView.frame = CGRectMake(0.0, 44.0, 320.0, 440.0);
    NSLog(@"displayFullPic: img size:%f", img.size.width);
        
    [self.view addSubview:self.picFrameView.view];
    [UIView transitionWithView:self.view
          duration:1.0
           options:UIViewAnimationOptionTransitionCurlUp
        animations:^{ 
            self.picFrameView.view.frame = CGRectMake(5.0, 48.0, 310.0, 360.0);
            self.picFrameView.imageView.image = img;
            [self.picFrameView.imageView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
            [self.picFrameView.imageView.layer setBorderWidth:kPicBorderWdBig];
            CALayer *l = [self.picFrameView.imageView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:kPicCornerRadiusBig];
            l = nil;

        }  
        completion:NULL];

    NSLog(@"displayFullPic: end");
}



/**
 * Returns the smiley image that maps to the given code
 * @param   emoticonCode  int  The code for the emoticon that the user chose for the note
 * @return  UIImage            The image corresponding to the input emoticon-code
 * @created 14th May 2012
 */
-(UIImage *) getEmoticonForCode: (int) emoticonCode {
    
    UIImage *emoticon = nil;
    
    // Validate the Emoticon Code
    emoticonCode = [Utility validateEmoticon:emoticonCode];
    
    switch (emoticonCode) {

        case kEmotionHappy:
            emoticon = [UIImage imageNamed:ICON_EMOTICON_HAPPY];
            break;
            
        case kEmotionOverjoyed:
            emoticon = [UIImage imageNamed:ICON_EMOTICON_OVERJOYED];
            break;
            
        case kEmotionRomantic:
            emoticon = [UIImage imageNamed:ICON_EMOTICON_ROMANTIC];
            break;
            
        case kEmotionSad:
            emoticon = [UIImage imageNamed:ICON_EMOTICON_SAD];
            break;
            
        case kEmotionDepressed:
            emoticon = [UIImage imageNamed:ICON_EMOTICON_DEPRESSED];
            break;
            
        case kEmotionAngry:
            emoticon = [UIImage imageNamed:ICON_EMOTICON_ANGRY];
            break;
            
        default:
            NSLog(@"Smiley '%d' selection invalid", emoticonCode);
            break;
    }
    return emoticon;
}


/*
 * The UITableView that you'd like the TimeScroller to be in
 */
- (UITableView *)tableViewForTimeScroller: (TimeScroller *)timeScroller {
    //NSLog(@"tableViewForTimeScroller : returned UITableView");
    return table;
}



//The date for a given cell
- (NSDate *)dateForCell:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [table indexPathForCell:cell];
    int timeInt = [[[arrayInput objectAtIndex:[indexPath row]] objectForKey:@"time"] intValue]; 
    NSDate *time = [Utility getIntAsDate:timeInt];
    // NSLog(@"returned time for scroller: %@", time);
    return time;                        
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewDidScroll");
    [_timeScroller scrollViewDidScroll];       
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewDidEndDecelerating");
    [_timeScroller scrollViewDidEndDecelerating];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewWillBeginDragging");
    [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {        
    //NSLog(@"scrollViewDidEndDragging");
    if (!decelerate) {                        
        [_timeScroller scrollViewDidEndDecelerating];                                      
    }                                               
}



#pragma mark UIImagePickerController delegate methods

/**
 * This checks to see whether a picture or video was chosen, 
 * makes note of the selection 
 * then dismisses the modal image picker
 */
-(void)imagePickerController:(UIImagePickerController *)picker
                            didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"didFinishPickingMediaWithInfo");
    self.lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        
        NSLog(@"The user has chosen media type = pic");
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];

        // NSLog(@"pic code = %d", picCode);

        //if (picCode == 1) {

        //self.noteEntryView.buttonReset.enabled = YES;
        
        NSLog(@"picture is present");
        self.image = chosenImage;
        self.noteEntryView.picLive.image = shrinkImage(chosenImage, 
                                CGSizeMake(kPicLiveWd,kPicLiveHt));
        [self.noteEntryView.picLive.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [self.noteEntryView.picLive.layer setBorderWidth:kPicBorderWdSmall];
        CALayer *l = [self.noteEntryView.picLive layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:kPicCornerRadiusSmall];
        l = nil;

        NSLog(@"Done saving the chosen picture");
                        
        //} 
        /*else if (picCode == 2) {
            NSLog(@"person-pic is present");
            self.personPic = chosenImage;
            NSLog(@"didFinishPickingMediaWithInfo:self.personpic:%f", self.personPic.size.height);
            self.noteEntryView.personPicLive.image = shrinkImage(chosenImage, 
                                             CGSizeMake(kPersonPicLiveWd,   
                                                        kPersonPicLiveHt));
            NSLog(@"Done saving the chosen person-picture");
        }
        */
        
    } else if ([lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]) {
        self.movieURL = [info objectForKey:UIImagePickerControllerMediaURL]; 
    }
    
    [picker dismissModalViewControllerAnimated:YES]; 
}


/**
 *  This dismisses the image picker
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker { 
    [picker dismissModalViewControllerAnimated:YES];
}



#pragma mark -
static UIImage *shrinkImage(UIImage *original, CGSize size) {
    
    CGFloat scale = [UIScreen mainScreen].scale; 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSLog(@"going to get the context");
    CGContextRef context = CGBitmapContextCreate(
                                                 NULL, 
                                                 size.width*scale,
                                                 size.height*scale, 
                                                 8, 0, 
                                                 colorSpace, 
                                    kCGImageAlphaPremultipliedFirst);
    NSLog(@"got the context");
    CGContextDrawImage(context,
                       CGRectMake(0, 0, 
                                  size.width * scale, 
                                  size.height * scale),
                                  original.CGImage);
    NSLog(@"called CGContextDrawImage");
    CGImageRef shrunken = CGBitmapContextCreateImage(context);
    NSLog(@"called shrunken");
    UIImage *final = [UIImage imageWithCGImage:shrunken];
    NSLog(@"called final");
    CGContextRelease(context); 
    CGImageRelease(shrunken);
    return final;
}




// ********************** METHODS FOR THE EMAIL FEATURE ************************************

/**
 * This can run on devices running iPhone OS 2.0 or later  
 * The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
 * So, we must verify the existence of the above class and provide a workaround for devices running 
 * earlier versions of the iPhone OS. 
 * The method displays an email composition interface if MFMailComposeViewController exists and the device can send emails.
 * It then launches the Mail application on the device, otherwise.
 */
-(void)showEmailComposerWithText:(NSString *) noteText
                     withEmoticon:(UIImage *) emoticon
                     withPicture:(UIImage *) picture {
    
    NSLog(@"showEmailComposer: begin");
    
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]) {
            NSLog(@"showEmailComposer: Calling displayComposerSheet");
			[self displayComposerSheetWithText:(NSString *) noteText
                                   withEmoticon:(UIImage *) emoticon
                                   withPicture:(UIImage *) picture];
            
		} else {
            NSLog(@"showEmailComposer: Calling launchMailAppOnDevice");
			[self launchMailAppOnDevice];
		}
	}
	else {
        NSLog(@"showEmailComposer: Calling launchMailAppOnDevice");
		[self launchMailAppOnDevice];
	}
}




#pragma mark -
#pragma mark Compose Mail

-(void) displayComposerSheetWithText:(NSString *) noteText
                         withEmoticon:(UIImage *) emoticon
                         withPicture:(UIImage *) picture {

    NSLog(@"displayComposerSheet: begin");
    mailComposer = [[MFMailComposeViewController alloc] init];
    //mailComposer.messageComposeDelegate = self;
    mailComposer.mailComposeDelegate = self;

    // Set the mail title
    [mailComposer setSubject:@"My Moment of Emotion"];
    
    // Set the recipients
    // NSArray *toRecipients = [NSArray arrayWithObject:@"to Recipient @ mail .com"];
    // [mailComposer setToRecipients:toRecipients];
    // [mailComposer setCcRecipients:ccRecipients];
    // [mailComposer setBccRecipients:bccRecipients];
    
    // TODO : check on how-to for mail attachment
    // Attach an image to the email
    /* NSString *picPath = [[NSBundle mainBundle] pathForResource:@"CuteDoggy" ofType:@"jpg"];
     NSData *picData = [NSData dataWithContentsOfFile:picPath];
     [mailComposer addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
     */
    
    // EMail Body
    NSString *mailBody = noteText;
    [mailComposer setMessageBody:mailBody isHTML:YES];
    
    NSLog(@"present the modal view ctlr");
    [self presentModalViewController:mailComposer animated:YES];
}



/**
 * Dissmiss the email composition interface when the users tap 'Cancel'/'Send'
 * Proceeds to update the 'message' field with the text, if any
 */
-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    NSString *alertTitle;
    NSString *alertMsg;
    
    // Notifies users on errors, if any
    switch (result) {
            
        case MFMailComposeResultCancelled:
            alertTitle = @"Cancelled";
            alertMsg = @"Mail composition got cancelled";
            break;
        case MFMailComposeResultSaved:
            alertTitle = @"Success - Saved";
            alertMsg = @"Mail got saved successfully!";
            break;
        case MFMailComposeResultSent:
            alertTitle = @"Success - Sent";
            alertMsg = @"Mail sent successfully!";
            break;
        case MFMailComposeResultFailed:
            alertTitle = @"Failure";
            alertMsg = @"Sending the mail failed";
            break;
        default:
            alertTitle = @"Failure";
            alertMsg = @"Mail could not be sent";
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:alertTitle
                          message:alertMsg
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
    [self dismissModalViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
	NSString *body = @"&body=It is raining in sunny California!";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}



#pragma mark UIPickerViewDelegate methods

- (NSString*)pickerView:(UIPickerView*)pv titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == kCategoryComponent) {
        return [self.commonNotesKeys objectAtIndex:row];

    } else {
        NSInteger category = [pv selectedRowInComponent:kCategoryComponent];        
        NSArray *array = [self.commonNotesDict objectForKey:[self.commonNotesKeys objectAtIndex:category]];
        return [array objectAtIndex:row];
    }
}




#pragma mark UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pv {
	return 2;
}


- (NSInteger)pickerView:(UIPickerView*)pv numberOfRowsInComponent:(NSInteger)component {

	if (component == kCategoryComponent) {
        int cnt = [[self.commonNotesDict allKeys] count];
        NSLog(@"component 0 cnt:%d",cnt);
        return cnt;
    }
    else {
        NSInteger row = [pv selectedRowInComponent:kCategoryComponent];        
        int cnt = [[self.commonNotesDict 
                    objectForKey:[self.commonNotesKeys objectAtIndex:row]] count];
        NSLog(@"component 1 cnt:%d",cnt);
        return cnt;
    }
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    switch (component){
            
        case kCategoryComponent: 
            return 80.0f;
            
        case kNotesComponent: 
            return 220.0f;
    }
    return 0;
}



-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *theView = (UILabel *)view;
    if (!theView) {
        theView = [[UILabel alloc] init];
        theView.textColor = [UIColor darkGrayColor];
        theView.font = [UIFont fontWithName:@"Helevetica" size:8.0];
        theView.textAlignment = UITextAlignmentLeft;
        // TODO : @test : change the color per theme
        theView.highlightedTextColor = [UIColor redColor];
        
        if (component == kCategoryComponent) {
            theView.frame = CGRectMake(5.0, 0.0, 80.0, 50.0);
        } else {
            theView.frame = CGRectMake(5.0, 0.0, 220.0, 50.0);
        }
        
    }
    if (component == kCategoryComponent) {
        theView.text = [self.commonNotesKeys objectAtIndex:row];
        NSLog(@"text for row %d comp %d is %@", row, component, theView.text);
        
    } else {
        NSInteger category = [pickerView selectedRowInComponent:kCategoryComponent];        
        NSString *str = [self.commonNotesKeys objectAtIndex:category];
        NSArray *array = [self.commonNotesDict objectForKey:str];
        if (row < array.count ) {
            theView.text = [array objectAtIndex:row];
        } else {
            theView.text = kEmptyString;
        }
        NSLog(@"text for row %d %@ in comp %d is %@", row,str, component, theView.text);
    }
    return theView;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row 
    inComponent:(NSInteger)component {
    
    int selectedIndex = [pickerView selectedRowInComponent:kCategoryComponent];
    NSInteger selection = row;
    
    if (component == kCategoryComponent) {
        [pickerView reloadComponent:kNotesComponent];
        selection = [pickerView selectedRowInComponent:kNotesComponent];
    }
    if (component == kNotesComponent) {
        if (selectedIndex < 0) {
            [pickerView reloadComponent:kNotesComponent];
        }
    }
    
    NSInteger category = [pickerView selectedRowInComponent:kCategoryComponent];        
    NSString *str = [self.commonNotesKeys objectAtIndex:category];
    NSArray *array = [self.commonNotesDict objectForKey:str];
    if (row < array.count ) {
        self.noteEntryView.textFieldUserInput.text = [array objectAtIndex:selection];
    } else {
        self.noteEntryView.textFieldUserInput.text = kEmptyString;
    }
}




#pragma mark UITextViewDelegate methods
- (void)textViewDidEndEditing:(UITextView *)textView {

    [self saveText];
}


-(IBAction)textFieldEditingDone:(id)sender {

    [self saveText];
}


-(void) saveText {
   
    NSLog(@"saveText: editing ended in textview");
    
    //self.noteEntryView.buttonReset.enabled = YES;
    
    NSString *str = self.noteEntryView.textFieldUserInput.text;
    self.text = str;
    NSLog(@"saveText: self.text:%@", self.text);
    noteEntryView.textLive.text = str;
    
    // Clean up
    str = nil;
    [self.noteEntryView.textFieldUserInput resignFirstResponder];
    self.noteEntryView.textFieldUserInput.text = @"";
    
    // Make the text field disappear
    [UIView beginAnimations:nil context:NULL];
    self.noteEntryView.textFieldUserInput.hidden = YES;
    self.noteEntryView.buttonSaveText.hidden     = YES;
    self.noteTextPicker.hidden                   = YES;
    self.noteEntryView.textLive.hidden           = NO;
    self.noteEntryView.textBorderImage.hidden    = NO;
    self.noteEntryView.picLive.hidden            = NO;
    self.noteEntryView.buttonCamera.hidden       = NO;
    self.noteEntryView.buttonPenThis.enabled     = YES;
    self.noteEntryView.buttonCancel.enabled      = YES;
    [UIView commitAnimations]; 
    NSLog(@"saveText:end");
}



/**
 * Animate a horizontal bounce effect! :) i.e bounces along the horizontal line
 *
 * @param   xVal        float   the x axis point to start with
 * @param   yVal        float   the y axis point to start with
 * @param   wdVal       float   the width  -> stays constant
 * @param   htVal       float   the height -> stays constant
 * @param   duration    float   the duration of each step in the bounce
 *                              Give a higher value for a slow bounce (say > 0.5)
 *                              Give a low value (say 0.3 or less) for a fast bounce effect
 *
 * @created 26th May 2012
 */
-(void) animateBounce:(UIView *)view 
                withX:(float)xVal withY:(float)yVal 
                withWd:(float)wdVal withHt:(float)htVal
                withDuration:(float)duration {
    
    [UIView transitionWithView:view
            duration:duration
           options:UIViewAnimationOptionCurveLinear
        animations:^{ 
            view.frame =
            CGRectMake(xVal, yVal, wdVal, htVal);
        }
        completion:^(BOOL finished){
            
    [UIView transitionWithView:view
                      duration:duration
                       options:UIViewAnimationOptionCurveLinear
                    animations:^{ 
                        view.frame =
                        CGRectMake(xVal+4.0, yVal+10.0,wdVal, htVal);
                    }
                    completion:^(BOOL finished){
                        
                [UIView transitionWithView:view
                                  duration:duration
                                   options:UIViewAnimationOptionCurveLinear
                                animations:^{ 
                                    view.frame =
                                    CGRectMake(xVal+8.0, yVal,wdVal, htVal);
                                }
                                completion:^(BOOL finished) {
                                    
                                    [UIView transitionWithView:view
                                                      duration:duration
                                                       options:UIViewAnimationOptionCurveLinear
                                                    animations:^{ 
                                                        view.frame =
                                                        CGRectMake(xVal+12.0, yVal+10.0,
                                                                   wdVal, htVal);
                                                    }
                                        completion:^(BOOL finished) {
                                            
                                            [UIView transitionWithView:view
                                                              duration:duration
                                                               options:UIViewAnimationOptionCurveLinear
                                                            animations:^{ 
                                                                view.frame =
                                                                CGRectMake(xVal+16.0, 
                                                                           yVal,
                                                                           wdVal,htVal);
                                                            }
                                        completion:^(BOOL finished) {
                                            
                                            [UIView transitionWithView:view
                                                              duration:duration
                                                               options:UIViewAnimationOptionCurveLinear
                                                            animations:^{ 
                                                                view.frame =
                                                                CGRectMake(xVal+20.0, 
                                                                           yVal+10.0,
                                                                           wdVal,htVal);
                                                            }
                                        completion:^(BOOL finished) {
                                            
                                            [UIView transitionWithView:view
                                                              duration:duration
                                                               options:UIViewAnimationOptionCurveLinear
                                                            animations:^{ 
                                                                view.frame =
                                                                CGRectMake(xVal+28.0, 
                                                                           yVal,
                                                                           wdVal,htVal);
                                                            }
                                                            completion:NULL];
                                        }];
                                        }];
                                        }];
                        }];
                    }];
    
}];
}


// TODO: chck out this fading in-out animation
- (void)animateSubviewAway:(UIView *)subview {
    if (subview == nil) return;
    self.animatedSubview = subview;
    [self.view bringSubviewToFront:subview];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    self.animatedSubview.alpha = 0.0;
    [UIView commitAnimations];
}



// TODO: chck out this fading in-out animation
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [self.view sendSubviewToBack:self.animatedSubview];
    self.animatedSubview.alpha = 1.0;
    self.animatedSubview = nil;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > kTextFieldLimit) ? NO : YES;
}


-(void) testThis {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    int year = [components year];
    int month = [components month];
    int day = [components day];
    int hour = 10;
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
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *remindOn = [formatter dateFromString:remind];
    NSLog(@"First reminder set on: %@ , str: %@", remindOn, remind);
}

@end
