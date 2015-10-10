//
//  LocationController.m
//  ParkerMeister
//
//  Created by Ganesha on 21/2/15.
//  Copyright (c) 2015 tenqyu. All rights reserved.
//

#import "LocationController.h"

@interface LocationController()

@property (strong, nonatomic) CLLocationManager* manager;
@property (strong, nonatomic) NSMutableArray *observers;

@end

@implementation LocationController

static int errorCount = 0;
#define MAX_LOCATION_ERROR 3

//This is a singleton the objective-c way
+ (LocationController*) sharedInstance {
    static LocationController *sharedInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        
        //Must check authorizationStatus before initiating a CLLocationManager
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusRestricted && status == kCLAuthorizationStatusDenied) {
        } else {
            _manager = [[CLLocationManager alloc] init];
            _manager.delegate = self;
            _manager.desiredAccuracy = kCLLocationAccuracyBest;
        }
        if (status == kCLAuthorizationStatusNotDetermined) {
            //Must check if selector exists before messaging it
            if ([_manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_manager requestWhenInUseAuthorization];
            }
        }
        
        _observers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addLocationManagerDelegate:(id<LocationControllerDelegate>)delegate {
    if (![self.observers containsObject:delegate]) {
        [self.observers addObject:delegate];
    }
    [self.manager startUpdatingLocation];
}

- (void) removeLocationManagerDelegate:(id<LocationControllerDelegate>)delegate {
    if ([self.observers containsObject:delegate]) {
        [self.observers removeObject:delegate];
    }
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //[self.manager stopUpdatingLocation];
    for(id<LocationControllerDelegate> observer in self.observers) {
        if (observer) {
            self.currentLocation=[locations lastObject];
            [observer locationUpdate:[locations lastObject]];
        }
    }
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    errorCount += 1;
    if(errorCount >= MAX_LOCATION_ERROR) {
        [self.manager stopUpdatingLocation];
        errorCount = 0;
    }
}

@end