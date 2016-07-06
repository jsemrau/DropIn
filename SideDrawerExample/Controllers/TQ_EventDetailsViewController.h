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
//#import <Socialize/Socialize.h>
#import <MessageUI/MessageUI.h>
#import "QyuWebAccess.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "FontAwesomeKit/FontAwesomeKit.h"
#import <ChameleonFramework/Chameleon.h>
#import "RKDropdownAlert.h"
#import <Spring/spring-Swift.h>

@interface TQ_EventDetailsViewController : UIViewController <MKMapViewDelegate,MFMessageComposeViewControllerDelegate,QyuWebDelegate>

{
    
   IBOutlet UILabel *distance;
    
   IBOutlet UILabel *duration;
   IBOutlet UILabel *going_count;
   IBOutlet UILabel *max_count;
   float latitude;
   float longitude;
    
   NSString *idStr;
   NSString *vNameStr;
   NSString *eURL;
   UILabel *scannedURL;
   NSString *vStart_time;
   NSString *vStop_time;
    
   IBOutlet UILabel *price;
   IBOutlet UILabel *start_time;
   IBOutlet UILabel *stop_time;
    
   IBOutlet UILabel *eTitle;
   IBOutlet UITextView *eDescription;
   
   IBOutlet UILabel *eSource;

   IBOutlet UILabel *vAddress;
   IBOutlet UILabel *vName;
   IBOutlet UILabel *vRecur;
    
   IBOutlet UILabel *fScore;
   IBOutlet UILabel *timeDiff;
    IBOutlet UILabel *inXminutes;
    
    IBOutlet UIButton *openLocation;
    IBOutlet UIButton *openURL;
    IBOutlet UIButton *favButton;
    IBOutlet UIButton *spamButton;
    IBOutlet UIButton *tweetButton;

    
    IBOutlet UIView *summaryView;
    
    UIView *debugView;
    UIView *shareView;
    
   
    UIColor *themeColor;
    
    IBOutlet MKMapView *myMapView;
    IBOutlet UIImageView *vSource;
    IBOutlet UIImageView *triangle;
    
    NSMutableDictionary *likedIDs;
    NSMutableDictionary *userDetails;
    NSMutableDictionary *handOver;
    
    int activePage;
    bool socialActive;
    
     CGRect socialLocation;
    
}

@property (retain, nonatomic) IBOutlet UILabel *distance;
@property (retain, nonatomic) IBOutlet  UILabel *duration;
@property (nonatomic) IBOutlet UILabel *going_count;
@property (nonatomic) IBOutlet UILabel *max_count;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) int activePage;
@property (nonatomic) bool socialActive;
@property (nonatomic) NSString *vNameStr;
@property (nonatomic) NSString *idStr;
@property (retain, nonatomic) IBOutlet UILabel *price;
@property (retain, nonatomic) IBOutlet UIImageView *category;
@property (retain, nonatomic) IBOutlet UILabel *start_time;
@property (retain, nonatomic) IBOutlet UILabel *stop_time;
@property (retain, nonatomic) NSString *vStart_time;
@property (retain, nonatomic) NSString *vStop_time;
@property (retain, nonatomic) IBOutlet UILabel *eTitle;
@property (retain, nonatomic) IBOutlet UITextView *eDescription;
@property (retain, nonatomic) NSString *eURL;
@property (retain, nonatomic) UIColor *themeColor;

@property (retain, nonatomic) IBOutlet UIImageView *clockImg;

@property (retain, nonatomic) IBOutlet UILabel *scannedURL;

@property (retain, nonatomic) IBOutlet UILabel *eSource;
@property (retain, nonatomic) IBOutlet UILabel *vAddress;
@property (retain, nonatomic) IBOutlet UILabel *vName;
@property (retain, nonatomic) IBOutlet UILabel *vRecur;

@property (retain, nonatomic) IBOutlet UILabel *fScore;
@property (retain, nonatomic) IBOutlet UILabel *timeDiff;
@property (retain, nonatomic) IBOutlet UILabel *inXminutes;

@property (retain, nonatomic) IBOutlet UIButton *openLocation;
@property (retain, nonatomic) IBOutlet UIButton *openURL;
@property (retain, nonatomic) IBOutlet UIButton *favButton;
@property (retain, nonatomic) IBOutlet UIButton *spamButton;

@property (retain, nonatomic) IBOutlet UIButton *tweetButton;
@property (retain, nonatomic) IBOutlet UIButton *wAppButton;
@property (retain, nonatomic) IBOutlet UIButton *fbButton;
@property (retain, nonatomic) IBOutlet UIButton *chatButton;


@property(nonatomic, retain) IBOutlet UIView * debugView ;
@property(nonatomic, retain) IBOutlet UIView * shareView ;
@property(nonatomic, retain) IBOutlet UIView * summaryView ;

@property (nonatomic, retain) IBOutlet MKMapView *myMapView;

@property (nonatomic, strong) NSMutableDictionary *likedIDs;
@property (nonatomic, retain) NSMutableDictionary *userDetails;

@property (nonatomic, strong) NSMutableDictionary *handOver;

@property (retain, nonatomic) IBOutlet UIImageView *vSource;
@property (retain, nonatomic) IBOutlet UIImageView *triangle;
@property (nonatomic) CGRect socialLocation;
@property (retain,nonatomic) NSMutableArray *constraintArray;


@property (nonatomic, strong) IBOutlet UISwipeGestureRecognizer *page1TapRecognizer;
@property (nonatomic, strong) IBOutlet UISwipeGestureRecognizer *page2TapRecognizer;

//@property (nonatomic, retain) SZActionBar *actionBar;
//@property (nonatomic, retain) id<SZEntity> entity;

- (IBAction)openURL:(id)sender;
- (IBAction) sendSMS ;
- (IBAction) sendWhatsApp:(id)sender;
- (IBAction) sendFB:(id)sender;

-(IBAction) toggleSocial:(id)sender;
- (void) setupButtons ;

@end
