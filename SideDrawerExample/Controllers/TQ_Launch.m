//
//  TQ_Launch.m
//  dropin
//
//  Created by tenqyu on 22/2/17.
//  Copyright © 2017 tenqyu. All rights reserved.
//

#import "TQ_Launch.h"

@interface TQ_Launch ()

@end

@implementation TQ_Launch

@synthesize scrollingImage,scrollingView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage* image = scrollingImage.image;
    scrollingImage.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    scrollingView.contentSize = image.size;
    
    /*[UIView beginAnimations:@"pan" context:nil];
    [UIView setAnimationDuration:animationDuration];
    scrollingView.contentOffset = newRect.origin;
    [UIView commitAnimations];
    */
    
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
