//
//  ViewController.m
//  Hungry
//
//  Created by ioshero 9/22/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"

@interface ViewController ()
{
    
}

@property (weak, nonatomic) IBOutlet UIImageView *m_imgLoadingBar;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgDishBar1;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgDishBar2;

@end

@implementation ViewController

//====================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
}

//====================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//====================================================================================================
-(void) initMember
{
    [super initMember];
    
    [self rotateLoadingImageView];
    
    self.m_imgDishBar2.frame = CGRectMake(self.m_imgDishBar1.frame.origin.x + self.m_imgDishBar1.frame.size.width + DISH_BAR_INTENT,
                                          self.m_imgDishBar2.frame.origin.y,
                                          self.m_imgDishBar2.frame.size.width,
                                          self.m_imgDishBar2.frame.size.height);
    [self movingDishBar: YES];
    
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(loadDeals) name: NOTI_UPDATED_LOCATION object: nil];
    [self performSelector: @selector(gotoNextView) withObject: self afterDelay: 3.0f];
}

//====================================================================================================
-(void) gotoNextView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *nextView = (MainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"main_view"];
    [self.navigationController pushViewController: nextView animated: YES];
}

//====================================================================================================
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
}

//====================================================================================================
-(void) loadDeals
{
    if([AppDelegate getDelegate].m_fCurLat == 0 && [AppDelegate getDelegate].m_fCurLng == 0)
    {
        NSLog(@"location services error");
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver: self name: NOTI_UPDATED_LOCATION object: nil];
    
    [self queryInfoForTerm: @"dish"
                                  lat: [AppDelegate getDelegate].m_fCurLat
                                  lng: [AppDelegate getDelegate].m_fCurLng
                    completionHandler: ^(NSArray *arrData, NSError* error)
    {

        
//        if(error == nil)
//        {
//            NSLog(@"result = %@", arrData);
//            
//            if(arrData == nil)
//            {
//                NSMutableArray* arrDishes = [[NSMutableArray alloc] init];
//                [arrDishes addObjectsFromArray: arrData];
//                
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                MainViewController *nextView = (MainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"main_view"];
//                nextView.m_arrDishes = arrDishes;
//                [self.navigationController pushViewController: nextView animated: YES];
//            }
//        }
//        else
//        {
//            NSLog(@"error = %@", error);
//        }
    }];
}

//====================================================================================================
- (void)rotateLoadingImageView
{
    [UIView animateWithDuration:LOADING_BAR_ANIMATION_DURATION delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.m_imgLoadingBar setTransform:CGAffineTransformRotate(self.m_imgLoadingBar.transform, M_PI_2)];
    }completion:^(BOOL finished){
        if (finished) {
            [self rotateLoadingImageView];
        }
    }];
}

//====================================================================================================
-(void) movingDishBar: (BOOL) bFirst
{
    float fx = -self.m_imgDishBar1.frame.size.width;
    if(bFirst)
    {
        [UIView animateWithDuration:LOADING_DISH_ANIMATION_DURATION delay:0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             self.m_imgDishBar1.frame = CGRectMake(fx,
                                                   self.m_imgDishBar1.frame.origin.y,
                                                   self.m_imgDishBar1.frame.size.width,
                                                   self.m_imgDishBar1.frame.size.height);
             self.m_imgDishBar2.frame = CGRectMake(fx + self.m_imgDishBar1.frame.size.width + DISH_BAR_INTENT,
                                                   self.m_imgDishBar2.frame.origin.y,
                                                   self.m_imgDishBar2.frame.size.width,
                                                   self.m_imgDishBar2.frame.size.height);
             
         }completion:^(BOOL finished){
             if (finished)
             {
                 self.m_imgDishBar1.frame = CGRectMake(self.m_imgDishBar1.frame.size.width + DISH_BAR_INTENT,
                                                       self.m_imgDishBar1.frame.origin.y,
                                                       self.m_imgDishBar1.frame.size.width,
                                                       self.m_imgDishBar1.frame.size.height);
                 
                 [self movingDishBar: NO];
             }
         }];
    }
    else
    {
        [UIView animateWithDuration:LOADING_DISH_ANIMATION_DURATION delay:0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             self.m_imgDishBar2.frame = CGRectMake(fx,
                                                   self.m_imgDishBar1.frame.origin.y,
                                                   self.m_imgDishBar1.frame.size.width,
                                                   self.m_imgDishBar1.frame.size.height);
             self.m_imgDishBar1.frame = CGRectMake(fx + self.m_imgDishBar1.frame.size.width + DISH_BAR_INTENT,
                                                   self.m_imgDishBar2.frame.origin.y,
                                                   self.m_imgDishBar2.frame.size.width,
                                                   self.m_imgDishBar2.frame.size.height);
             
         }completion:^(BOOL finished){
             if (finished)
             {
                 self.m_imgDishBar2.frame = CGRectMake(self.m_imgDishBar1.frame.size.width + DISH_BAR_INTENT,
                                                       self.m_imgDishBar1.frame.origin.y,
                                                       self.m_imgDishBar1.frame.size.width,
                                                       self.m_imgDishBar1.frame.size.height);
                 
                 [self movingDishBar: YES];
             }
         }];
    }
}

//====================================================================================================
@end
