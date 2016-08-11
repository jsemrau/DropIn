//
//  TQ_MapVC.h
//  dropin
//
//  Created by tenqyu on 11/10/15.
//  Copyright © 2015 tenqyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFLocationManager.h"
#import "QyuWebAccess.h"
#import <MapKit/MapKit.h>
#import "MapPin.h"
#import "MapOverlay.h"
#import <AudioToolbox/AudioToolbox.h>
#import "FontAwesomeKit/FontAwesomeKit.h"
#import "FontAwesomeKit/FAKZocial.h"
#import "FontAwesomeKit/FontAwesomeKit/FAKIonIcons.h"
#import <ChameleonFramework/Chameleon.h>


@interface TQ_MapVC : UIViewController <GFLocationManagerDelegate,MKMapViewDelegate,QyuWebDelegate>

{
    IBOutlet MKMapView *myMapView;
    IBOutlet UIView *explainer;
    IBOutlet UIView *selectDialog;
    
    bool gettingUpdates;
    float distance;
    
    CLLocation *setLocation;
}

@property (retain, nonatomic) CLLocation *currentLocation;
@property (nonatomic, retain) CLLocation *setLocation;

@property(nonatomic, retain) NSArray *eventList;

@property (nonatomic, retain) IBOutlet MKMapView *myMapView;
@property (nonatomic, retain) IBOutlet UIGestureRecognizer *tapRecog;
@property (nonatomic, retain) IBOutlet UIView *explainer;
@property (nonatomic, retain) IBOutlet UIView *selectDialog;

@property (nonatomic) float distance;

- (IBAction)removeClueView:(id)sender  ;


@end
