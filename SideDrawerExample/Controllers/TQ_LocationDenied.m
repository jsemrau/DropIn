//
//  TQ_LocationDenied.m
//  dropin
//
//  Created by tenqyu on 9/10/17.
//  Copyright © 2017 tenqyu. All rights reserved.
//

#import "TQ_LocationDenied.h"
#import "PG_LoginVC.h"

@interface TQ_LocationDenied ()

@end

@implementation TQ_LocationDenied

@synthesize settings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) gotoSettings {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 11.0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"prefs:root=LOCATION_SERVICES"]];
    } else {
        NSURL *URL = [NSURL URLWithString:@"App-Prefs:root=Privacy&path=LOCATION"];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }
    
}

- (IBAction) moveToLogin:(id)sender {
    
    NSLog(@" Entered move 2 Login");
    
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        
        PGViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN_VIEW_CONTROLLER"];
        
        [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
        
        [self presentViewController:centerViewController animated:TRUE completion:nil];
        
        
    });*/
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PG_LoginVC *myVC = (PG_LoginVC *)[storyboard instantiateViewControllerWithIdentifier:@"LOGINVC"];
    [self presentViewController:myVC animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
