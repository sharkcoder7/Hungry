//
//  ShareViewController.m
//  Hungry
//
//  Created by ioshero 10/5/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()
{
    
}

@property (weak, nonatomic) IBOutlet UIImageView *m_imgTitle;
@end

@implementation ShareViewController

//====================================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//====================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//====================================================================================================
- (void) initMember
{
    [super initMember];
    
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:(void (^)(void)) ^{
                         self.m_imgTitle.transform=CGAffineTransformMakeScale(0.8, 0.8);
                     }
                     completion:^(BOOL finished){
                     }];
}

//====================================================================================================
- (IBAction)actionFB:(id)sender
{
    
}

//====================================================================================================
- (IBAction)actionTwitter:(id)sender
{
    
}

//====================================================================================================
- (IBAction)actionInstagram:(id)sender
{
    
}

//====================================================================================================
- (IBAction)actionGooglePlus:(id)sender
{
    
    
}

//====================================================================================================
- (IBAction)actionSnapChat:(id)sender
{
    
}

//====================================================================================================
- (IBAction)actionPin:(id)sender
{
    
}

//====================================================================================================
- (IBAction)actionEmail:(id)sender
{
    
}

//====================================================================================================
- (IBAction)actionText:(id)sender
{
    
}

//====================================================================================================
- (IBAction)actionRate:(id)sender
{
    
}

//====================================================================================================

@end

