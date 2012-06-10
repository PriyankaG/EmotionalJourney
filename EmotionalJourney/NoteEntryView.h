//
//  NoteEntryView.h
//  EmotionalJourney
//
//  Created by Administrator on 19/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwesomeMenu.h"
#import "AwesomeMenuItem.h"
#import "com_FirstViewController.h"

@class com_FirstViewController;

@interface NoteEntryView : UIControl

@property (nonatomic, retain) com_FirstViewController *homeView;

@property (nonatomic, retain) IBOutlet UIView *liveNoteViewSmall;
@property (nonatomic, retain) IBOutlet UIImageView *liveNoteImageSmall;

// @tag:LiveNote
@property (nonatomic, retain) IBOutlet UIImageView *liveNoteViewBig;
@property (nonatomic, retain) IBOutlet UIImageView *picLive;
// @property (nonatomic, retain) IBOutlet UIImageView *personPicLive;
@property (nonatomic, retain) IBOutlet UIImageView *emoticonLive;
@property (nonatomic, retain) IBOutlet UILabel *textLive;
@property (nonatomic, weak)     IBOutlet    UIImageView *textBorderImage;

@property (nonatomic, retain) IBOutlet UITextField *textFieldUserInput;
@property (nonatomic, retain) IBOutlet UIButton *buttonPenThis;
@property (nonatomic, retain) IBOutlet UIButton *buttonReset;
@property (nonatomic, retain) IBOutlet UIButton *buttonCancel;
@property (nonatomic, retain) IBOutlet UIButton *buttonSaveText;
@property (nonatomic, retain) IBOutlet UIButton *buttonCamera;
@property (nonatomic, retain) IBOutlet UIButton *buttonSleep;
@property (nonatomic, retain) IBOutlet UIButton *buttonPencil;
@property (nonatomic, retain)   IBOutlet    UILabel *labelSleep;

@property (nonatomic, retain) IBOutlet AwesomeMenu     *emoticonsMenu;
@property (nonatomic, retain) IBOutlet AwesomeMenuItem *emoticonHappy;
@property (nonatomic, retain) IBOutlet AwesomeMenuItem *emoticonOverjoyed;
@property (nonatomic, retain) IBOutlet AwesomeMenuItem *emoticonRomantic;
@property (nonatomic, retain) IBOutlet AwesomeMenuItem *emoticonSad;
@property (nonatomic, retain) IBOutlet AwesomeMenuItem *emoticonDepressed;
@property (nonatomic, retain) IBOutlet AwesomeMenuItem *emoticonAngry;

@end
