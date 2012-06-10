//
//  NoteEntryView.m
//  EmotionalJourney
//
//  Created by Administrator on 19/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoteEntryView.h"

@class com_FirstViewController;


@implementation NoteEntryView

@synthesize homeView;
@synthesize liveNoteViewSmall;
@synthesize liveNoteImageSmall;

@synthesize liveNoteViewBig;
@synthesize emoticonLive;
@synthesize picLive;
// @synthesize personPicLive;
@synthesize textLive;
@synthesize textBorderImage;

@synthesize textFieldUserInput;
@synthesize buttonSaveText;
@synthesize buttonPenThis;
@synthesize buttonCancel;
@synthesize buttonReset;
@synthesize buttonCamera;
@synthesize buttonSleep;
@synthesize buttonPencil;
@synthesize labelSleep;

@synthesize emoticonsMenu;
@synthesize emoticonHappy;
@synthesize emoticonOverjoyed;
@synthesize emoticonRomantic;
@synthesize emoticonSad;
@synthesize emoticonDepressed;
@synthesize emoticonAngry;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self.liveNoteViewBig ) {
        NSLog(@"NoteEntryView.liveNoteViewBig tapped");
    }
    
    /*
     if ([touch view] == self.picLive ) {
        NSLog(@"NoteEntryView.setHomeView: User has chosen to add a photo");
        [self.homeView addPicOrVideo];
        
    }
    */

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
