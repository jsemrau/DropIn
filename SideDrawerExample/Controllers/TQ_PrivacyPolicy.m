//
//  TQ_PrivacyPolicy.m
//  dropin
//
//  Created by tenqyu on 7/12/15.
//  Copyright © 2015 tenqyu. All rights reserved.
//

#import "TQ_PrivacyPolicy.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"


@interface TQ_PrivacyPolicy ()

@end

@implementation TQ_PrivacyPolicy

@synthesize privacyPolicy;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.text = @"About";
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0];
    lblTitle.shadowColor = [UIColor whiteColor];
    lblTitle.shadowOffset = CGSizeMake(0, 1);
    lblTitle.font = [UIFont fontWithName:@"AvenirNext-Regular" size:17.0];
    [lblTitle sizeToFit];
    
    self.navigationItem.titleView = lblTitle;
}

- (void)viewDidLayoutSubviews {
    
    [self.privacyPolicy setContentOffset:CGPointZero animated:NO];
    
}

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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