//
//  GFLocationManager.h
//  ParkerMeister
//
//  Created by Ganesha on 22/2/15.
//  Copyright (c) 2015 tenqyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GFLocationManagerDelegate

- (void)locationManagerDidUpdateLocation:(CLLocation *)location;

@end

@interface GFLocationManager : NSObject<CLLocationManagerDelegate>

{
    
    CLLocation *currentLocation;
    
}

@property (retain, nonatomic) CLLocation *currentLocation;

+ (GFLocationManager *)sharedInstance;
- (void) addLocationManagerDelegate:(id<GFLocationManagerDelegate>) delegate;
- (void) removeLocationManagerDelegate:(id<GFLocationManagerDelegate>) delegate;
- (BOOL) checkSettings:(id<GFLocationManagerDelegate>)delegate;

@end
