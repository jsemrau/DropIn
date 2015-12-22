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

@synthesize eventTable,eventTableCellItem,eventList,refreshButton,currentLocation,loading,loader,messager, messagerLabel,loadedWithLocation,needsUpdates,weatherString,weatherNeedsUpdates,notiDictionary,likedIDs,refreshControl,cityHeader,whiter,prefCats,hasCategories,hasUpdates;

-(void) viewWillAppear:(BOOL)animated{
    
  /*
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"likedItems"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   */
    
    if (self.hasUpdates) {
        
        [self refreshButtonPress:self];
    }
    
    self.hasCategories=TRUE;
    
    [self setupLeftMenuButton];
    
    self.messager.alpha=0.0;
    //[self fadeOutImage];
    self.loader.alpha=0.0;
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    
    if([self.notiDictionary count]>0){
        
        NSString *dateString = [self.notiDictionary objectForKey:@"timeStamp"];
        NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
        [startDateFormat setDateFormat:@"yyyy-MM-dd H:mm:ss"];
        //        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        
        [startDateFormat setTimeZone:timeZone];
        [startDateFormat setFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDate *startDate1 = [startDateFormat dateFromString:dateString];
        
        float fInterval= [startDate1 timeIntervalSinceNow]/60;

        if (fInterval<-60) {
             self.weatherNeedsUpdates=true;
        }
        
        
    }
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
    
    
  /*
    
    QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"submitScan"];
    [webby setDelegate:self];
    [webby submitQRScan:@"https://choose.tenqyu.com?q=103a047313a84e37c195017a0eff503601eef833f52b5ea8a49411b85ff6e30c" email:[userDetails objectForKey:@"email"]  pwd:[userDetails objectForKey:@"pwd"] mongoId:[userDetails objectForKey:@"id"] withLat:self.currentLocation.coordinate.latitude andLong:self.currentLocation.coordinate.longitude];
    */
    NSUserDefaults *prefs;
    NSArray *eventDetails;
    
    
    prefs= [NSUserDefaults standardUserDefaults];
    
    //Try to load the prefcat
    self.prefCats =[prefs objectForKey:@"pref_Categories"];
    
    if (!self.prefCats) {
        //if there is no prefcat
        //  NSMutableDictionary
        self.prefCats = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"1",@"Arts",
                         @"1",@"Business",
                         @"1",@"Education",
                         @"1",@"Entertainment",
                         @"1",@"Family",
                         @"1",@"Food",
                         @"1",@"Social",
                         @"1",@"Large",
                         @"1",@"Meeting",
                         @"1",@"Sports",
                         @"1",@"Tech",
                         @"1",@"Other"
                         ,nil] ;
        
        [[NSUserDefaults standardUserDefaults] setObject:self.prefCats forKey:@"pref_Categories"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.likedIDs=[[prefs objectForKey:@"likedItems"] mutableCopy];
    //if I don't already have data
    if ([self.eventList count]==0) {
        
        
         eventDetails= [prefs objectForKey:@"currentEvents"];
 
        /**
         Need to filter here too
         **/
        
        if ([eventDetails count]>0){
            self.eventList=eventDetails;
            self.filteredEventList=[self filterArrayWithCategories:self.eventList];
            
            if ([self.filteredEventList count]==0){
                
                self.filteredEventList=self.eventList;
                
            }
            
            [self.eventTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            
        } else {
            
            self.needsUpdates=TRUE;
            //self.eventTable.alpha=0.0;
            [self fadeOutTableView];
            [self fadeInImage];\
            //self.loader.alpha=1.0;
            [self startingLoadingAnimation];
            
            
        }
        
    }
    
    
    [self.eventTable reloadData];
    
    if(!self.refreshControl){
        self.refreshControl = [UIRefreshControl new];
        //self.refreshControl.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:0.8];
        self.refreshControl.backgroundColor=[UIColor whiteColor];
        self.refreshControl.tintColor=[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0];

        [refreshControl addTarget:self action:@selector(refreshButtonPress:) forControlEvents:UIControlEventValueChanged];
      
        /*UIImageView *rcImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon-76@2x.png"]];
       // rcImageView.contentMode = UIViewContentModeCenter;
        rcImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [refreshControl insertSubview:rcImageView atIndex:0];*/
        
        [self.eventTable addSubview:refreshControl];
        [self.eventTable sendSubviewToBack:refreshControl];
    }
    
   /* if(!self.navigationItem.titleView){
   
        UILabel *lblTitle = [[UILabel alloc] init];
        lblTitle.text = @"Upcoming";
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0];
        lblTitle.shadowColor = [UIColor whiteColor];
        lblTitle.shadowOffset = CGSizeMake(0, 1);
        lblTitle.font = [UIFont fontWithName:@"AvenirNext-Regular" size:17.0];
        [lblTitle sizeToFit];
        
    self.navigationItem.titleView = lblTitle;
    }
    */
    
    self.cityHeader.layer.shadowColor = [UIColor grayColor].CGColor;
    self.cityHeader.layer.shadowOffset = CGSizeMake(0, 2);
    self.cityHeader.layer.shadowOpacity = 0.5;
    self.cityHeader.layer.shadowRadius = 1.0;
    
    /*
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = whiter.bounds;
    [whiter addSubview:visualEffectView];
    */
    
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

- (void)refreshButtonPress:(id)sender {
    
    self.messager.alpha=0.0;
    
    self.eventTable.alpha=0.0;
    [self fadeInImage];
    // self.loader.alpha=1.0;
    [self startingLoadingAnimation];
    //data not available anymore
    self.eventList=nil;
    self.filteredEventList=nil;
    self.needsUpdates=TRUE;
    
   // NSLog(@" current location lat %f and lng %f", self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude
         // );
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
    
    
    
    if ([self.filteredEventList count]>0){
        
        
        NSDictionary *text=[self.filteredEventList objectAtIndex:indexPath.row];
        NSString * test = [text objectForKey:@"category"];
        
        
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
            cell.inXMinutes.textColor=[UIColor colorWithRed:0/255.0 green:174/255.0 blue:239/255.0 alpha:1.0];
            
        } else {
            if (tInterval>60) {
                //convert to hours
                tInterval=tInterval/60;
               // NSLog(@" My Interval %d", tInterval);
                if (tInterval == 1) {
                     cell.inXMinutes.text=[@"in " stringByAppendingString: [[NSString stringWithFormat:@"%d",tInterval] stringByAppendingString:@" hr"]];
                } else {
                    cell.inXMinutes.text=[@"in " stringByAppendingString: [[NSString stringWithFormat:@"%d",tInterval] stringByAppendingString:@" hrs"]];
                }
            } else {
               // NSLog(@" My Interval %d", tInterval);
                
                cell.inXMinutes.text=[@"in " stringByAppendingString: [[NSString stringWithFormat:@"%d",tInterval] stringByAppendingString:@" min"]];
                cell.inXMinutes.textColor=[UIColor colorWithRed:57/255.0 green:181/255.0 blue:74/255.0 alpha:1.0];
            }
        }
        
        int durationCheck= [[text objectForKey:@"duration"] intValue]*-1 ;
        //which one is more negative
        if (tInterval <= durationCheck ){
            cell.inXMinutes.text=@"expired";
            cell.inXMinutes.textColor=[UIColor redColor];
        }
        
    
        if ([[text valueForKey:@"category"] isEqualToString:@"Arts"]) {
            cell.category.image = [UIImage imageNamed:@"arts.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString:@"Business"]) {
            cell.category.image = [UIImage imageNamed:@"business.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString:@"Education"]) {
            cell.category.image = [UIImage imageNamed:@"education.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString:@"Entertainment"]) {
            cell.category.image = [UIImage imageNamed:@"entertainment.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString:@"Family"]) {
            cell.category.image = [UIImage imageNamed:@"family.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString:@"Food"]) {
            cell.category.image = [UIImage imageNamed:@"food.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString:@"Mass"]) {
            cell.category.image = [UIImage imageNamed:@"mass.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString:@"Meeting"]) {
            cell.category.image = [UIImage imageNamed:@"meeting.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString:@"Other"]) {
            cell.category.image = [UIImage imageNamed:@"other.png"];
        }
        
        
        else if ([[text valueForKey:@"category"] isEqualToString:@"Sports"]) {
            cell.category.image = [UIImage imageNamed:@"sports.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString:@"Social"]) {
            cell.category.image = [UIImage imageNamed:@"social.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString:@"Tech"]) {
           
            cell.category.image = [UIImage imageNamed:@"tech.png"];
            
        } else {
            
            cell.category.image = [UIImage imageNamed:@"other.png"];
            
        }
        
        
        /* Rounded Edges */
        
        //CGSizeMake(3.0,3.0)
        //CGSizeMake(cell.category.frame.size.width/2, cell.category.frame.size.height/2)
        UIBezierPath *maskPathIcon = [UIBezierPath bezierPathWithRoundedRect:cell.category.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(3.0,3.0)];
        // Create the shape layer and set its path
        CAShapeLayer *maskLayerIcon = [CAShapeLayer layer];
        maskLayerIcon.frame = cell.category.bounds;
        maskLayerIcon.path = maskPathIcon.CGPath;
        // Set the newly created shape layer as the mask for the image view's layer
       cell.category.layer.mask = maskLayerIcon;
       cell.category.clipsToBounds = NO;
        
        
        
       
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
        
        UIImage *filledPerson = [UIImage imageNamed:@"personRun_blue.png"];
        
        int counter = [[text valueForKey:@"going_count"] integerValue ];
        
        if (0 <  counter  && counter  <10 ){
            
            cell.favInd1.image=filledPerson;
            cell.favInd1.alpha=1.0;
            cell.favInd2.alpha=0.35;
            cell.favInd3.alpha=0.35;
            
        } else if (10 <=  counter  && counter  <50) {
         
            cell.favInd1.image=filledPerson;
            cell.favInd2.image=filledPerson;
            
            cell.favInd1.alpha=1.0;
            cell.favInd2.alpha=1.0;
            cell.favInd3.alpha=0.35;
            
            
        } else if (50 <= counter ) {
            
            
            cell.favInd1.image=filledPerson;
            cell.favInd2.image=filledPerson;
            cell.favInd3.image=filledPerson;
            
            cell.favInd1.alpha=1.0;
            cell.favInd2.alpha=1.0;
            cell.favInd3.alpha=1.0;
            
          
            
        } else {
            
            cell.favInd1.alpha=0.35;
            cell.favInd2.alpha=0.35;
            cell.favInd3.alpha=0.35;
            
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
            //NSLog(@" String : %@", priceTest);
            
            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
            [currencyFormatter setLocale:[NSLocale currentLocale]];
            [currencyFormatter setMaximumFractionDigits:2];
            [currencyFormatter setMinimumFractionDigits:2];
            [currencyFormatter setAlwaysShowsDecimalSeparator:YES];
            [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            
            NSNumber *someAmount = [NSNumber numberWithFloat:[priceTest floatValue]];
            NSString *priceString = [currencyFormatter stringFromNumber:someAmount];
            
            //UIImage *filledCoin = [UIImage imageNamed:@"filledCoin.png"];
            //UIImage *notfilledCoin = [UIImage imageNamed:@"notfilledCoin.png"];
            
            cell.priceLabel1.text = [currencyFormatter currencySymbol];
            cell.priceLabel2.text = [currencyFormatter currencySymbol];
            cell.priceLabel3.text = [currencyFormatter currencySymbol];
            
            
            if ([someAmount floatValue] > 50.00) {
                
               /* cell.priceInd1.image=filledCoin;
                cell.priceInd2.image=filledCoin;
                cell.priceInd3.image=filledCoin;
                */
                
                cell.priceLabel1.textColor = [UIColor colorWithRed:251/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0];
                cell.priceLabel2.textColor = [UIColor colorWithRed:251/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0];
                cell.priceLabel3.textColor = [UIColor colorWithRed:251/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0];
                
                cell.priceLabel1.alpha=1.0;
                cell.priceLabel2.alpha=1.0;
                cell.priceLabel3.alpha=1.0;
                
                
                
           } else if (10 < [someAmount floatValue] && [someAmount floatValue] <= 50.0) {
               
              /* cell.priceInd1.image=filledCoin;
               cell.priceInd2.image=filledCoin;*/
               
               cell.priceLabel1.textColor = [UIColor colorWithRed:251/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0];
               cell.priceLabel2.textColor = [UIColor colorWithRed:251/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0];
               
               cell.priceLabel1.alpha=1.0;
               cell.priceLabel2.alpha=1.0;
               cell.priceLabel3.alpha=0.35;
             
           }else if (1 <= [someAmount floatValue]&&[someAmount floatValue] <= 10.0) {
            
              // cell.priceInd1.image=filledCoin;
               
               cell.priceLabel1.textColor = [UIColor colorWithRed:251/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0];
               cell.priceLabel1.alpha=1.0;
               cell.priceLabel2.alpha=0.35;
               cell.priceLabel3.alpha=0.35;
               
           } else {
             //Free
               
               cell.priceLabel1.alpha=0.35;
               cell.priceLabel2.alpha=0.35;
               cell.priceLabel3.alpha=0.35;
               
           }
            
            
            
        if ([priceTest isEqualToString:@"0"]||[priceTest isEqualToString:@"0.00"]){
          
            cell.priceInd1.alpha=1;
            cell.priceInd2.alpha=1;
            cell.priceInd3.alpha=1;
            
            
        }else{
            
            cell.price.alpha=0.0;
            cell.price.text=[priceString lowercaseString];
        }
            
        
        //if pricetest is not a number
        
        } else {
            
          
            //if not a number and there is nothing about prices, take the default string
            // cell.priceInd1.alpha=1;
            //cell.priceInd2.alpha=1;
            //cell.priceInd3.alpha=1;
         
            cell.priceLabel1.textColor = [UIColor colorWithRed:251/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0];
            cell.priceLabel1.alpha=1.0;
            cell.priceLabel2.alpha=0.35;
            cell.priceLabel3.alpha=0.35;

            
            //cell.price.text=[priceTest lowercaseString];
            
        }
        
        
        
        /*
        
        if ([[text objectForKey:@"going_count"] intValue]<=25) {
            cell.lotViewIndicator.image = [UIImage imageNamed:@"pk_map_icon_marker_red.png"];
        } else if (25< [[text objectForKey:@"going_count"] intValue] && [[text objectForKey:@"lots"] intValue]<=50) {
            cell.lotViewIndicator.image =[UIImage imageNamed:@"pk_map_icon_marker_yellow.png"];
        } else {
            cell.lotViewIndicator.image=[UIImage imageNamed:@"pk_map_icon_marker.png"];
        }*/
        
        
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
        
        
      
        
        if (self.likedIDs) {
            //if it does not exists then create array
            if ([self.likedIDs objectForKey:[text objectForKey:@"id"]]) {
                [cell.lotViewIndicator setImage:[UIImage imageNamed:@"Liked.png"]];
            }
        }
        
        
        if(self.eventTable.alpha==0.0){
        
           // self.eventTable.alpha=1.0;
            [self fadeInTableView];
        }
        
            
        
    } // self.eventlist - this one checks if there are more than one item in the list
    
    /*
    if (indexPath.row % 2) {
        
        cell.contentView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0];
        
    } else {
        
        cell.contentView.backgroundColor = [[UIColor alloc]initWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        
    }
    */
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //   NSLog(@"Number of games %lu",(unsigned long)[self.gameList count]);
    
    if ( [self.eventList count]==0) {
        
        return 1;
    
    } else {
        
        if (hasCategories) {
            return [self.filteredEventList count];
        } else {
        
            return  [self.eventList count];
        
            
        }
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Goto details view
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TQ_EventDetailsViewController *eventDetails = [storyboard instantiateViewControllerWithIdentifier:@"EVENT_DETAILS"];
    
    
    //PG_eventDetails *eventDetails = [[PG_eventDetails alloc] init] ;
    
    NSDictionary *text=[self.filteredEventList objectAtIndex:indexPath.row];
    //NSLog(@"Index %ld has %@",(long)indexPath.row,
     //     [text objectForKey:@"title"]);
    
    /* Try to get the strings done here*/
    eventDetails.latitude=[[text valueForKey:@"latitude"]floatValue] ;
    eventDetails.longitude=[[text valueForKey:@"longitude"] floatValue] ;
    eventDetails.vNameStr=[text objectForKey:@"venue_name"];
    eventDetails.eURL=[[text valueForKey:@"url"] lowercaseString];
    eventDetails.vStart_time=[text objectForKey:@"start_time"];
    eventDetails.vStop_time=[text objectForKey:@"stop_time"];
    eventDetails.idStr=[text objectForKey:@"id"];
    
    //NSLog(@" Check this %@",[text objectForKey:@"id"]);
    /* Before loading the items*/

    [eventDetails setModalPresentationStyle:UIModalPresentationFullScreen];
    [eventDetails view];
    
    //eventDetails.distance.text=[[text valueForKey:@"distance"] lowercaseString];
    
    float dist = [[text objectForKey:@"distance"] floatValue];
    if (dist>=1) {
        
        eventDetails.distance.text=[[NSString stringWithFormat:@"%.1f",dist] stringByAppendingString: @" km"] ;
    } else {
        dist=dist*1000;
        float new = [[NSString stringWithFormat:@"%.2f",dist]floatValue];
        eventDetails.distance.text=[[NSString stringWithFormat:@"%d",(int)new] stringByAppendingString: @" mtrs"] ;
        
    }
    
    eventDetails.duration.text=[[text valueForKey:@"duration"] lowercaseString];
    
    
    NSString *priceTest=[[text objectForKey:@"price"] lowercaseString];
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
            
            eventDetails.going_count.text=[NSString stringWithFormat:@"%@", [text valueForKey:@"going_count"]];
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
    
    if([[text valueForKey:@"source"] isEqualToString:@"meetup.com"] ){
     eventDetails.vSource.image = [UIImage imageNamed:@"meetup.png"];
    }
    
    if([[text valueForKey:@"source"] isEqualToString:@"eventfinda"] ){
        eventDetails.vSource.image = [UIImage imageNamed:@"eventfinda.png"];
    }
    
    if([[text valueForKey:@"source"] isEqualToString:@"eventful"] ){
        eventDetails.vSource.image = [UIImage imageNamed:@"eventful.png"];
    }
    
    NSAttributedString *tmpStr = [[NSAttributedString alloc] initWithData:[[text valueForKey:@"description"] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    
    [eventDetails.eDescription  setScrollEnabled:NO];
    eventDetails.eDescription.text=[tmpStr string]  ;
    [eventDetails.eDescription setContentOffset:CGPointZero animated:YES];
    [eventDetails.eDescription setScrollEnabled:YES];
    
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
    
    /*
    float fInterval= [startDate1 timeIntervalSinceNow];
    
    if (fInterval>60) {
        //convert to hours
        fInterval=fInterval/60;
        
        if (fInterval == 1.00) {
            eventDetails.timeDiff.text=[NSString stringWithFormat:@"%.2f",fInterval];
            eventDetails.inXminutes.text=@"hr";
        } else {
            eventDetails.timeDiff.text=[NSString stringWithFormat:@"%.2f",fInterval];
            eventDetails.inXminutes.text=@"hrs";
        }
    } else {
    //    NSLog(@" My Interval %.2f", fInterval);
        
        eventDetails.timeDiff.text=[NSString stringWithFormat:@"%d",(int)fInterval];
        eventDetails.inXminutes.text=@"min";
    }
    */

    float fInterval= [startDate1 timeIntervalSinceNow]/60;
    
    int hours= fabsf(fInterval)/60;
    int minutes = fabsf(fInterval) - (hours*60);
    
    
    eventDetails.timeDiff.text= [NSString stringWithFormat:@"%d:%02d", hours,minutes];
    
  
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.notiDictionary=[resultData mutableCopy];
    
    if ([[self.notiDictionary objectForKey:@"type"] isEqualToString:@"weather"]) {
        
        self.weatherString.text = [NSString stringWithFormat:@"%@%@%@%@",
                                   @"It is " , [self.notiDictionary valueForKey:@"temp_c" ] , @"°C and ", [self.notiDictionary valueForKey:@"weather" ]];
        self.weatherNeedsUpdates=FALSE;
        
    }
    
    
    //for (NSDictionary* notification in resultData) {
    //}
    
}


- (void)locationsReceived:(NSDictionary *)resultData
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    self.loader.alpha=0.0;
    //[self fadeOutImage];
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
        self.filteredEventList=nil;
        self.eventList = [NSMutableArray array];
        
       // NSLog(@"********************************");
        
        for (NSDictionary* campaignData in resultData) {
            
          //  NSLog(@"Outputting cData %@", campaignData);
            [data addObject:campaignData];
            
            
        }
        
        if([self.loading isAnimating]) {
            
            //  [self stoppingLoadingAnimation];
            
        }
        
        //self.eventTable.alpha=1.0;
        
        [self fadeInTableView];
        self.loader.alpha=0.0;
        self.eventList = [[NSArray alloc] initWithArray:data];
        self.filteredEventList = [self filterArrayWithCategories:self.eventList];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.eventList forKey:@"currentEvents"];
        [[NSUserDefaults standardUserDefaults] setObject:self.prefCats forKey:@"pref_Categories"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self.eventTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
        [[self.view viewWithTag:12] removeFromSuperview];
    
    }
    
    [refreshControl endRefreshing];
    [self.eventTable reloadData];
    
}


#pragma mark location delegate

- (void) locationManagerDidUpdateLocation:(CLLocation *)location {
    
    //store the current location in object
    self.currentLocation = location;
    
    if(weatherNeedsUpdates){

        
        [self getweatherContext:self.currentLocation];
        
        /*
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
        });*/
        
       
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

-(IBAction) sortByCategory :(id)sender {
    
    
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES];
    self.eventList  = [self.eventList  sortedArrayUsingDescriptors:@[dateSortDescriptor]];
    
    [self.eventTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    
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

- (NSArray*) filterArrayWithCategories : (NSArray*)dict {
    
    
    for (id star in dict) {
        
        NSLog(@" %@", [star objectForKey:@"category"]);
    }
        
    NSArray *filteredDict;
    
    NSMutableArray *parr = [NSMutableArray array];
    
    for (id star in self.prefCats) {
        NSLog(@" Start : %@", [self.prefCats valueForKey:star]);
        if ([[self.prefCats valueForKey:star] isEqualToString:@"1"]) {
           [parr addObject:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%s",@"category == '",star,"'"]]];
        }
    }
    
  
    NSLog(@" Array %lu", (unsigned long)[parr count]);
    
    NSPredicate *applePred = [NSCompoundPredicate orPredicateWithSubpredicates:parr];
    filteredDict=[dict filteredArrayUsingPredicate:applePred];
    
    if ([filteredDict count]==0) {
        self.messagerLabel.text=@" No events found";
        return dict;
    } else {
        NSLog(@" filtered length %lu", [filteredDict count]);
        return filteredDict;
    }
    
    
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
  //  NSLog(@" Rect .x %f , .y %f",rect.origin.x, rect.origin.y);
    self.loading = [[UIImageView alloc] initWithFrame:rect];
  
    self.loading.animationImages = imageArray;
    self.loading.animationDuration = 1.5;
    self.loading.contentMode = UIViewContentModeCenter;
    [self.loader addSubview:self.loading];
    [self.loading startAnimating];
}

-(void) getweatherContext:(CLLocation*)wLocation{
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"getWeatherContext"];
    [webby setDelegate:self];
    [webby submitWeatherRequest:currentLocation.coordinate.latitude andLong:currentLocation.coordinate.longitude];
    
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

- (void)fadeInImage
{
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:1.5];
    self.loader.alpha = 1.0;
    [UIView commitAnimations];
    
}

- (void)fadeOutImage
{
    [UIView beginAnimations:@"fade out" context:nil];
    [UIView setAnimationDuration:1.5];
    self.loader.alpha = 0.0;
    [UIView commitAnimations];
    
}

- (void)fadeInTableView
{
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:1.5];
    self.eventTable.alpha = 1.0;
    [UIView commitAnimations];
    
}

- (void)fadeOutTableView
{
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:1.5];
    self.eventTable.alpha = 0.0;
    [UIView commitAnimations];
    
}

- (void) stoppingLoadingAnimation{
    
    [self.loading stopAnimating];
    
}




@end
