//
//  PG_LoginVC.m
//  ParkerMeister
//
//  Created by Ganesha on 21/2/15.
//  Copyright (c) 2015 tenqyu. All rights reserved.
//

#import "PG_LoginVC.h"
#import "MMDrawerBarButtonItem.h"

@interface PG_LoginVC ()

@property(weak,nonatomic) IBOutlet SpringView *loader ;
@property(weak,nonatomic) IBOutlet SpringImageView *loading ;


@end

@implementation PG_LoginVC

@synthesize currentLocation;
@synthesize passwordField;
@synthesize emailField;
@synthesize userFeedback;
@synthesize loginIndicator;
@synthesize conn;
@synthesize receivedData;
@synthesize validated, isTwitter, isUpdatingLocation, isUpdatingEventData,hasUpdated,isAuthenticating;
@synthesize scrollView;
@synthesize twitterButton,helpButton,loginButton;
@synthesize twitAccount;
@synthesize mailError,pwdError;
@synthesize start;
@synthesize credits;
@synthesize about;
@synthesize locationManager;
@synthesize userDetails,colorArray;
@synthesize logo,activityLoader;
@synthesize blurry, bannerView;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
    NSLog(@"Did I receive a memory warning ? ");
}



- (void) prepareUserData: (NSString *)mail withPassword:(NSString *)pwd isTwitter:(NSString *)twitterFlag{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    self.isAuthenticating=YES;
    
    NSLog(@"Login Submitted");
    
    // TODO: spawn a login thread
    NSString *reason =@"auth";
    
    NSString *base = [@"id=" stringByAppendingString:reason];
    NSString *val =[@"FALSE" stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *lat1 = [[NSString alloc] initWithFormat:@"%f", self.currentLocation.coordinate.latitude];
    NSString *long1 = [[NSString alloc] initWithFormat:@"%f", self.currentLocation.coordinate.longitude];
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLocale *locale = [NSLocale currentLocale];
    NSLog(@" language %@ and Long %@", language, locale );
    
    NSString *lat =[lat1 stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *longv =[long1 stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSString *twitFlag = [twitterFlag stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    
    NSString *requestVar = [base stringByAppendingFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", @"&mail=", mail , @"&pwd=", pwd, @"&validated=",val,@"&lat=",lat,@"&long=", longv,@"&langPref=", language, @"&twitterFlag=", twitFlag, @"&gameId=", @"5"];
    
    NSLog(@"Login Request URL %@", requestVar);
    
    NSString *urlAddress = @"https://choose.tenqyu.com";
    
    NSData *requestData = [NSData dataWithBytes: [requestVar UTF8String] length: [requestVar length]];
    
    NSMutableURLRequest *requestObj=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlAddress]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    
   // NSLog(@"Login URL %@", requestObj);
    
    [requestObj setHTTPMethod: @"POST"];
    [requestObj setHTTPBody: requestData];
    
    // create the connection with the request
    // and start loading the data
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:requestObj
                                                                   delegate:self];
    
    
    if (theConnection)
        
    {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        
        receivedData = [NSMutableData data];
        
    } else {
        
        // Inform the user that the connection failed.
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"game", nil)]
                                                          message:[NSString stringWithFormat:NSLocalizedString(@"err-lost", nil)]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
    }
    
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        
    }
    return self;
}


#pragma mark - View lifecycle

- (void ) viewWillAppear:(BOOL)animated
{
    self.hasUpdated=NO;
   
    NSLog(@"[LoginVC] viewWillAppear");
    
    /*** One more check ***/
    
    bool showAlertSetting = [[GFLocationManager sharedInstance]checkSettings:self ];
    
    if(showAlertSetting){
        
        NSLog(@"Denied user rights?");
        [self moveToDenied:self];
        
        
    }
    
   /******** Let's see if we can reuse this information about location **********/
    
    self.currentLocation=[[GFLocationManager sharedInstance] currentLocation];
    
    /******** check existing user data **********/
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.userDetails = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"userData"] ] ;
   
    /******** reset badge counter (not used) **********/
    
    UIApplication *application =  [ UIApplication sharedApplication ];
    application.applicationIconBadgeNumber=0;
    
    
    /******** csome visual updates **********/
    
    self.start.text = [NSString stringWithFormat:NSLocalizedString(@"welcome", nil)];
    
   self.colorArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayOfColorsWithColorScheme:ColorSchemeAnalogous usingColor: [UIColor flatSkyBlueColor] withFlatScheme:true]];
    
    
    FAKFontAwesome *likeIcon = [FAKFontAwesome questionIconWithSize:25];
    [likeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor] ];
    UIImage *iconImage = [likeIcon imageWithSize:CGSizeMake(40, 40)];
    self.helpButton.contentMode=UIViewContentModeScaleAspectFit;
    [self.helpButton setBackgroundImage:iconImage forState:UIControlStateNormal];
    
    
    self.helpButton.backgroundColor=[UIColor flatWhiteColor];
    // this value makes a circle
    self.helpButton.layer.cornerRadius = self.helpButton.frame.size.height/2;
    self.helpButton.clipsToBounds = YES;
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.loginButton.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10.0, 10.0)];
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.loginButton.bounds;
    maskLayer.path = maskPath.CGPath;
    // Set the newly created shape layer as the mask for the image view's layer
    self.loginButton.layer.mask = maskLayer;
    self.loginButton.clipsToBounds = YES;
    
    
    [self.navigationController setHidesNavigationBarHairline:YES];
    
    
    /******** Update Location Data **********/
    
    [self startingLoadingAnimation];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    
    self.start.text = [NSString stringWithFormat:NSLocalizedString(@"getEvents", nil)];
    
    
    /******** Some more polishing **********/
    
    self.loginButton.layer.shadowColor = [UIColor flatSkyBlueColor].CGColor;
    self.loginButton.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.loginButton.layer.shadowOpacity = 0.5;
    self.loginButton.layer.shadowRadius = 0.5;
    
    
    self.blurry.layer.cornerRadius = self.blurry.frame.size.height/2; // this value vary as per your desire
    self.blurry.clipsToBounds = YES;
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"[LoginVC] ViewDidLoad");
    
    /**** Load the banner ad *****/
    
    self.bannerView.adUnitID = @"ca-app-pub-7857198660418019/3237842480";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.alpha=0.0;
    
    bool showAlertSetting = [[GFLocationManager sharedInstance]checkSettings:self ];
    
    if(showAlertSetting){
        
        NSLog(@"LoginVC Denied user rights!");
        [self moveToDenied:self];
        
        
    } else {
        
        NSLog(@"LoginVC Accepted user rights.");
        
        self.isUpdatingLocation=TRUE;
        [[GFLocationManager sharedInstance] addLocationManagerDelegate:self];
        //This triggers the dialogue!! - DON'T DELETE
        [locationManager startUpdatingLocation];
        
    }
    
    /******** Check background refresh **********/
    
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusAvailable) {
        
        NSLog(@"Background updates are available for the app.");
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied)
    {
        NSLog(@"The user explicitly disabled background behavior for this app or for the whole system.");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"game", nil)]
                                                        message:
                              [NSString stringWithFormat:NSLocalizedString(@"err-bg", nil)]
                              
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted)
    {
        NSLog(@"Background updates are unavailable and the user cannot enable them again. For example, this status can occur when parental controls are in effect for the current user.");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"game", nil)]
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"err-bg", nil)]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    /********* Getting user credentials *********/
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.userDetails = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"userData"] ] ;
    
    
    if([self.userDetails count]>0) {
        
        NSLog(@"[LoginVC] User details available");
        NSLog(@"[LoginVC] Update status %i ", self.hasUpdated );
        if (!showAlertSetting){
            self.validated=TRUE;
            [self moveToFirst:self];
        }
        
    } else {

        //if there is no userdetails then init
        if ([self.userDetails count] == 0 && !self.isAuthenticating){
            
            self.isTwitter=NO;
            NSString *tFlag = [NSString stringWithFormat:@"%d", self.isTwitter];
            
            
            char data[8];
            for (int x=0;x<8;data[x++] = (char)('A' + (arc4random_uniform(26))));
            
            NSString *pwd= [[NSString alloc] initWithBytes:data length:8 encoding:NSUTF8StringEncoding];
            
            [self prepareUserData:@"DropInUser" withPassword:pwd isTwitter:tFlag];
            
            NSLog(@" this is the pwd %@", pwd);
            
        } else {
            
            
            NSLog(@"User registered with ID %i" , [[self.userDetails objectForKey:@"id"] intValue]);
            
            self.validated=YES;
            
            
        }
        
        
    
    }

    
    NSLog(@" LoginVC Completed view did load");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loginDidFinish:(PG_LoginVC *)login{
    
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    NSLog(@"[LoginVC] Now dismissing viewcontroller");
    
    if(self.isUpdatingEventData || self.isAuthenticating) {
        
        NSLog(@"[LoginVC] Is doing something");
        self.isUpdatingLocation=TRUE;
        [[GFLocationManager sharedInstance] addLocationManagerDelegate:self];
        //This triggers the dialogue!! - DON'T DELETE
        [locationManager startUpdatingLocation];
        
    } else {
        
        self.isUpdatingLocation=TRUE;
        [[GFLocationManager sharedInstance] addLocationManagerDelegate:self];
        //This triggers the dialogue!! - DON'T DELETE
        [locationManager startUpdatingLocation];
        
    }
}

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField
{
    [theTextField resignFirstResponder];
    
    return YES;
}
#pragma mark --Connection function;

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"Login didReceiveResponse");
    [receivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"Login didReceiveData");
    [receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Login didFailWithError %@", error);
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError *e = nil;
    NSDictionary *jsonString = [NSJSONSerialization JSONObjectWithData: receivedData  options: NSJSONReadingMutableContainers error: &e];
   
    
    if (jsonString != NULL) {
        
      
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:@"userData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    } else {
        
        NSLog(@" Error receving information from Server");
    }
    NSString *auth1 = @"Initialized";
    
    
    auth1 =@"User authorized";
    self.validated=TRUE;
    self.isAuthenticating=NO;
    
    [self loginDidFinish:self];
    
    
    NSLog(@" This is the end");
    
}



- (void) downloadUrlContent:(NSURL *)url {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url
                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                  timeoutInterval:60.0];
    conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    if (conn) {
        receivedData = [NSMutableData data];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark sound
-(void) playSound:(NSString*) path{
    
    SystemSoundID soundID;
    NSString *const resourceDir = [[NSBundle mainBundle] resourcePath];
    NSString *const fullPath = [resourceDir stringByAppendingPathComponent:path];
    NSURL *const url = [NSURL fileURLWithPath:fullPath];
    
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(url), &soundID);
    AudioServicesPlaySystemSound (soundID);
    
}

- (void)performAnimation;
{
    /*
    self.loginButton.alpha=1;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDuration:2.0];
    self.loginButton.alpha=1;
    
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
    */
}



//This delegate is called after the completion of Animation.
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    /*
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.3];
    self.loginButton.alpha=1;
    [UIView commitAnimations];
    
    [self performSelector:@selector(performAnimation) withObject:nil afterDelay:2.3];
    */
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [[GFLocationManager sharedInstance] removeLocationManagerDelegate:self];
   
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
   NSLog(@"[LoginVC]  I am soooo great");
    
    
    
}


#pragma mark location delegate

- (void) locationManagerDidUpdateLocation:(CLLocation *)location {
    
   
    
    self.currentLocation = location;
    NSLog(@"[LoginVC]  Updated location needs it ? -> %i ", self.hasUpdated);
    NSLog(@"[LoginVC]  coordinates are %f and %f and accuracy %f", location.coordinate.latitude ,location.coordinate.longitude, location.horizontalAccuracy);


    if([self.userDetails count]==0) {
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        self.userDetails = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"userData"] ] ;
        
    }
    
    if([self.userDetails count]>0) {
        
        self.start.text=[NSString stringWithFormat:NSLocalizedString(@"load", nil)]; 
        [self.activityLoader startAnimating];

        [self.loginButton setEnabled:NO];
       // --[2016 disable this call as it breaks the app flow
    
        //No matter what remove the last list and get a new one.
        //you don't want to create error data
        //the negative experience is worse
        
        self.eventList=nil;
        
        self.isUpdatingEventData=TRUE;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"getEventList"];
        [webby setDelegate:self];
        [webby submitLocationScan:(double)location.coordinate.latitude andLong:(double)location.coordinate.longitude email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] ];
       
       
        
    } else {
        
        
        //Need to get user data
        
        if(!self.isAuthenticating){
       
            self.isTwitter=NO;
            NSString *tFlag = [NSString stringWithFormat:@"%d", self.isTwitter];
        
        
            char data[8];
            for (int x=0;x<8;data[x++] = (char)('A' + (arc4random_uniform(26))));
            
            NSString *pwd= [[NSString alloc] initWithBytes:data length:8 encoding:NSUTF8StringEncoding];
            
           [self prepareUserData:@"DropInUser" withPassword:pwd isTwitter:tFlag];
       
            NSLog(@"[LoginVC]  this is the pwd %@", pwd);
        }
        
    }
  
    if(!self.isUpdatingLocation && location!=nil){
        
        [[GFLocationManager sharedInstance] removeLocationManagerDelegate:self];
        self.isUpdatingLocation=FALSE;
        
    }
} // end function




- (void)fadeInImage
{
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:2.0];
    self.logo.alpha = 1.0;
    [UIView commitAnimations];
    
}

#pragma mark web delegate methods

- (void)notificationsReceived:(NSDictionary *)resultData{
    
    //You ned to set "count" new updates.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    
    
}


- (void)locationsReceived:(NSDictionary *)resultData
{
    
    NSLog(@"[LoginVC] Received locations : %lu ", (unsigned long)[resultData count]);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
   // [self stoppingLoadingAnimation];
    
    if ([resultData count] > 0){
        
        
        NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[resultData count]];
        
        
        self.eventList=nil;
        self.eventList = [NSMutableArray array];
        
        // NSLog(@"********************************");
        
        for (NSDictionary* campaignData in resultData) {
            
          //  NSLog(@"Outputting cData %@", campaignData);
            [data addObject:campaignData];
            
            
        }
        

        self.eventList = [[NSArray alloc] initWithArray:data];
       
        
        [[NSUserDefaults standardUserDefaults] setObject:self.eventList forKey:@"currentEvents"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    } else {
        
        //what happens if there were no events?
        
    }
    
     [self.loginButton setEnabled:YES];
    
   [self.activityLoader stopAnimating];
 
    //self.start.text=[NSString stringWithFormat:NSLocalizedString(@"press", nil)];
    
    self.hasUpdated=YES;
   
    [self moveToFirst:self];
}

- (void) noLocationsReceived{
    
    /* you need to remove the list */
    /* should you already tell the user? */
    
    NSLog(@"[LoginVC] ERR no locations");
    
    [self.activityLoader stopAnimating];
    
    self.eventList=nil;
    [[NSUserDefaults standardUserDefaults] setObject:self.eventList forKey:@"currentEvents"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.loginButton setEnabled:YES];
    
    self.hasUpdated=YES;
    
    [self moveToFirst:self];
    
}

#pragma mark animations
- (void) startingLoadingAnimation {
    
    self.activityLoader.tintColor=[UIColor flatSkyBlueColor];
    self.activityLoader.type=DGActivityIndicatorAnimationTypeTriplePulse;
    /*
    
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeTriplePulse tintColor:[UIColor flatSkyBlueColor] size: 50.0f];
    
  //  activityIndicatorView.frame = self.activityLoader.frame;
    activityIndicatorView.layer.speed=1.0;
    
    self.activityLoader=activityIndicatorView;
    
 //   [self.activityLoader addSubview: activityIndicatorView];

    [self.activityLoader startAnimating];
    */
   
    
   
    
}

- (IBAction) moveToFirst:(id)sender {
    
    NSLog(@"[LoginVC]  Entered move 2 First");
    
    //--the problem is this is not validated
    if(self.validated){
        
        
        NSLog(@"[LoginVC]  Validated user account iniating move 2 first");
        
        [self setupLeftMenuButton];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // code here
            
            PGViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NAV_TOP_VIEW_CONTROLLER"];
            
           /* PGFirstViewController *vc=(PGFirstViewController*)[centerViewController.viewControllers objectAtIndex:0];
            vc.hasUpdates=TRUE;
            [vc setupLeftMenuButton];*/
            
            [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
            
            [self presentViewController:centerViewController animated:TRUE completion:nil];
            
            
        });
        
    }

}

- (IBAction) moveToDenied:(id)sender {
    
    NSLog(@" [LoginVC] Entered move 2 Denied");
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
            // code here
            
            PGViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DENIED_TOP_VIEW_CONTROLLER"];
            
            [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
            
            [self presentViewController:centerViewController animated:TRUE completion:nil];
            
            
        });
        
    
}


#pragma mark - drawer

- (void)setupLeftMenuButton {
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

/*
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)settingsButtonPress:(id)sender{
    
    UINavigationController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"THIRD_TOP_VIEW_CONTROLLER"];
    
    //UIViewController *vc= [centerViewController.viewControllers objectAtIndex:0];
    
    [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
    
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"prefs:root=LOCATION_SERVICES"]];
    
}
@end
