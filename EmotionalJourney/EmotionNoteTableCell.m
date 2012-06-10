//
//  EmotionNoteTableCell.m
//  EmotionalJourney
//
//  Created by Administrator on 01/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EmotionNoteTableCell.h"
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

@implementation EmotionNoteTableCell

@synthesize buttonShare;
@synthesize noteEmotion;
@synthesize noteText;
@synthesize noteImage;
@synthesize notePersonPic;
@synthesize noteShare;
@synthesize noteEmotionView;
@synthesize noteImageView;
@synthesize notePersonPicView;
@synthesize noteTextLabel;
@synthesize viewController;
@synthesize picView;
@synthesize noteSleep;
@synthesize labelSleepNote;
@synthesize imageOriginal;


/*
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // For displaying the Emoticon
        // CGRect -> x, y, width, height
        CGRect noteEmotionRect = CGRectMake(0, 5, 27, 13);
        noteEmotionView = [[UIImageView alloc] initWithFrame:noteEmotionRect];
        noteEmotionView.tag = kNoteEmotionTag;
        [self.contentView addSubview:noteEmotionView];
        
        // For displaying the button that enables sharing
        CGRect noteButtonRect = CGRectMake(0, 26, 70, 15);
        buttonShare = [[UIButton alloc] initWithFrame:noteButtonRect];
        //buttonShare.titleLabel.text = @"Share";
        buttonShare.alpha=1;
        [self.contentView addSubview:buttonShare];
        
        // For displaying the text
        CGRect noteTextRect = CGRectMake(80, 5, 200, 15); 
        noteTextLabel = [[UILabel alloc] initWithFrame:noteTextRect];
        noteTextLabel.tag = kNoteTextTag;
        [self.contentView addSubview:noteTextLabel];
        
        // For displaying the image, if any, chosen by the user
        CGRect noteImageRect = CGRectMake(80, 25, 200, 15); 
        noteImageView = [[UIImageView alloc] initWithFrame:noteImageRect];
        noteImageView.tag = kNoteImageTag;
        [self.contentView addSubview:noteImageView];
    }
    return self;
}
*/


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
      

-(void)setNoteEmotion:(UIImage *)emotion {
    NSLog(@"EmotionNoteTableCell: setNoteEmotion");
    noteEmotion = [emotion copy];
    //noteEmotionView = (UIImageView *)[self.contentView viewWithTag:kNoteEmotionTag];
    noteEmotionView.image = noteEmotion;
    noteEmotionView.contentMode = UIViewContentModeScaleAspectFill;
}



- (void)setNoteText:(NSString *)text {
    NSLog(@"EmotionNoteTableCell: setNoteText");
    if (![text isEqualToString:noteText]) {
        noteText = [text copy];
        //noteTextLabel = (UILabel *)[self.contentView viewWithTag:kNoteTextTag];
        noteTextLabel.text = noteText; 
    }
}


- (void)setNoteSleep:(int)slept {
    
    NSLog(@"EmotionNoteTableCell: setNoteSleep");
    noteSleep = slept;
    if (noteSleep == kSleptWell) {
        labelSleepNote.text = kNoteSleptWell;
        
    } else {
        labelSleepNote.text = kNoteSleptUnwell;
    }
}


- (void)setNoteImage:(UIImage *)image {
    NSLog(@"EmotionNoteTableCell: setNoteImage");
    noteImage = [image copy];
    //noteImageView = (UIImageView *)[self.contentView viewWithTag:kNoteImageTag];
    noteImageView.image = noteImage;
    noteImageView.contentMode = UIViewContentModeScaleAspectFill;
}


- (void)setNotePersonPic:(UIImage *)image {
    NSLog(@"EmotionNoteTableCell: setNotePersonPic");
    notePersonPic = [image copy];
    //noteImageView = (UIImageView *)[self.contentView viewWithTag:kNoteImageTag];
    notePersonPicView.image = notePersonPic;
    notePersonPicView.contentMode = UIViewContentModeScaleAspectFill;
}

-(void)setFirstViewController:(com_FirstViewController *)controller {
    viewController = [[com_FirstViewController alloc] init];
    viewController = controller;
    NSLog(@"EmotionNoteTableCell: Done setting the FirstViewController instance in the cell");
}



-(IBAction)showMailComposer:(id)sender {
    NSLog(@"EmotionNoteTableCell: showMailComposer triggered. Calling showEmailComposer in FirstViewController");
    [self.viewController showEmailComposerWithText:noteText
                                       withEmoticon:noteEmotion
                                       withPicture:noteImage];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if ( [touch view] == self.noteImageView ) {
        NSLog(@"EmotionNoteTableCell.noteImageView tapped");
        NSLog(@"touchesBegan: img size:%f", self.imageOriginal.size.width);
        [self.viewController displayFullPic:self.imageOriginal];
    }
} 

              
@end
