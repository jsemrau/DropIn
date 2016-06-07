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


@import GoogleMobileAds;

@interface PGFirstViewController ()

@end

@implementation PGFirstViewController

@synthesize eventTable,eventTableCellItem,eventList,refreshButton,currentLocation,loading,loader,messager, messagerLabel,loadedWithLocation,needsUpdates,weatherString,weatherNeedsUpdates,notiDictionary,likedIDs,refreshControl,cityHeader,whiter,prefCats,hasCategories,hasUpdates,
    gotoSettings,gotoRefresh,userDetails;

-(void) viewWillAppear:(BOOL)animated{
    
  /*
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"likedItems"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   */
    
    self.bannerView.adUnitID = @"ca-app-pub-7857198660418019/3237842480";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.alpha=0.0;
    
    if ([self.eventList count]==0) {
        self.eventTable.alpha=0.0;
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
        self.weatherString.text=[[NSDate date] description];
        // timer is set & will be triggered each second
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime) userInfo:nil repeats:YES];
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
        self.prefCats = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                         @"1",[NSString stringWithFormat:NSLocalizedString(@"category[0]", nil)],
                         @"1",[NSString stringWithFormat:NSLocalizedString(@"category[1]", nil)],
                         @"1",[NSString stringWithFormat:NSLocalizedString(@"category[2]", nil)],
                         @"1",[NSString stringWithFormat:NSLocalizedString(@"category[3]", nil)],
                         @"1",[NSString stringWithFormat:NSLocalizedString(@"category[4]", nil)],
                         @"1",[NSString stringWithFormat:NSLocalizedString(@"category[5]", nil)],
                         @"1",[NSString stringWithFormat:NSLocalizedString(@"category[6]", nil)],
                         @"1",[NSString stringWithFormat:NSLocalizedString(@"category[7]", nil)],
                         @"1",[NSString stringWithFormat:NSLocalizedString(@"category[8]", nil)],
                         @"1",[NSString stringWithFormat:NSLocalizedString(@"category[9]", nil)],
                         @"1",[NSString stringWithFormat:NSLocalizedString(@"category[10]", nil)],
                         @"1",[NSString stringWithFormat:NSLocalizedString(@"category[11]", nil)]
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
            [self fadeInImage];
            //self.loader.alpha=1.0;
            [self startingLoadingAnimation];
            
            
        }
        
    }
    
    
    [self.eventTable reloadData];
    
    if(!self.refreshControl){
        self.refreshControl = [UIRefreshControl new];
        
        self.refreshControl.backgroundColor=[UIColor whiteColor];
        self.refreshControl.tintColor=[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0];

        [refreshControl addTarget:self action:@selector(refreshButtonPress:) forControlEvents:UIControlEventValueChanged];
      
        
        [self.eventTable addSubview:refreshControl];
        [self.eventTable sendSubviewToBack:refreshControl];
    }
    
 
    
    self.cityHeader.layer.shadowColor = [UIColor grayColor].CGColor;
    self.cityHeader.layer.shadowOffset = CGSizeMake(0, 2);
    self.cityHeader.layer.shadowOpacity = 0.5;
    self.cityHeader.layer.shadowRadius = 1.0;
    
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    
    /* If need to get updates do that now */
    
    if (self.hasUpdates) {
        
        self.eventTable.alpha=0.0;
        self.messager.alpha=0.0;
        [self fadeInImage];
        
        [self refreshButtonPress:self];
        self.hasUpdates=FALSE;
    }

}

- (void) viewDidLoad:(BOOL) animated {
    
    [super viewDidLoad];

    self.eventTable.emptyDataSetSource = self;
    self.eventTable.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.eventTable.tableFooterView = [UIView new];
   
    
}

-(void)showTime{
    
    NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"HH:mm:ss"];
    
    self.weatherString.text=[formatter1 stringFromDate:[NSDate date] ];
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

- (IBAction)settingsButtonPress:(id)sender{
    
    UINavigationController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"THIRD_TOP_VIEW_CONTROLLER"];
    
    //UIViewController *vc= [centerViewController.viewControllers objectAtIndex:0];
   
    [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
    
}
- (IBAction)refreshButtonPress:(id)sender {
    
     self.loader.alpha=1.0;
    self.eventTable.alpha=0.0;
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

/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}*/

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
    
    cell.contentMode=UIViewContentModeScaleAspectFill;
    
    if ([self.filteredEventList count]>0){
        
        
        NSDictionary *text=[self.filteredEventList objectAtIndex:indexPath.row];
        
        
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
        
        if ([[text objectForKey:@"recommend_flag"] isEqualToString:@"1"]){
            
            cell.inXMinutes.text=@"recommended";
            cell.inXMinutes.textColor=[UIColor greenColor];
            
        }
        
        int durationCheck= [[text objectForKey:@"duration"] intValue]*-1 ;
        //which one is more negative
        if (tInterval <= durationCheck ){
            cell.inXMinutes.text=@"expired";
            cell.inXMinutes.textColor=[UIColor redColor];
        }
        
    
        if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[0]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"arts.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[1]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"business.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[2]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"education.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[3]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"entertainment.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[4]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"family.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[5]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"food.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[6]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"social.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[7]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"mass.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[8]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"meeting.png"];
        }
        
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[9]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"sports.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[10]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"tech.png"];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[11]", nil)]]) {
           
            cell.category.image = [UIImage imageNamed:@"other.png"];
            
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
        
        int counter = (int)[[text valueForKey:@"going_count"] integerValue ];
        
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
    
    NSMutableDictionary *text=[self.filteredEventList objectAtIndex:indexPath.row];
    
    
    //NSLog(@"%@", text);
    eventDetails.handOver=text;
    
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

- (void) noLocationsReceived{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No locations received"
                                                    message:@"Please adjust your Settings for this app."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self stoppingLoadingAnimation ];
    
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
        
        //Now you need to do the empty screen
        
        self.messagerLabel.text=@" There are no events around, you could try to adjust your settings!";
        self.messager.alpha=1.0;
        
        //
        
        
    } else {
    
        self.needsUpdates=FALSE;
        
        NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[resultData count]];
        
        
        self.eventList=nil;
        self.filteredEventList=nil;
        self.eventList = [NSMutableArray array];
        
       // NSLog(@"********************************");
        
        for (NSDictionary* campaignData in resultData) {
            
          // NSLog(@"Outputting cData %@", campaignData);
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
    [self stoppingLoadingAnimation ];
    [self.eventTable reloadData];
    
}


#pragma mark location delegate

- (void) locationManagerDidUpdateLocation:(CLLocation *)location {
    
    //store the current location in object
    self.currentLocation = location;
    
    if(weatherNeedsUpdates){

        
        //[self getweatherContext:self.currentLocation];
        
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
    
    NSLog(@" Getting location updates horizontalAccuracy is %f", location.horizontalAccuracy);
    
    if(self.needsUpdates ){
    
        if([self.userDetails count]==0) {
        
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            self.userDetails = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"userData"] ] ;
            
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"getEventList"];
        [webby setDelegate:self];
        [webby submitLocationScan:(double)location.coordinate.latitude andLong:(double)location.coordinate.longitude email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] ];
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
    self.filteredEventList  = [self.filteredEventList  sortedArrayUsingDescriptors:@[dateSortDescriptor]];
    
    [self.eventTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    
}

-(IBAction) sortByDate :(id)sender {
    
    
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"start_time" ascending:YES];
    self.filteredEventList  = [self.filteredEventList  sortedArrayUsingDescriptors:@[dateSortDescriptor]];
    
    [self.eventTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    
}

-(IBAction) sortByDistance :(id)sender {
    
    
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
    self.filteredEventList  = [self.filteredEventList  sortedArrayUsingDescriptors:@[dateSortDescriptor]];
    
    [self.eventTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    
}

- (NSArray*) filterArrayWithCategories : (NSArray*)dict {
    
    NSArray *filteredDict;
    
    NSMutableArray *parr = [NSMutableArray array];
    
    for (id star in self.prefCats) {
       // NSLog(@" Start : %@", [self.prefCats valueForKey:star]);
        if ([[self.prefCats valueForKey:star] isEqualToString:@"1"]) {
           [parr addObject:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%s",@"category == '",star,"'"]]];
        }
    }
    
    
    NSPredicate *applePred = [NSCompoundPredicate orPredicateWithSubpredicates:parr];
    filteredDict=[dict filteredArrayUsingPredicate:applePred];
    
    if ([filteredDict count]==0) {
        self.messagerLabel.text=@" No events found";
        return dict;
    } else {
        return filteredDict;
    }
    
    
}

- (void) startingLoadingAnimation {
    
    [self fadeInBanner];
   
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

- (void)fadeInBanner
{
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:1.5];
    self.bannerView.alpha = 1.0;
    [UIView commitAnimations];
    
}

- (void)fadeOutBanner
{
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:1.5];
    self.bannerView.alpha = 0.0;
    [UIView commitAnimations];
    
}

- (void) stoppingLoadingAnimation{
    
    [self.loading stopAnimating];
    [self fadeOutBanner];
    
}

#pragma mark empty data set delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty_placeholder"];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
    
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Please Allow Photo Access";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"This allows you to share photos from your library and save photos to your camera roll.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
    
    return [[NSAttributedString alloc] initWithString:@"Continue" attributes:attributes];
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return [UIImage imageNamed:@"button_image"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    return activityView;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -self.eventTable.tableHeaderView.frame.size.height/2.0f;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}


- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL) emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    // Do something
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    // Do something
}

@end
