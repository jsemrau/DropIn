//
//  LocationController.h
//  ParkerMeister
//
//  Created by Ganesha on 21/2/15.
//  Copyright (c) 2015 tenqyu. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// protocol for sending location updates to another view controller
@protocol LocationControllerDelegate
@required
- (void)locationUpdate:(CLLocation*)location;
@end

@interface LocationController : NSObject<CLLocationManagerDelegate>

+ (LocationController*)sharedInstance; // Singleton method
//@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;



- (void) addLocationManagerDelegate:(id<LocationControllerDelegate>) delegate;
- (void) removeLocationManagerDelegate:(id<LocationControllerDelegate>) delegate;

@end