//
//  TQ_Favorites.m
//  dropin
//
//  Created by tenqyu on 24/10/16.
//  Copyright © 2016 tenqyu. All rights reserved.
//

#import "TQ_Favorites.h"

@interface TQ_Favorites ()

@end

@implementation TQ_Favorites

@synthesize likedIDs;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *prefs;
    
    prefs= [NSUserDefaults standardUserDefaults];
    self.likedIDs=[[prefs objectForKey:@"likedItems"] mutableCopy];
    
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
