//
//  TQ_LocationDenied.m
//  dropin
//
//  Created by tenqyu on 9/10/17.
//  Copyright © 2017 tenqyu. All rights reserved.
//

#import "TQ_LocationDenied.h"
#import "PG_LoginVC.h"
#import "TQInitPageViewController.h"

@interface TQ_LocationDenied ()

@end

@implementation TQ_LocationDenied

@synthesize settings, locationManager, currentLocation,hasNoRight, hasUpdated,shader,locRights;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locRights.text=[NSString stringWithFormat:NSLocalizedString(@"err-loc-rights", nil)];
    // Do any additional setup after loading the view.
    self.hasNoRight=true;
    self.hasUpdated=false;
    
    self.hasNoRight = [[GFLocationManager sharedInstance]checkSettings:self ];
    
    if(!self.hasNoRight){
        
        [[GFLocationManager sharedInstance] addLocationManagerDelegate:self];
        //This triggers the dialogue!! - DON'T DELETE
        [locationManager startUpdatingLocation];
        
        NSLog(@"Has proper rights");
        
        [self nextStep:self];
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
    } else {
        
        
        shader.alpha=0.0;
        
    }
    
    
    
    /******** Check background refresh **********/
    
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusAvailable) {
        
        NSLog(@"Background updates are available for the app.");
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied)
    {
        NSLog(@"The user explicitly disabled background behavior for this app or for the whole system.");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"game", nil)]
                                                        message:
                              [NSString stringWithFormat:NSLocalizedString(@"err-bg", nil)]
                              
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted)
    {
        NSLog(@"Background updates are unavailable and the user cannot enable them again. For example, this status can occur when parental controls are in effect for the current user.");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"game", nil)]
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"err-bg", nil)]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
   
    
   
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) gotoSettings {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"prefs:root=LOCATION_SERVICES"]];
   
    } else {
        NSURL *URL = [NSURL URLWithString:@"App-Prefs:root=Privacy&path=LOCATION"];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }
    
}

- (IBAction)nextStep:(id)sender {
    
    NSLog(@" Entered next step");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDetails = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"userData"] ] ;
    
    self.hasNoRight = [[GFLocationManager sharedInstance]checkSettings:self ];
    
    if (!self.hasNoRight) {
        
        if([userDetails count]>0){
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PG_LoginVC *myVC = (PG_LoginVC *)[storyboard instantiateViewControllerWithIdentifier:@"LOGINVC"];
            //LOGINVC
            [self presentViewController:myVC animated:YES completion:nil];
            
        } else {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TQInitPageViewController *myVC = (TQInitPageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"INITPAGEVC"];
            [self presentViewController:myVC animated:YES completion:nil];
            
        }
        
      /*  [self dismissViewControllerAnimated:NO completion:^{
            
            NSLog(@"Completed Denied Dismissal");
                                                                   
        }];*/
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"game", nil)]
                                                        message:
                              [NSString stringWithFormat:NSLocalizedString(@"err-fixrights", nil)]
                              
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark location delegate

- (void) locationManagerDidUpdateLocation:(CLLocation *)location {
    self.currentLocation = location;
    
    NSLog(@"Updated location in Location Denied");
    
    if(!self.hasNoRight && !self.hasUpdated) {
      self.hasUpdated=TRUE;
    }
    
}


@end
