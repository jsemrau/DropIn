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

@synthesize eventTable;
@synthesize eventTableCellItem;
@synthesize eventList;
@synthesize refreshButton;
@synthesize currentLocation;
@synthesize loading,loader;
@synthesize loadedWithLocation;
@synthesize needsUpdates;



-(void) viewWillAppear:(BOOL)animated{
    
    [self setupLeftMenuButton];
    
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    
    
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
  
    if ([eventDetails count]>0){
        self.eventList=eventDetails;
    } else {
        
        self.needsUpdates=TRUE;
        self.eventTable.alpha=0.0;
        self.loader.alpha=1.0;
        
        bool isSimulator=FALSE;
        
        if(isSimulator){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"getEventList"];
            [webby setDelegate:self];
            [webby submitLocationScan:(double)1.292771 andLong:(double)103.859343];
            // [webby submitLocationScan:(double)location.coordinate.latitude andLong:(double)location.coordinate.longitude];
            gettingUpdates=YES;
        } 
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
    
    self.eventTable.alpha=0.0;
    self.loader.alpha=1.0;
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
    
    /* Before loading the items*/

    [eventDetails setModalPresentationStyle:UIModalPresentationFullScreen];
    [eventDetails view];
    
    eventDetails.distance.text=[[text valueForKey:@"distance"] lowercaseString];
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
    
    eventDetails.distance.text=[text objectForKey:@"distance"];
    eventDetails.fScore.text=[text objectForKey:@"fScore"];
    eventDetails.timeDiff.text=[text objectForKey:@"timeDiff"];

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
    
    eventDetails.distance.text=[fmt stringFromNumber:[NSNumber numberWithFloat:[[text objectForKey:@"distance"] floatValue]*1000]];
   
    // eventDetails.latitude=[[text valueForKey:@"lotLAT"] floatValue];
   // eventDetails.longitude=[[text valueForKey:@"lotLNG"] floatValue];
    
    // eventDetails.detailTitle.text=[[detailManagedObject valueForKey:@"nText"] description];
    // eventDetails.detailHeader.text=[[detailManagedObject valueForKey:@"nHeader"] description];
    // eventDetails.detailDescription.text=[[detailManagedObject valueForKey:@"longText"] description];
    
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

- (void)locationsReceived:(NSDictionary *)resultData
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([resultData count] ==0){
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Tenqyu.com"
                                                          message:@"No event data available in your vincinity!"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
        
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



@end
