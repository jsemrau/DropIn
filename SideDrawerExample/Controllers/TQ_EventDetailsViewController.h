//
//  TQ_EventDetailsViewController.h
//  SideDrawerExample
//
//  Created by tenqyu on 30/9/15.
//  Copyright © 2015 Pulkit Goyal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPin.h"
#import "MapOverlay.h"
#import <AddressBook/AddressBook.h>

@interface TQ_EventDetailsViewController : UIViewController <MKMapViewDelegate>

{
    /*
     NSString *distance;
     NSString *duration;
     NSInteger *going_count;
     NSInteger *max_count;
     NSString *latitude;
     NSString *longitude;
     NSString *price;
     NSDate *start_time;
     NSDate *stop_time;
     NSString *eTitle;
     NSString *eDescription;
     NSString *eURL;
    
    */
    
    
   IBOutlet UILabel *distance;
   IBOutlet UILabel *duration;
   IBOutlet UILabel *going_count;
   IBOutlet UILabel *max_count;
   float latitude;
   float longitude;
   NSString *vNameStr;
   NSString *eURL;
    
   IBOutlet UILabel *price;
   IBOutlet UILabel *start_time;
   IBOutlet UILabel *stop_time;
    
   IBOutlet NSString *vStart_time;
   IBOutlet NSString *vStop_time;
    
    
   IBOutlet UILabel *eTitle;
   IBOutlet UITextView *eDescription;
   
   IBOutlet UILabel *eSource;

   IBOutlet UILabel *vAddress;
   IBOutlet UILabel *vName;
   IBOutlet UILabel *vRecur;
    
   IBOutlet UILabel *fScore;
   IBOutlet UILabel *timeDiff;
    
    IBOutlet UIButton *openLocation;
    
    UIView *debugView;
    UIView *mapView;
    UIView *shareView;
    
    IBOutlet MKMapView *myMapView;
    
}

@property (retain, nonatomic) IBOutlet UILabel *distance;
@property (retain, nonatomic) IBOutlet  UILabel *duration;
@property (nonatomic) IBOutlet UILabel *going_count;
@property (nonatomic) IBOutlet UILabel *max_count;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) NSString *vNameStr;
@property (retain, nonatomic) IBOutlet UILabel *price;
@property (retain, nonatomic) IBOutlet UILabel *start_time;
@property (retain, nonatomic) IBOutlet UILabel *stop_time;
@property (retain, nonatomic) IBOutlet NSString *vStart_time;
@property (retain, nonatomic) NSString *vStop_time;
@property (retain, nonatomic) IBOutlet UILabel *eTitle;
@property (retain, nonatomic) IBOutlet UITextView *eDescription;
@property (retain, nonatomic) NSString *eURL;
@property (retain, nonatomic) IBOutlet UILabel *eSource;
@property (retain, nonatomic) IBOutlet UILabel *vAddress;
@property (retain, nonatomic) IBOutlet UILabel *vName;
@property (retain, nonatomic) IBOutlet UILabel *vRecur;

@property (retain, nonatomic) IBOutlet UILabel *fScore;
@property (retain, nonatomic) IBOutlet UILabel *timeDiff;

@property (retain, nonatomic) IBOutlet UIButton *openLocation;

@property(nonatomic, retain) IBOutlet UIView * debugView ;
@property(nonatomic, retain) IBOutlet UIView * mapView ;
@property(nonatomic, retain) IBOutlet UIView * shareView ;
@property (nonatomic, retain) IBOutlet MKMapView *myMapView;


- (IBAction)openURL:(id)sender;

@end
