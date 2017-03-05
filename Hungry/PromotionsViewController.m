//
//  PromotionsViewController.m
//  Hungry
//
//  Created by ioshero 11/2/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "PromotionsViewController.h"

@interface PromotionsViewController () <UITextFieldDelegate>
{
    
}
@property(weak, nonatomic) IBOutlet UITextField             *m_txtCode;
@end

@implementation PromotionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction) actionApply:(id)sender
{
    [self.m_txtCode resignFirstResponder];
}

@end
