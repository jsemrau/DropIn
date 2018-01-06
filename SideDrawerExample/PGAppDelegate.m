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
    

    [Fabric with:@[[Twitter class]]];
    
    QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"updateDailyPreferences"];
    [webby setDelegate:self];
    [webby sendDailyEventPrefs];
    
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
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                              
                              if(granted){
                                  
                              UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
                              content.title = [NSString localizedUserNotificationStringForKey:@"Wake up!" arguments:nil];
                              content.body = [NSString localizedUserNotificationStringForKey:@"Rise and shine! It's morning time!"
                                                                                   arguments:nil];
                              
                              // Configure the trigger for a 7am wakeup.
                              NSDateComponents* date = [[NSDateComponents alloc] init];
                              date.hour = 9;
                              date.minute = 34;
                              UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger
                                                                        triggerWithDateMatchingComponents:date repeats:NO];
                              
                              // Create the request object.
                              UNNotificationRequest* request = [UNNotificationRequest
                                                                requestWithIdentifier:@"MorningAlarm" content:content trigger:trigger];
                              
                              UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
                              [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                  if (error != nil) {
                                      NSLog(@"%@", error.localizedDescription);
                                  }
                              }];
                              
                              } // granted
                              
                          }];
    
    
}

- (void)notificationsReceived:(NSDictionary *)resultData{}
- (void)locationsReceived:(NSDictionary *)resultData{}
- (void) noLocationsReceived{}

@end
