//
//  PGFirstViewController.m
// SideDrawerExample
//
//  Created by Pulkit Goyal on 18/09/14.
//  Copyright (c) 2014 Pulkit Goyal. All rights reserved.
//

#import "PGFirstViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "TQ_EventDetailsViewController.h"

@interface PGFirstViewController ()

@end

@implementation PGFirstViewController

@synthesize eventTable,eventTableCellItem,eventList,refreshButton,currentLocation,loading,loader,messager, messagerLabel,loadedWithLocation,needsUpdates,weatherString,weatherNeedsUpdates,notiDictionary,likedIDs;

-(void) viewWillAppear:(BOOL)animated{
    
    [self setupLeftMenuButton];
    
    self.messager.alpha=0.0;
    self.loader.alpha=0.0;
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    
    if (([self.weatherString.text isEqualToString:@""])) {
       self.weatherNeedsUpdates=true;
    }
    if (!locationAllowed)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"prefs:root=LOCATION_SERVICES"]];
    }
    
    [[GFLocationManager sharedInstance] addLocationManagerDelegate:self];
    
    
    [self.eventTable setDataSource:self];
    self.eventTable.delegate = self;
    self.eventTable = eventTable;
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *eventDetails= [prefs objectForKey:@"currentEvents"];
    
  
    NSMutableDictionary *userDetails = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"userData"] ] ;
    
    NSLog(@"User registered with ID %i" , [[userDetails objectForKey:@"id"] intValue]);
    NSLog(@"User registered with email %@" , [userDetails objectForKey:@"email"]);
    
    /*
    
    QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"submitScan"];
    [webby setDelegate:self];
    [webby submitQRScan:@"https://choose.tenqyu.com?q=103a047313a84e37c195017a0eff503601eef833f52b5ea8a49411b85ff6e30c" email:[userDetails objectForKey:@"email"]  pwd:[userDetails objectForKey:@"pwd"] mongoId:[userDetails objectForKey:@"id"] withLat:self.currentLocation.coordinate.latitude andLong:self.currentLocation.coordinate.longitude];
    */
    
    
    
    if ([eventDetails count]>0){
        self.eventList=eventDetails;
    } else {
        
        self.needsUpdates=TRUE;
        self.eventTable.alpha=0.0;
        
        self.loader.alpha=1.0;
        [self startingLoadingAnimation];
        
       
    }
    
    
    bool isSimulator=false;
    self.needsUpdates=false;
    
    if(isSimulator && self.needsUpdates){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"getEventList"];
        [webby setDelegate:self];
        [webby submitLocationScan:(double)1.292771 andLong:(double)103.859343];
        // [webby submitLocationScan:(double)location.coordinate.latitude andLong:(double)location.coordinate.longitude];
        gettingUpdates=YES;
    }
}

- (void) viewDidLoad:(BOOL) animated {
    
    [super viewDidLoad];
    
    
}
- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)refreshButtonPress:(id)refreshButtonPress {
    
    self.messager.alpha=0.0;
    self.eventTable.alpha=0.0;
    self.loader.alpha=1.0;
    [self startingLoadingAnimation];
    //data not available anymore
    self.eventList=nil;
    self.needsUpdates=TRUE;
    
    NSLog(@" current location lat %f and lng %f", self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude
          );
    [[GFLocationManager sharedInstance] addLocationManagerDelegate:self];
    //[self startingLoadingAnimation];
    
    
}


#pragma mark UITableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    // Return the number of sections.
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"lotCell";
    
    lotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        // More initializations if needed.
        
        //   NSLog(@"Made new cell");
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"lotCell" owner:self options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[lotCell class]])
            {
                cell = (lotCell *)currentObject;
                break;
            }
        }
    }
    
    
    if ([self.eventList count]>0){
        
        
        NSDictionary *text=[self.eventList objectAtIndex:indexPath.row];
        
        
        cell.title.text=[text objectForKey:@"title"];
        
        
        NSString *dateString = [text objectForKey:@"start_time"];
        NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
        [startDateFormat setDateFormat:@"yyyy-MM-dd H:mm:ss"];
//        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        
        [startDateFormat setTimeZone:timeZone];
        [startDateFormat setFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDate *startDate1 = [startDateFormat dateFromString:dateString];
        
        int tInterval = (int)[startDate1 timeIntervalSinceNow]/60;
        
        if(tInterval<=0){
            
            cell.inXMinutes.text=@"started";
            
        } else {
            if (tInterval>60) {
                //convert to hours
                tInterval=tInterval/60;
                NSLog(@" My Interval %d", tInterval);
                if (tInterval == 1) {
                     cell.inXMinutes.text=[@"in " stringByAppendingString: [[NSString stringWithFormat:@"%d",tInterval] stringByAppendingString:@" hr"]];
                } else {
                    cell.inXMinutes.text=[@"in " stringByAppendingString: [[NSString stringWithFormat:@"%d",tInterval] stringByAppendingString:@" hrs"]];
                }
            } else {
                NSLog(@" My Interval %d", tInterval);
                
                cell.inXMinutes.text=[@"in " stringByAppendingString: [[NSString stringWithFormat:@"%d",tInterval] stringByAppendingString:@" min"]];
            }
        }
        
        int durationCheck= [[text objectForKey:@"duration"] intValue]*-1 ;
        //which one is more negative
        if (tInterval <= durationCheck ){
            cell.inXMinutes.text=@"expired";
        }
       
        NSString *maxTest;
        if ([[text valueForKey:@"max_count"] isEqualToString:@"0"]){
            maxTest=@"No";
        }else{
            maxTest=[[text valueForKey:@"max_count"] lowercaseString];
        }
        
        
        if([[text valueForKey:@"max_count"] intValue]>0) {
            
            NSString *goingMax = [NSString stringWithFormat:@"%@%@%@", [[text valueForKey:@"going_count"] lowercaseString] , @" / ", [[text valueForKey:@"max_count"] lowercaseString] ];
            
            cell.goingCount.text=goingMax;
            
        } else {
            
            if ([[text valueForKey:@"going_count"] intValue]>0) {
                
                cell.goingCount.text=[NSString stringWithFormat:@"%@%@", [[text valueForKey:@"going_count"] lowercaseString], @" going"];
            } else {
                cell.goingCount.text=@"unlimited";
            }
            
            
        }
        
        float dist = [[text objectForKey:@"distance"] floatValue];
        if (dist>=1) {
            
            cell.distance.text=[[NSString stringWithFormat:@"%.2f",dist] stringByAppendingString: @" km"] ;
        } else {
            dist=dist*1000;
            float new = [[NSString stringWithFormat:@"%.2f",dist]floatValue];
            cell.distance.text=[[NSString stringWithFormat:@"%d",(int)new] stringByAppendingString: @" mtrs"] ;
            
        }
        
        
        NSString *priceTest=[[text objectForKey:@"price"] lowercaseString];
        
       
        NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
        
        if ([priceTest rangeOfCharacterFromSet:notDigits].location==NSNotFound) {
            NSLog(@" String : %@", priceTest);
            
            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
            [currencyFormatter setLocale:[NSLocale currentLocale]];
            [currencyFormatter setMaximumFractionDigits:2];
            [currencyFormatter setMinimumFractionDigits:2];
            [currencyFormatter setAlwaysShowsDecimalSeparator:YES];
            [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            
            NSNumber *someAmount = [NSNumber numberWithFloat:[priceTest floatValue]];
            NSString *priceString = [currencyFormatter stringFromNumber:someAmount];
            
            
        if ([priceTest isEqualToString:@"0"]||[priceTest isEqualToString:@"0.00"]){
          
            /* if([[text valueForKey:@"source"] isEqualToString:@"eventful"]) {
             cell.price.text=@"Check";
             } else {
             */
            
            cell.price.text=@"Free";
            
            // }
        }else{
          cell.price.text=priceString;
        }
                    
        } else {
            
            //if not a number and there is nothing about prices, take the default string
            cell.price.text=priceTest;
            
        }
        
        
        /*
        
        if ([[text objectForKey:@"going_count"] intValue]<=25) {
            cell.lotViewIndicator.image = [UIImage imageNamed:@"pk_map_icon_marker_red.png"];
        } else if (25< [[text objectForKey:@"going_count"] intValue] && [[text objectForKey:@"lots"] intValue]<=50) {
            cell.lotViewIndicator.image =[UIImage imageNamed:@"pk_map_icon_marker_yellow.png"];
        } else {
            cell.lotViewIndicator.image=[UIImage imageNamed:@"pk_map_icon_marker.png"];
        }*/
        
        cell.lotViewIndicator.image=[UIImage imageNamed:@"pk_map_icon_marker.png"];
        
        /* round edges */
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.lotViewIndicator.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(3.0,3.0)];
        // Create the shape layer and set its path
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = cell.lotViewIndicator.bounds;
        maskLayer.path = maskPath.CGPath;
        // Set the newly created shape layer as the mask for the image view's layer
        cell.lotViewIndicator.layer.mask = maskLayer;
        cell.lotViewIndicator.clipsToBounds = NO;
        
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        fmt.numberStyle=NSNumberFormatterDecimalStyle;
        [fmt setMaximumFractionDigits:0];
        [fmt setMinimumFractionDigits:0];
        
        if(self.eventTable.alpha==0.0){
            
            self.eventTable.alpha=1.0;
        }
        
    }
    
    
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //   NSLog(@"Number of games %lu",(unsigned long)[self.gameList count]);
    
    if ( [self.eventList count]==0) {  return 1; } else { return  [self.eventList count];}
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Goto details view
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TQ_EventDetailsViewController *eventDetails = [storyboard instantiateViewControllerWithIdentifier:@"EVENT_DETAILS"];
    
   
    
    
    //PG_eventDetails *eventDetails = [[PG_eventDetails alloc] init] ;
    
    NSDictionary *text=[self.eventList objectAtIndex:indexPath.row];
    NSLog(@"%@",text);
    
    /* Try to get the strings done here*/
    eventDetails.latitude=[[text valueForKey:@"latitude"]floatValue] ;
    eventDetails.longitude=[[text valueForKey:@"longitude"] floatValue] ;
    eventDetails.vNameStr=[text objectForKey:@"venue_name"];
    eventDetails.eURL=[[text valueForKey:@"url"] lowercaseString];
    eventDetails.vStart_time=[text objectForKey:@"start_time"];
    eventDetails.vStop_time=[text objectForKey:@"stop_time"];
    eventDetails.idStr=[text objectForKey:@"id"];
    
    NSLog(@" Check this %@",[text objectForKey:@"id"]);
    /* Before loading the items*/

    [eventDetails setModalPresentationStyle:UIModalPresentationFullScreen];
    [eventDetails view];
    
    //eventDetails.distance.text=[[text valueForKey:@"distance"] lowercaseString];
    
    float dist = [[text objectForKey:@"distance"] floatValue];
    if (dist>=1) {
        
        eventDetails.distance.text=[[NSString stringWithFormat:@"%.2f",dist] stringByAppendingString: @" km"] ;
    } else {
        dist=dist*1000;
        float new = [[NSString stringWithFormat:@"%.2f",dist]floatValue];
        eventDetails.distance.text=[[NSString stringWithFormat:@"%d",(int)new] stringByAppendingString: @" mtrs"] ;
        
    }
    
    eventDetails.duration.text=[[text valueForKey:@"duration"] lowercaseString];
    
    
    NSString *priceTest=[[text objectForKey:@"price"] lowercaseString];
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    
    if ([priceTest rangeOfCharacterFromSet:notDigits].location==NSNotFound) {
        NSLog(@" String : %@", priceTest);
        
        NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setLocale:[NSLocale currentLocale]];
        [currencyFormatter setMaximumFractionDigits:2];
        [currencyFormatter setMinimumFractionDigits:2];
        [currencyFormatter setAlwaysShowsDecimalSeparator:YES];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        NSNumber *someAmount = [NSNumber numberWithFloat:[priceTest floatValue]];
        NSString *priceString = [currencyFormatter stringFromNumber:someAmount];
        
        if ([priceTest isEqualToString:@"0"]||[priceTest isEqualToString:@"0.00"]){
            
           /* if([[text valueForKey:@"source"] isEqualToString:@"eventful"]) {
                eventDetails.price.text=@"Check";
            } else {
            */
            
            eventDetails.price.text=@"Free";
           
            // }
            
        }else{
            
            eventDetails.price.text=priceString;
            
        }
    } else {
        
        eventDetails.price.text=priceTest;
        
    }
   

    if([[text valueForKey:@"max_count"] intValue]>0) {
    
        NSString *goingMax = [NSString stringWithFormat:@"%@%@%@", [[text valueForKey:@"going_count"] lowercaseString] , @" / ", [[text valueForKey:@"max_count"] lowercaseString] ];
        
            eventDetails.going_count.text=goingMax;
        
    } else {
        
        if ([[text valueForKey:@"going_count"] intValue]>0) {
            
            eventDetails.going_count.text=[NSString stringWithFormat:@"%@%@", [[text valueForKey:@"going_count"] lowercaseString], @" going"];
        } else {
            eventDetails.going_count.text=@"unlimited";
        }
        
        
    }
    
    
    eventDetails.max_count.text=[NSString stringWithFormat:@"%@%@%@", [[text valueForKey:@"latitude"] lowercaseString] , @" , ", [[text valueForKey:@"longitude"] lowercaseString] ];;
    
    
    /** Date formatting **/
    NSString *dateString = [[text valueForKey:@"start_time"] lowercaseString];
    NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
    [startDateFormat setDateFormat:@"yyyy-MM-dd H:mm:s"];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    [startDateFormat setTimeZone:timeZone];
    [startDateFormat setFormatterBehavior:NSDateFormatterBehaviorDefault];
    NSDate *startDate1 = [startDateFormat dateFromString:dateString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate1];
    
    NSString *startString =[NSString stringWithFormat:@"%02ld%@%02ld", (long)[components hour] , @":", (long)[components minute] ];
    
    
    
    dateString = [[text valueForKey:@"stop_time"] lowercaseString];
    startDate1 = [startDateFormat dateFromString:dateString];
    components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate1];
    NSString *endString =[NSString stringWithFormat:@"%02ld%@%02ld", (long)[components hour] , @":", (long)[components minute] ];
    
    eventDetails.start_time.text = [NSString stringWithFormat:@"%@%@%@", startString , @" - ", endString ];
    
    //in this case I do have an owner
    if([[text valueForKey:@"source"] isEqualToString:@"meetup.com"] && !([[text valueForKey:@"organizer"] isEqualToString:@""])) {
        
    eventDetails.eTitle.text= [NSString stringWithFormat:@"%@%@%@", [text valueForKey:@"title"] , @" - ", [text valueForKey:@"organizer"] ];
        ;
 
    } else {
 
        eventDetails.eTitle.text=[text valueForKey:@"title"];
        
    }
    NSAttributedString *tmpStr = [[NSAttributedString alloc] initWithData:[[text valueForKey:@"description"] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    
    eventDetails.eDescription.text=[tmpStr string]  ;
    
    eventDetails.eSource.text=[[text valueForKey:@"source"] lowercaseString];
    eventDetails.vAddress.text=[text objectForKey:@"venue_address"];
    eventDetails.vName.text=[text objectForKey:@"venue_name"];
    
    if ([[text objectForKey:@"venue_address"] isEqualToString:[text objectForKey:@"venue_name"]]) {
        
         eventDetails.vName.text=[text objectForKey:@"venue_name"];
    
    } else {
       
        
        eventDetails.vName.text=[NSString stringWithFormat:@"%@%@%@", [text valueForKey:@"venue_name"] , @" - ", [text valueForKey:@"venue_address"] ];
        
    }
    
    eventDetails.fScore.text=[text objectForKey:@"fScore"];
 
    if([[text objectForKey:@"recur_string"] isEqualToString:@""]) {
        //do something clever here:
        eventDetails.vRecur.text=@" ";
    } else {
        eventDetails.vRecur.text=[text objectForKey:@"recur_string"];
    }
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    fmt.numberStyle=NSNumberFormatterDecimalStyle;
    [fmt setMaximumFractionDigits:0];
    [fmt setMinimumFractionDigits:0];
    
    dateString = [text objectForKey:@"start_time"];
    startDateFormat = [[NSDateFormatter alloc] init];
    [startDateFormat setDateFormat:@"yyyy-MM-dd H:mm:ss"];
    //        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    timeZone = [NSTimeZone systemTimeZone];
    
    [startDateFormat setTimeZone:timeZone];
    [startDateFormat setFormatterBehavior:NSDateFormatterBehaviorDefault];
    startDate1 = [startDateFormat dateFromString:dateString];
    
    float fInterval= [startDate1 timeIntervalSinceNow]/60;
    
    if (fInterval>60) {
        //convert to hours
        fInterval=fInterval/60;
        NSLog(@" My Interval %.2f", fInterval);
        
        if (fInterval == 1.00) {
            eventDetails.timeDiff.text=[NSString stringWithFormat:@"%.2f",fInterval];
            eventDetails.inXminutes.text=@"hr";
        } else {
            eventDetails.timeDiff.text=[NSString stringWithFormat:@"%.2f",fInterval];
            eventDetails.inXminutes.text=@"hrs";
        }
    } else {
        NSLog(@" My Interval %.2f", fInterval);
        
        eventDetails.timeDiff.text=[NSString stringWithFormat:@"%d",(int)fInterval];
        eventDetails.inXminutes.text=@"min";
    }
    
    [self.navigationController pushViewController:eventDetails animated:YES];
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DRAWER_SEGUE"]) {
        MMDrawerController *destinationViewController = (MMDrawerController *) segue.destinationViewController;
        
        // Instantitate and set the center view controller.
        UIViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FIRST_TOP_VIEW_CONTROLLER"];
        [destinationViewController setCenterViewController:centerViewController];
        
        // Instantiate and set the left drawer controller.
        UIViewController *leftDrawerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SIDE_DRAWER_CONTROLLER"];
        [destinationViewController setLeftDrawerViewController:leftDrawerViewController];
        
    }
}

- (void)notificationsReceived:(NSDictionary *)resultData{
    
    //You ned to set "count" new updates.
    
    self.notiDictionary=[resultData mutableCopy];
    
    //for (NSDictionary* notification in resultData) {
    //}
    
}


- (void)locationsReceived:(NSDictionary *)resultData
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.loader.alpha=0.0;
    self.messager.alpha=0.0;
    
    [self stoppingLoadingAnimation];
    
    if ([resultData count] ==0){
        
        /*
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Tenqyu.com"
                                                          message:@"No event data available in your vincinity!"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];*/
        
        self.messagerLabel.text=@" There are no events around, you could try to adjust your settings!";
        self.messager.alpha=1.0;
        
        
    } else {
    
        self.needsUpdates=FALSE;
        
        NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[resultData count]];
        
        
        self.eventList=nil;
        self.eventList = [NSMutableArray array];
        
        NSLog(@"********************************");
        
        for (NSDictionary* campaignData in resultData) {
            
            NSLog(@"Outputting cData %@", campaignData);
            [data addObject:campaignData];
            
            
        }
        
        if([self.loading isAnimating]) {
            
            //  [self stoppingLoadingAnimation];
            
        }
        
        self.eventTable.alpha=1.0;
        self.loader.alpha=0.0;
        self.eventList = [[NSArray alloc] initWithArray:data];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.eventList forKey:@"currentEvents"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.eventTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
        [[self.view viewWithTag:12] removeFromSuperview];
    
    }
    
}


#pragma mark location delegate

- (void) locationManagerDidUpdateLocation:(CLLocation *)location {
    
    //store the current location in object
    self.currentLocation = location;
    
    if(weatherNeedsUpdates){

        __block NSDictionary *tempTmp = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       
                tempTmp=[self getWeatherForLocation:self.currentLocation] ;
            
            if(tempTmp) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.weatherString.text = [NSString stringWithFormat:@"%@%@%@%@",
                                               @"It is " , [tempTmp valueForKey:@"temp_c" ] , @"°C and ", [tempTmp valueForKey:@"weather" ]];
                    self.weatherNeedsUpdates=FALSE;
                });
            }
        });
        
       
    }
    
    if(self.needsUpdates){
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"getEventList"];
    [webby setDelegate:self];
    [webby submitLocationScan:(double)location.coordinate.latitude andLong:(double)location.coordinate.longitude];
    gettingUpdates=YES;
        
    }
    
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

-(IBAction) sortByDate :(id)sender {
    
    
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"start_time" ascending:YES];
    self.eventList  = [self.eventList  sortedArrayUsingDescriptors:@[dateSortDescriptor]];
    
    [self.eventTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    
}

-(IBAction) sortByDistance :(id)sender {
    
    
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
    self.eventList  = [self.eventList  sortedArrayUsingDescriptors:@[dateSortDescriptor]];
    
    [self.eventTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    
}

- (void) startingLoadingAnimation {
   
    NSArray * imageArray  = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"Randi_00000.png"],
                             [UIImage imageNamed:@"Randi_00001.png"],
                             [UIImage imageNamed:@"Randi_00002.png"],
                             [UIImage imageNamed:@"Randi_00003.png"],
                             [UIImage imageNamed:@"Randi_00004.png"],
                             [UIImage imageNamed:@"Randi_00005.png"],
                             [UIImage imageNamed:@"Randi_00006.png"],
                             [UIImage imageNamed:@"Randi_00007.png"],
                             [UIImage imageNamed:@"Randi_00008.png"],
                             [UIImage imageNamed:@"Randi_00009.png"],
                             [UIImage imageNamed:@"Randi_00010.png"],
                             [UIImage imageNamed:@"Randi_00011.png"],
                             [UIImage imageNamed:@"Randi_00012.png"],
                             [UIImage imageNamed:@"Randi_00013.png"],
                             [UIImage imageNamed:@"Randi_00014.png"],
                             [UIImage imageNamed:@"Randi_00015.png"],
                             [UIImage imageNamed:@"Randi_00016.png"],
                             [UIImage imageNamed:@"Randi_00017.png"],
                             [UIImage imageNamed:@"Randi_00018.png"],
                             [UIImage imageNamed:@"Randi_00019.png"],
                             [UIImage imageNamed:@"Randi_00020.png"],
                             [UIImage imageNamed:@"Randi_00021.png"],
                             [UIImage imageNamed:@"Randi_00022.png"],
                             [UIImage imageNamed:@"Randi_00023.png"],
                             [UIImage imageNamed:@"Randi_00024.png"],
                             [UIImage imageNamed:@"Randi_00025.png"],
                             [UIImage imageNamed:@"Randi_00026.png"],
                             [UIImage imageNamed:@"Randi_00027.png"],
                             [UIImage imageNamed:@"Randi_00028.png"],
                             [UIImage imageNamed:@"Randi_00029.png"],
                             [UIImage imageNamed:@"Randi_00030.png"],
                             [UIImage imageNamed:@"Randi_00031.png"],
                             [UIImage imageNamed:@"Randi_00032.png"],
                             [UIImage imageNamed:@"Randi_00033.png"],
                             [UIImage imageNamed:@"Randi_00034.png"],
                             [UIImage imageNamed:@"Randi_00035.png"],
                             [UIImage imageNamed:@"Randi_00036.png"],
                             [UIImage imageNamed:@"Randi_00037.png"],
                             [UIImage imageNamed:@"Randi_00038.png"],
                             [UIImage imageNamed:@"Randi_00039.png"],
                             [UIImage imageNamed:@"Randi_00040.png"],
                             [UIImage imageNamed:@"Randi_00041.png"],
                             [UIImage imageNamed:@"Randi_00042.png"],
                             [UIImage imageNamed:@"Randi_00043.png"],
                             [UIImage imageNamed:@"Randi_00044.png"],
                             [UIImage imageNamed:@"Randi_00045.png"],
                             [UIImage imageNamed:@"Randi_00046.png"],
                             [UIImage imageNamed:@"Randi_00047.png"],
                             [UIImage imageNamed:@"Randi_00048.png"],
                             [UIImage imageNamed:@"Randi_00049.png"],
                             
                             
                             nil];
    CGRect rect=CGRectMake(self.loading.frame.origin.x, self.loading.frame.origin.y, 100 , 100);
    NSLog(@" Rect .x %f , .y %f",rect.origin.x, rect.origin.y);
    self.loading = [[UIImageView alloc] initWithFrame:rect];
  
    self.loading.animationImages = imageArray;
    self.loading.animationDuration = 1.5;
    self.loading.contentMode = UIViewContentModeCenter;
    [self.loader addSubview:self.loading];
    [self.loading startAnimating];
}


- (NSDictionary*)getWeatherForLocation:(CLLocation*)wLocation
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *stringURL=[NSString stringWithFormat:@"https://api.wunderground.com/api/f7f2f04f1312022b/geolookup/conditions/q/%f,%f.json",wLocation.coordinate.latitude,wLocation.coordinate.longitude];
    
    //NSLog(@"%@",stringURL);
    
    [request setURL:[NSURL URLWithString:stringURL]];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //NSDictionary *dictionary=[stringData objectFromJSONString];
    
    NSError *e = nil;
    NSDictionary *dictionary  = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &e];
    
    
    NSDictionary *locationDic=[[NSDictionary alloc] initWithDictionary:[dictionary valueForKey:@"current_observation"]];
    //NSLog(@"locations is %@",locationDic);
    
    return locationDic;
    //[dictionary valueForKey:@"current_observation"];
}


- (void) stoppingLoadingAnimation{
    
    [self.loading stopAnimating];
    
}




@end
