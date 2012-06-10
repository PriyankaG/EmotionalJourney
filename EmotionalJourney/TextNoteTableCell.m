//
//  EmotionNoteTableCell.m
//  EmotionalJourney
//
//  Created by Administrator on 01/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextNoteTableCell.h"
#import "com_FirstViewController.h"

#define kNoteEmotionTag 1
#define kNoteTextTag    2
#define kNoteImageTag   3
#define kNameValueTag   4
#define kColorValueTag  5

#define kNoteSleptWell      @"Slept well"
#define kNoteSleptUnwell    @"Didn't sleep well"
#define kSleptWell                  1
#define kDidntSleepWell             0

@implementation TextNoteTableCell

@synthesize picView;
@synthesize buttonShare;
@synthesize noteEmotion;
@synthesize noteText;
@synthesize noteSleep;
@synthesize noteShare;
@synthesize noteEmotionView;
@synthesize noteTextLabel;
@synthesize viewController;
@synthesize labelSleepNote;


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
    

-(void)setNoteEmotion:(UIImage *)emotion {
    NSLog(@"TextNoteTableCell: setNoteEmotion");
    noteEmotion = [emotion copy];
    //noteEmotionView = (UIImageView *)[self.contentView viewWithTag:kNoteEmotionTag];
    noteEmotionView.image = noteEmotion;
    noteEmotionView.contentMode = UIViewContentModeScaleAspectFill;
}


- (void)setNoteText:(NSString *)text {
    NSLog(@"TextNoteTableCell: setNoteText");
    if (![text isEqualToString:noteText]) {
        noteText = [text copy];
        //noteTextLabel = (UILabel *)[self.contentView viewWithTag:kNoteTextTag];
        noteTextLabel.text = noteText; 
    }
}


- (void)setNoteSleep:(int)slept {
    
    NSLog(@"TextNoteTableCell: setNoteSleep");
    noteSleep = slept;
    if (noteSleep == kSleptWell) {
        labelSleepNote.text = kNoteSleptWell;
        
    } else {
        labelSleepNote.text = kNoteSleptUnwell;
    }
}


-(void)setFirstViewController:(com_FirstViewController *)controller {
    viewController = [[com_FirstViewController alloc] init];
    viewController = controller;
    NSLog(@"Done setting the FirstViewController instance in the cell");
}


-(IBAction)showMailComposer:(id)sender {
    NSLog(@"showMailComposer triggered. Calling showEmailComposer in FirstViewController");
    [self.viewController showEmailComposerWithText:noteText
                                       withEmoticon:noteEmotion
                                       withPicture:nil];
}
              
@end
