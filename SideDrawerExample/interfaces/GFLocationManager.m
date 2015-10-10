//
//  GFLocationManager.m
//  ParkerMeister
//
//  Created by Ganesha on 22/2/15.
//  Copyright (c) 2015 tenqyu. All rights reserved.
//

#import "GFLocationManager.h"

@interface GFLocationManager()

@property (strong, nonatomic) CLLocationManager* manager;
@property (strong, nonatomic) NSMutableArray *observers;

@end

@implementation GFLocationManager

@synthesize currentLocation;

static int errorCount = 0;
#define MAX_LOCATION_ERROR 3

//This is a singleton the objective-c way
+ (GFLocationManager*) sharedInstance {
    static GFLocationManager *sharedInstance = nil;
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
            _manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            _manager.distanceFilter=10.0;
        }
        if (status == kCLAuthorizationStatusNotDetermined) {
            //Must check if selector exists before messaging it
            if ([_manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_manager requestWhenInUseAuthorization];
            }
            
            if ([_manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_manager requestAlwaysAuthorization];
            }
        }
        
        _observers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addLocationManagerDelegate:(id<GFLocationManagerDelegate>)delegate {
    if (![self.observers containsObject:delegate]) {
        [self.observers addObject:delegate];
    }
    [self.manager startUpdatingLocation];
}

- (void) removeLocationManagerDelegate:(id<GFLocationManagerDelegate>)delegate {
    if ([self.observers containsObject:delegate]) {
        [self.observers removeObject:delegate];
    }
}


#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.manager stopUpdatingLocation];
    for(id<GFLocationManagerDelegate> observer in self.observers) {
        if (observer) {
            [observer locationManagerDidUpdateLocation:[locations lastObject]];
        }
    }
    
    self.currentLocation = [locations lastObject];
  //  NSLog(@"*********** %@ ********", self.currentLocation);
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
