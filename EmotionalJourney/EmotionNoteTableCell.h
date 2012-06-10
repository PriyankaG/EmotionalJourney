//
//  EmotionNoteTableCell.h
//  EmotionalJourney
//
//  Created by Administrator on 01/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "com_FirstViewController.h"


/**
 * MFMailComposeViewControllerDelegate: For the Mail feature
 */
@interface EmotionNoteTableCell : UITableViewCell {
    
    UIImageView *picView;
}

@property (copy, nonatomic) UIImage *noteEmotion;
@property (strong, nonatomic) IBOutlet UIImageView *noteEmotionView;
@property (copy, nonatomic) UIImage *noteImage;
@property (strong, nonatomic) IBOutlet UIImageView *noteImageView;
@property (copy, nonatomic) UIImage *notePersonPic;
@property (strong, nonatomic) IBOutlet UIImageView *notePersonPicView;
@property (copy, nonatomic) NSString *noteText;
@property (strong, nonatomic) IBOutlet UILabel *noteTextLabel;
@property (copy, nonatomic) UIButton *noteShare;
@property (strong, nonatomic) IBOutlet UIButton *buttonShare;
@property (retain, nonatomic) com_FirstViewController *viewController;
@property (nonatomic, retain) IBOutlet UIImageView *picView;
@property (strong, nonatomic) IBOutlet UILabel *labelSleepNote;
@property (nonatomic) int noteSleep;
@property (copy, nonatomic) UIImage *imageOriginal;


-(IBAction)showMailComposer:(id)sender;
-(void)setFirstViewController:(com_FirstViewController *)controller;

@end
