//
//  EmotionNoteTableCell.m
//  EmotionalJourney
//
//  Created by Administrator on 01/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageNoteTableCell.h"
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

@implementation ImageNoteTableCell

@synthesize buttonShare;
@synthesize noteEmoticon;
@synthesize noteImage;
@synthesize imageOriginal;
@synthesize noteShare;
@synthesize noteEmoticonView;
@synthesize noteImageView;
@synthesize viewController;
@synthesize picView;
@synthesize labelSleepNote;
@synthesize noteSleep;


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
      


-(void)setNoteEmoticon:(UIImage *)emoticon {
    NSLog(@"ImageNoteTableCell: setNoteEmotion");
    noteEmoticon = [emoticon copy];
    //noteEmotionView = (UIImageView *)[self.contentView viewWithTag:kNoteEmotionTag];
    noteEmoticonView.image = noteEmoticon;
    noteEmoticonView.contentMode = UIViewContentModeScaleAspectFill;
}



- (void)setNoteImage:(UIImage *)image {
    NSLog(@"ImageNoteTableCell: setNoteImage");
    noteImage = [image copy];
    //noteImageView = (UIImageView *)[self.contentView viewWithTag:kNoteImageTag];
    noteImageView.image = noteImage;
    noteImageView.contentMode = UIViewContentModeScaleAspectFill;
}


- (void)setNoteSleep:(int)slept {
    
    NSLog(@"ImageNoteTableCell: setNoteSleep");
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
    NSLog(@"ImageNoteTableCell: Done setting the FirstViewController instance in the cell");
}



-(IBAction)showMailComposer:(id)sender {
    NSLog(@"ImageNoteTableCell: showMailComposer triggered. Calling showEmailComposer in FirstViewController");
    [self.viewController showEmailComposerWithText:nil
                                       withEmoticon:noteEmoticon
                                       withPicture:noteImage];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if ( [touch view] == self.noteImageView ) {
        NSLog(@"ImageNoteTableCell.noteImageView tapped");
        NSLog(@"touchesBegan: img size:%f", self.imageOriginal.size.width);
        [self.viewController displayFullPic:self.imageOriginal];
    }
} 

@end
