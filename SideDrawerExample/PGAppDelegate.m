//
//  PGAppDelegate.m
// SideDrawerExample
//
//  Created by Pulkit Goyal on 11/12/13.
//  Copyright (c) 2013 Pulkit Goyal. All rights reserved.
//

#import "PGAppDelegate.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <GoogleConversionTracking/ACTReporter.h>

@implementation PGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     // Override point for customization after application launch.
   
    UIBarButtonItem *barButtonAppearance = [UIBarButtonItem appearance];
    [barButtonAppearance setTintColor:[UIColor flatSkyBlueColor]];
    
    
    //[self setupDailyNotification];
    
    // [Socialize storeConsumerKey:@"92c84474-5d99-4825-8a97-bccf2b413f93"];
    //[Socialize storeConsumerSecret:@"ce5251ad-8b7b-409d-9721-6532b9a4c82b"];
   
    [Fabric with:@[[Twitter class]]];

    /*
     No need for global theme
     [Chameleon setGlobalThemeUsingPrimaryColor:[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] withContentStyle:UIContentStyleLight];
    */
    
    [[GFLocationManager sharedInstance] addLocationManagerDelegate:self];
    
    // dropin-installs
    // Google iOS first open tracking snippet
    // Add this code to your application delegate's
    // application:didFinishLaunchingWithOptions: method.
    
    [ACTConversionReporter reportWithConversionID:@"979706255" label:@"I55YCM-AiG0Qj8OU0wM" value:@"1.00" isRepeatable:NO];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[GFLocationManager sharedInstance] removeLocationManagerDelegate:self];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[GFLocationManager sharedInstance] addLocationManagerDelegate:self];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
     [[GFLocationManager sharedInstance] addLocationManagerDelegate:self];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[GFLocationManager sharedInstance] removeLocationManagerDelegate:self];
    
}

#pragma mark location delegate

- (void) locationManagerDidUpdateLocation:(CLLocation *)location {
    
    NSLog(@"Updated Location");
    
}


#pragma mark custom functions

- (void) setupDailyNotification {
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:9];
    // Gives us today's date but at 9am
    NSDate *next9am = [calendar dateFromComponents:components];
    if ([next9am timeIntervalSinceNow] < 0) {
        // If today's 9am already occurred, add 24hours to get to tomorrow's
        next9am = [next9am dateByAddingTimeInterval:60*60*24];
    }
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = next9am;
    notification.alertBody = @"It's been 24 hours.";
    // Set a repeat interval to daily
    notification.repeatInterval = NSCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
 

}

@end
