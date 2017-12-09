//
//  TQ_LocationDenied.h
//  dropin
//
//  Created by tenqyu on 9/10/17.
//  Copyright © 2017 tenqyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFLocationManager.h"


@interface TQ_LocationDenied : UIViewController<GFLocationManagerDelegate>

{
    
    IBOutlet UIButton *settings;
    IBOutlet UIView *shader;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    BOOL hasNoRight;
    BOOL hasUpdated;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) CLLocation *currentLocation;
@property (retain, nonatomic) UIView *shader;


@property (nonatomic, assign) BOOL hasNoRight;
@property (nonatomic, assign) BOOL firstTime;
@property (nonatomic, assign) BOOL hasUpdated;

- (IBAction) gotoSettings;
- (IBAction) nextStep:(id)sender;

@property (nonatomic, retain) IBOutlet UIButton *settings;
@property (nonatomic, retain) IBOutlet UILabel *locRights;

@end
