//
//  TQInitPageViewController.h
//  dropin
//
//  Created by tenqyu on 5/12/15.
//  Copyright © 2015 tenqyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"


@interface TQInitPageViewController : UIViewController <UIPageViewControllerDataSource>


@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

- (IBAction)startWalkthrough:(id)sender;



@end
