//
//  PG_LoginVC.h
//  ParkerMeister
//
//  Created by Ganesha on 21/2/15.
//  Copyright (c) 2015 tenqyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFLocationManager.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <MapKit/MapKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "PGFirstViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "RKDropdownAlert.h"
#import "UIViewController+MMDrawerController.h"
#import "DGActivityIndicatorView.h"
#import "FontAwesomeKit/FontAwesomeKit.h"

#import "PGViewController.h"


@interface PG_LoginVC : UIViewController <GFLocationManagerDelegate,QyuWebDelegate>
{
    
    
    CLLocationManager *locationManager;
    
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *emailField;
    
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *twitterButton;
    
    IBOutlet UIActivityIndicatorView *loginIndicator;
    
    IBOutlet UILabel *userFeedback ;
    
    IBOutlet UILabel *start ;
    IBOutlet UILabel *credits ;
    IBOutlet UILabel *about ;
    
    IBOutlet UIView *blurry;
    
    IBOutlet UIScrollView *scrollView;
    
    BOOL validated;
    BOOL isTwitter;
    BOOL isUpdating;
    BOOL hasUpdated;
    BOOL isAuthenticating;
    
    
    NSString* twitAccount;
    
    NSURLConnection * conn;
    NSMutableData * receivedData;
    
    IBOutlet UIImageView *logo;
    // QyuDB *usrDatabase;
    
    IBOutlet DGActivityIndicatorView *activityLoader ;

    CLLocation *currentLocation;
    
    
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) CLLocation *currentLocation;


@property (nonatomic, retain)  UITextField *passwordField;
@property (nonatomic, retain)  UITextField *emailField;
@property (readwrite, nonatomic, retain)  UILabel *userFeedback ;

@property (readwrite, nonatomic, retain)  UILabel *start ;
@property (readwrite, nonatomic, retain)  UILabel *credits ;
@property (readwrite, nonatomic, retain)  UILabel *about ;

@property (nonatomic, retain) UIButton *twitterButton;
@property (nonatomic, retain) UIButton *mailError;
@property (nonatomic, retain) UIButton *pwdError;

@property (nonatomic, assign)  BOOL validated;
@property (nonatomic, assign)  BOOL isTwitter;
@property (nonatomic, assign)  BOOL isUpdatingLocation;
@property (nonatomic, assign)  BOOL isUpdatingEventData;
@property (nonatomic, assign) BOOL hasUpdated;
@property (nonatomic, assign) BOOL isAuthenticating;

@property (nonatomic, retain) UIActivityIndicatorView *loginIndicator;

@property(nonatomic, retain) NSURLConnection * conn;
@property(nonatomic, retain) NSMutableData *receivedData;

@property(nonatomic, retain) NSString* twitAccount;

@property (nonatomic, retain) UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UIImageView *logo;

@property(nonatomic,retain) IBOutlet UIView *blurry;


@property(nonatomic, retain) NSMutableArray *colorArray;
@property(nonatomic, retain) NSMutableDictionary *userDetails;

@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UIButton *helpButton;

@property (retain, nonatomic) IBOutlet DGActivityIndicatorView *activityLoader ;

@property(nonatomic, retain) NSArray *eventList;
@property (weak, nonatomic) IBOutlet GADBannerView  *bannerView;

- (void)loginDidFinish:(PG_LoginVC *)login;
- (void)prepareUserData:(NSString *)mail withPassword:(NSString *)pwd isTwitter:(NSString *)twitterFlag;
- (void) playSound:(NSString*) path;

- (IBAction)moveToFirst:(id)sender;




@end
