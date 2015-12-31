//
//  TQ_selfViewController.m
//  SideDrawerExample
//
//  Created by tenqyu on 30/9/15.
//  Copyright © 2015 Pulkit Goyal. All rights reserved.
//

#import "TQ_EventDetailsViewController.h"

@interface TQ_EventDetailsViewController ()

@end

@implementation TQ_EventDetailsViewController

@synthesize distance,duration,going_count,max_count,latitude,longitude,price,start_time,stop_time,eTitle,eDescription,eURL,eSource,vAddress,vName,vRecur,vStop_time,vStart_time,vNameStr, timeDiff,fScore,openLocation, debugView,mapView,shareView, myMapView,scannedURL, openURL,favButton,spamButton,idStr,inXminutes,likedIDs,userDetails,vSource,summaryView,handOver;

- (void)viewWillAppear:(BOOL)animated{
    
       self.debugView.alpha=0;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    self.userDetails = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"userData"] ] ;
    
    
    self.latitude=[[self.handOver valueForKey:@"latitude"]floatValue] ;
    self.longitude=[[self.handOver valueForKey:@"longitude"] floatValue] ;
    self.vNameStr=[self.handOver objectForKey:@"venue_name"];
    self.eURL=[[self.handOver valueForKey:@"url"] lowercaseString];
    self.vStart_time=[self.handOver objectForKey:@"start_time"];
    self.vStop_time=[self.handOver objectForKey:@"stop_time"];
    self.idStr=[self.handOver objectForKey:@"id"];
    
    //NSLog(@" Check this %@",[self.handOver objectForKey:@"id"]);
    /* Before loading the items*/
    
    [self setModalPresentationStyle:UIModalPresentationFullScreen];
    [self view];
    
    //self.distance.self.handOver=[[self.handOver valueForKey:@"distance"] lowercaseString];
    
    float dist = [[self.handOver objectForKey:@"distance"] floatValue];
    if (dist>=1) {
        
        self.distance.text=[[NSString stringWithFormat:@"%.1f",dist] stringByAppendingString: @" km"] ;
    } else {
        dist=dist*1000;
        float new = [[NSString stringWithFormat:@"%.2f",dist]floatValue];
        self.distance.text=[[NSString stringWithFormat:@"%d",(int)new] stringByAppendingString: @" mtrs"] ;
        
    }
    
    self.duration.text=[[self.handOver valueForKey:@"duration"] lowercaseString];
    
    
    NSString *priceTest=[[self.handOver objectForKey:@"price"] lowercaseString];
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    
    if ([priceTest rangeOfCharacterFromSet:notDigits].location==NSNotFound) {
        
        NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setLocale:[NSLocale currentLocale]];
        [currencyFormatter setMaximumFractionDigits:2];
        [currencyFormatter setMinimumFractionDigits:2];
        [currencyFormatter setAlwaysShowsDecimalSeparator:YES];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        NSNumber *someAmount = [NSNumber numberWithFloat:[priceTest floatValue]];
        NSString *priceString = [currencyFormatter stringFromNumber:someAmount];
        
        if ([priceTest isEqualToString:@"0"]||[priceTest isEqualToString:@"0.00"]){
            
            /* if([[self.handOver valueForKey:@"source"] isEqualToString:@"eventful"]) {
             self.price.self.handOver=@"Check";
             } else {
             */
            
            self.price.text=@"Free";
            
            // }
            
        }else{
            
            self.price.text=priceString;
            
        }
    } else {
        
        self.price.text=priceTest;
        
    }
    
    
    if([[self.handOver valueForKey:@"max_count"] intValue]>0) {
        
        NSString *goingMax = [NSString stringWithFormat:@"%@%@%@", [[self.handOver valueForKey:@"going_count"] lowercaseString] , @" / ", [[self.handOver valueForKey:@"max_count"] lowercaseString] ];
        
        self.going_count.text=goingMax;
        
    } else {
        
        if ([[self.handOver valueForKey:@"going_count"] intValue]>0) {
            
            self.going_count.text=[NSString stringWithFormat:@"%@", [self.handOver valueForKey:@"going_count"]];
        } else {
            self.going_count.text=@"unlimited";
        }
        
        
    }
    
    
    self.max_count.text=[NSString stringWithFormat:@"%@%@%@", [[self.handOver valueForKey:@"latitude"] lowercaseString] , @" , ", [[self.handOver valueForKey:@"longitude"] lowercaseString] ];;
    
    
    /** Date formatting **/
    NSString *dateString = [[self.handOver valueForKey:@"start_time"] lowercaseString];
    NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
    [startDateFormat setDateFormat:@"yyyy-MM-dd H:mm:s"];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    [startDateFormat setTimeZone:timeZone];
    [startDateFormat setFormatterBehavior:NSDateFormatterBehaviorDefault];
    NSDate *startDate1 = [startDateFormat dateFromString:dateString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate1];
    
    NSString *startString =[NSString stringWithFormat:@"%02ld%@%02ld", (long)[components hour] , @":", (long)[components minute] ];
    
    
    
    dateString = [[self.handOver valueForKey:@"stop_time"] lowercaseString];
    startDate1 = [startDateFormat dateFromString:dateString];
    components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate1];
    NSString *endString =[NSString stringWithFormat:@"%02ld%@%02ld", (long)[components hour] , @":", (long)[components minute] ];
    
    self.start_time.text = [NSString stringWithFormat:@"%@%@%@", startString , @" - ", endString ];
    
    //in this case I do have an owner
    if([[self.handOver valueForKey:@"source"] isEqualToString:@"meetup.com"] && !([[self.handOver valueForKey:@"organizer"] isEqualToString:@""])) {
        
        self.eTitle.text= [NSString stringWithFormat:@"%@%@%@", [self.handOver valueForKey:@"title"] , @" - ", [self.handOver valueForKey:@"organizer"] ];
        ;
        
        
    } else {
        
        self.eTitle.text=[self.handOver valueForKey:@"title"];
        
    }
    
    if([[self.handOver valueForKey:@"source"] isEqualToString:@"meetup.com"] ){
        self.vSource.image = [UIImage imageNamed:@"meetup.png"];
    }
    
    if([[self.handOver valueForKey:@"source"] isEqualToString:@"eventfinda"] ){
        self.vSource.image = [UIImage imageNamed:@"eventfinda.png"];
    }
    
    if([[self.handOver valueForKey:@"source"] isEqualToString:@"eventful"] ){
        self.vSource.image = [UIImage imageNamed:@"eventful.png"];
    }
    
    NSAttributedString *tmpStr = [[NSAttributedString alloc] initWithData:[[self.handOver valueForKey:@"description"] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    
    [self.eDescription  setScrollEnabled:NO];
    self.eDescription.text=[tmpStr string]  ;
    [self.eDescription setContentOffset:CGPointZero animated:YES];
    [self.eDescription setScrollEnabled:YES];
    
    self.eSource.text=[[self.handOver valueForKey:@"source"] lowercaseString];
    self.vAddress.text=[self.handOver objectForKey:@"venue_address"];
    self.vName.text=[self.handOver objectForKey:@"venue_name"];
    
    if ([[self.handOver objectForKey:@"venue_address"] isEqualToString:[self.handOver objectForKey:@"venue_name"]]) {
        
        self.vName.text=[self.handOver objectForKey:@"venue_name"];
        
    } else {
        
        
        self.vName.text=[NSString stringWithFormat:@"%@%@%@", [self.handOver valueForKey:@"venue_name"] , @" - ", [self.handOver valueForKey:@"venue_address"] ];
        
    }
    
    self.fScore.text=[self.handOver objectForKey:@"fScore"];
    
    if([[self.handOver objectForKey:@"recur_string"] isEqualToString:@""]) {
        //do something clever here:
        self.vRecur.text=@" ";
    } else {
        self.vRecur.text=[self.handOver objectForKey:@"recur_string"];
    }
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    fmt.numberStyle=NSNumberFormatterDecimalStyle;
    [fmt setMaximumFractionDigits:0];
    [fmt setMinimumFractionDigits:0];
    
    dateString = [self.handOver objectForKey:@"start_time"];
    startDateFormat = [[NSDateFormatter alloc] init];
    [startDateFormat setDateFormat:@"yyyy-MM-dd H:mm:ss"];
    //        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    timeZone = [NSTimeZone systemTimeZone];
    
    [startDateFormat setTimeZone:timeZone];
    [startDateFormat setFormatterBehavior:NSDateFormatterBehaviorDefault];
    startDate1 = [startDateFormat dateFromString:dateString];
    
    /*
     float fInterval= [startDate1 timeIntervalSinceNow];
     
     if (fInterval>60) {
     //convert to hours
     fInterval=fInterval/60;
     
     if (fInterval == 1.00) {
     self.timeDiff.self.handOver=[NSString stringWithFormat:@"%.2f",fInterval];
     self.inXminutes.self.handOver=@"hr";
     } else {
     self.timeDiff.self.handOver=[NSString stringWithFormat:@"%.2f",fInterval];
     self.inXminutes.self.handOver=@"hrs";
     }
     } else {
     //    NSLog(@" My Interval %.2f", fInterval);
     
     self.timeDiff.self.handOver=[NSString stringWithFormat:@"%d",(int)fInterval];
     self.inXminutes.self.handOver=@"min";
     }
     */
    
    float fInterval= [startDate1 timeIntervalSinceNow]/60;
    
    int hours= fabsf(fInterval)/60;
    int minutes = fabsf(fInterval) - (hours*60);
    
    
    self.timeDiff.text= [NSString stringWithFormat:@"%d:%02d", hours,minutes];
    
    /*********further setup ****************/
    self.likedIDs= [[prefs objectForKey:@"likedItems"] mutableCopy];
    
    if (!self.likedIDs) {
        //if it does not exists then create array
        self.likedIDs=[[NSMutableDictionary alloc]init];
    } else {
        if ([self.likedIDs count]>0) {
            
            if ([self.likedIDs objectForKey:self.idStr]) {
                [self.favButton setSelected:YES];
            }
        }
        
    }
    
    NSLog(@"********** %@ **************",self.eURL);
    
    if ([self.vNameStr isEqualToString:@""]) {
        self.vName.text=@"Unnamed Venue";
        [self geoLookUp];
    }
    
    NSString *string =[NSString stringWithFormat:@"%@",self.eDescription.text] ;
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [linkDetector matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in matches) {
        if ([match resultType] == NSTextCheckingTypeLink) {
            NSURL *url = [match URL];
            NSString* domain = [url host];
            self.scannedURL.text=[url absoluteString];
            //NSLog(@"found URL: %@", url);
            
            //This is for the aggregators
            if ([self.eSource.text isEqualToString:@"eventful"] || [self.eSource.text isEqualToString:@"eventfinda"] ) {
                
                //so the user can directly get the ticket
                if ([domain isEqualToString:@"peatix.com"] ||[domain isEqualToString:@"eventbrite.com"]) {
                    self.eURL=[url absoluteString];
                }
                
                NSLog(@"found URL: %@", url);
                
                
            }
            
        }
    }
    
    // [self loadActionBar];
    
    self.mapView.alpha=0;

    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.eDescription.superview.bounds;
    gradient.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor];
    gradient.locations = @[@0.0, @0.03, @0.97, @1.0];
    
    self.eDescription.superview.layer.mask = gradient;
    
  
    
    self.summaryView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.summaryView.layer.shadowOffset = CGSizeMake(0, 1);
    self.summaryView.layer.shadowOpacity = 0.5;
    self.summaryView.layer.shadowRadius = 0.5;
    
    /*
    self.shareView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.shareView.layer.shadowOffset = CGSizeMake(0, 2);
    self.shareView.layer.shadowOpacity = 0.5;
    self.shareView.layer.shadowRadius = 1.0;*/
    
    if(!self.userDetails){
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        self.userDetails = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"userData"] ] ;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"saveImpression"];
    [webby setDelegate:self];
    
    [webby saveImpression:@"seen" onAsset:self.idStr email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] withLat:(double)self.latitude andLong:(double)self.longitude];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
   
}

- (void)viewDidLayoutSubviews {
    [self.eDescription setContentOffset:CGPointZero animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) geoLookUp {
    
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *location= [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude] ;
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    [geoCoder reverseGeocodeLocation: location completionHandler: ^(NSArray *placemarks, NSError *error) {
        //do something
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        // NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
        
   
        
        self.vAddress.text=[placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressStreetKey];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    
    
}

- (IBAction)sendFavorite:(id)sender{
    
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.eURL]];
   
    //UIImage *bImage = [UIImage imageNamed:@"Liked.png"];
    //UIButton *fButton = (UIButton*)sender;
    
    //[fButton setImage:bImage forState:UIControlStateSelected|UIControlStateNormal];
  //  [self.view addSubview:fButton];
    
    UIButton *tempButton = (UIButton *)sender;
    if(tempButton.isSelected){
        [tempButton setSelected:NO];
        
        if ([self.likedIDs objectForKey: self.idStr]) // YES
        {
            // Do something
           
            [self.likedIDs removeObjectForKey:self.idStr];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"saveImpression"];
            [webby setDelegate:self];
            
            [webby saveImpression:@"unliked" onAsset:self.idStr email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] withLat:(double)self.latitude andLong:(double)self.longitude];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        }
        
    } else {
        [tempButton setSelected:YES];
    
        if(self.idStr && self.likedIDs) //or if(str != nil) or if(str.length>0)
        {
        
            if([self.likedIDs count]>0){
                [self.likedIDs setObject:[NSDate date] forKey:self.idStr];
            } else {
                
                self.likedIDs = [[[NSDictionary alloc] initWithObjectsAndKeys:[NSDate date ],self.idStr,nil] mutableCopy];
            }
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"saveImpression"];
            [webby setDelegate:self];
          
            [webby saveImpression:@"liked" onAsset:self.idStr email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] withLat:(double)self.latitude andLong:(double)self.longitude];
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        }
        NSLog(@"%@", self.idStr);
        
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.likedIDs forKey:@"likedItems"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)openURL:(id)sender{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.eURL]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"saveImpression"];
    [webby setDelegate:self];
    
    [webby saveImpression:@"openedURL" onAsset:self.eURL email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] withLat:(double)self.latitude andLong:(double)self.longitude];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

- (IBAction)openLocationView:(id)sender{
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.eURL]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"saveImpression"];
    [webby setDelegate:self];
    
    [webby saveImpression:@"checkedMap" onAsset:self.idStr email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] withLat:(double)self.latitude andLong:(double)self.longitude];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  
    
    if (self.mapView.alpha==1) {
        self.mapView.alpha=0;
    } else {
        
        [self.myMapView setDelegate:self];
        [self.myMapView setMapType:MKMapTypeStandard];
        [self.myMapView setZoomEnabled:YES];
        [self.myMapView setScrollEnabled:YES];
        self.myMapView.showsUserLocation=TRUE;
        [self.myMapView .layer setMasksToBounds:YES];
        self.myMapView.layer.shadowOpacity = 0.5f;
   
        
      //  [self.myMapView setRegion:region animated:NO];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)self.latitude  longitude:(CLLocationDegrees)self.longitude ];
        
        MapPin *marker = [[MapPin alloc] initWithCoordinates:location.coordinate placeName:@"" description:@""];
        marker.coordinate=location.coordinate;
        marker.status=@"event here";
        
        [self.myMapView addAnnotation:marker];
       
        MKMapPoint annotationPoint = MKMapPointForCoordinate(location.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.15f, 0.15f);
        [myMapView setVisibleMapRect:pointRect animated:YES];
        self.mapView.alpha=1;
        
        MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
        region.center.latitude = location.coordinate.latitude;
        region.center.longitude = location.coordinate.longitude;
        
        region.span.longitudeDelta = 0.005f;
        region.span.latitudeDelta = 0.005f;
        
        [self.myMapView setRegion:region animated:NO];
        
        
    }
    
}

- (IBAction) sendSMS {
    
  
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"saveImpression"];
    [webby setDelegate:self];
    
    [webby saveImpression:@"startedSMS" onAsset:self.idStr email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] withLat:(double)self.latitude andLong:(double)self.longitude];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
        [self showSMS:self.eURL];
  
    
}

- (IBAction) reportSpam:(id)sender {
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"saveImpression"];
    [webby setDelegate:self];
    
    [webby saveImpression:@"reportSpam" onAsset:self.idStr email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] withLat:(double)self.latitude andLong:(double)self.longitude];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"game", nil)]
                                                    message:[NSString stringWithFormat:NSLocalizedString(@"err-spam", nil)]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
}



- (IBAction)toggleDebugView:(id)sender{
    
    if (self.debugView.alpha==1) {
        self.debugView.alpha=0;
    } else {
        self.debugView.alpha=1;
    }
    
}

#pragma mark - MapView

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //Here
    [self.myMapView selectAnnotation:[[self.myMapView annotations] lastObject] animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)lmapView viewForAnnotation:(id < MKAnnotation >)annotation{
    
    if ([[annotation title] isEqualToString:@"Current Location"]) {
        return nil;
    }
    
    MapOverlay *qItem = (MapOverlay *)[lmapView dequeueReusableAnnotationViewWithIdentifier: @"qView"];
    
    if (qItem == nil)
    {
        qItem = (MapOverlay*)[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"qView"];
        qItem.canShowCallout = YES;
        
        UIImage *pinImage = [UIImage imageNamed:@"drop-logo 33x20.png"];
        [qItem setImage:pinImage];
        
        //rightButton.imageView.image=pinImage;
    }
    qItem.annotation = annotation;
    
    NSLog(@" Status %@",qItem.annotation );
    
    return qItem;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control

{ if ([view.annotation isKindOfClass:[MapPin class]])
{
    MapPin *myAnn = (MapPin *)view.annotation;
    NSLog(@"callout button tapped for station id %@", myAnn.title);
}
else
{
    NSLog(@"callout button tapped for annotation %@", view.annotation);
}
}

/*
- (void) loadActionBar {
    
    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
        self.actionBar = [SZActionBarUtils showActionBarWithViewController:self entity:self.entity options:nil];
        
        SZShareOptions *shareOptions = [SZShareUtils userShareOptions];
        shareOptions.dontShareLocation = YES;
        
        shareOptions.willAttemptPostingToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
            if (network == SZSocialNetworkTwitter) {
                NSString *entityURL = [[postData.propagationInfo objectForKey:@"twitter"] objectForKey:@"entity_url"];
                NSString *displayName = [postData.entity displayName];
                NSString *customStatus = [NSString stringWithFormat:@"Custom status for %@ with url %@", displayName, entityURL];
                
                [postData.params setObject:customStatus forKey:@"status"];
                
            } else if (network == SZSocialNetworkFacebook) {
                NSString *entityURL = [[postData.propagationInfo objectForKey:@"facebook"] objectForKey:@"entity_url"];
                NSString *displayName = [postData.entity displayName];
                NSString *customMessage = [NSString stringWithFormat:@"Custom status for %@ ", displayName];
                
                [postData.params setObject:customMessage forKey:@"message"];
                [postData.params setObject:entityURL forKey:@"link"];
                [postData.params setObject:@"A caption" forKey:@"caption"];
                [postData.params setObject:@"Custom Name" forKey:@"name"];
                [postData.params setObject:@"A Site" forKey:@"description"];
            }
        };
        
        self.actionBar.shareOptions = shareOptions;
    }
    
}
 
*/ 

 
#pragma mark - Message composer
- (void)showSMS:(NSString*)file {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[@""];
    NSString *message = [NSString stringWithFormat:@"Yo! Check you this event %@ where I will drop in now!", file];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"saveImpression"];
    [webby setDelegate:self];
    
    [webby saveImpression:@"finishedSMS" onAsset:self.idStr email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] withLat:(double)self.latitude andLong:(double)self.longitude];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)notificationsReceived:(NSDictionary *)resultData{
    
    NSLog(@"%@",resultData);
    
}


- (void)locationsReceived:(NSDictionary *)resultData
{
    
   NSLog(@"%@",resultData);
    
}


@end
