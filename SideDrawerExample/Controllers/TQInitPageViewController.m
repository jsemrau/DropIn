//
//  TQInitPageViewController.m
//  dropin
//
//  Created by tenqyu on 5/12/15.
//  Copyright © 2015 tenqyu. All rights reserved.
//

#import "TQInitPageViewController.h"
#import "PG_LoginVC.h"

@interface TQInitPageViewController ()

@end

@implementation TQInitPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Create the data model
    _pageTitles = @[@"", @"", @"",@"", @"",@""];
    _pageImages = @[@"page0.png",@"page1.png", @"page2.png", @"page3.png", @"page4.png", @"page5.png"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PageViewController

- (IBAction)startWalkthrough:(id)sender {
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        // here I am at the last page
        // then go to the app
         NSLog(@" Completed Walkthrough");
       // return nil;
       //   [self dismissPageViewController];
        
        /*
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PG_LoginVC *myVC = (PG_LoginVC *)[storyboard instantiateViewControllerWithIdentifier:@"LOGINVC"];
        [self presentViewController:myVC animated:YES completion:nil];*/
        
    
        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGINVC"];
        [self presentViewController:myController animated:NO completion:nil];
    
       // [self dismissViewControllerAnimated:NO completion:nil];
        
   
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)dismissPageViewController
{
    // Dismiss your page view controllers here.
    [self.pageViewController dismissViewControllerAnimated:NO completion:nil];
    self.pageViewController = nil;
    
    // Or remove the page view controllers from its parent view controller,
    [self.pageViewController willMoveToParentViewController:nil];
    [self.pageViewController removeFromParentViewController];
    [self.pageViewController didMoveToParentViewController:nil];
    
    // Or its view from its super view.
    [self.pageViewController.view removeFromSuperview];
    self.pageViewController = nil;
    
  
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
