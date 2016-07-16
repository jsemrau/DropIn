//
//  PGFirstViewController.m
// SideDrawerExample
//
//  Created by Pulkit Goyal on 18/09/14.
//  Copyright (c) 2014 Pulkit Goyal. All rights reserved.
//

#import "PGFirstViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "TQ_EventDetailsViewController.h"


@import GoogleMobileAds;

@interface PGFirstViewController ()

@property(weak,nonatomic) IBOutlet SpringView *loader ;
@property(weak,nonatomic) IBOutlet SpringImageView *loading ;

@end

@implementation PGFirstViewController

@synthesize eventTable,eventTableCellItem,eventList,refreshButton,currentLocation,loading,loader,messager, messagerLabel,loadedWithLocation,needsUpdates,weatherString,weatherNeedsUpdates,notiDictionary,likedIDs,refreshControl,cityHeader,whiter,prefCats,hasCategories,hasUpdates,
    gotoSettings,gotoRefresh,userDetails,footerImageView, bar1,bar2,bar3;

-(void) viewWillAppear:(BOOL)animated{
    
    [self setupLeftMenuButton];
    [self.navigationController setHidesNavigationBarHairline:YES];
    
   
    
    [self.eventTable setDataSource:self];
    self.eventTable.delegate = self;
    self.eventTable = eventTable;

    
    
    /* Set delegate for empty data source */
    self.eventTable.emptyDataSetSource = self;
    self.eventTable.emptyDataSetDelegate = self;
    
    self.bannerView.adUnitID = @"ca-app-pub-7857198660418019/3237842480";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.alpha=0.0;
    
    
    /* for future release you can have that based on the selection configuration*/
    self.hasCategories=TRUE;
    
    /* round edges */
    
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.messager.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(3.0,3.0)];
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.messager.bounds;
    maskLayer.path = maskPath.CGPath;
    // Set the newly created shape layer as the mask for the image view's layer
   self.messager.layer.mask = maskLayer;
   self.messager.clipsToBounds = NO;
    
    //if there were updates then you need to reload data
    if(needsUpdates){
        
        self.eventTable.alpha=0.0;
  
        BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
        
        if (!locationAllowed)
        {
            
            [self notifyMe:@"err-loc-disable" withMessage:@"err-loc-enable"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"prefs:root=LOCATION_SERVICES"]];
        }
        
        [[GFLocationManager sharedInstance] addLocationManagerDelegate:self];
        
    }
    
    /*  Make sure only the table is displayed on start */
    //don't show anything
    
    self.messager.alpha=0.0;
    self.loading.alpha=0.0;
    self.eventTable.alpha=0.0;
    
  
  /*
    
    QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"submitScan"];
    [webby setDelegate:self];
    [webby submitQRScan:@"https://choose.tenqyu.com?q=103a047313a84e37c195017a0eff503601eef833f52b5ea8a49411b85ff6e30c" email:[userDetails objectForKey:@"email"]  pwd:[userDetails objectForKey:@"pwd"] mongoId:[userDetails objectForKey:@"id"] withLat:self.currentLocation.coordinate.latitude andLong:self.currentLocation.coordinate.longitude];
    */
    
    NSUserDefaults *prefs;
    NSArray *eventDetails;
    
    prefs= [NSUserDefaults standardUserDefaults];
    self.userDetails = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"userData"]] ;

    [self loadPreferences];
    
    self.likedIDs=[[prefs objectForKey:@"likedItems"] mutableCopy];
    //if I don't already have data
    if ([self.eventList count]==0) {
        
        //First try to reload from local
         eventDetails= [prefs objectForKey:@"currentEvents"];
 
        /**
         Need to filter here too
         **/
        
        if ([eventDetails count]>0){
            self.eventList=eventDetails;
            self.filteredEventList=[self filterArrayWithCategories:self.eventList];
            
            //since you handle the error string; better remove this.
            
            if ([self.filteredEventList count]==0){
                
            //    self.filteredEventList=self.eventList;
                self.messagerLabel.text=[NSString stringWithFormat:NSLocalizedString(@"err-noloc", nil)];
                self.loader.alpha=0.0;
                self.messager.alpha=1.0;
                self.eventTable.alpha=1.0;
                
            } else {
                
                [self.eventTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                [self fadeInTableView];
            }
            
            
            
            
        } else {
            
            self.needsUpdates=TRUE;
            
        }
        
    }
    
    
    [self.eventTable reloadData];
    
    if(!self.refreshControl){
        self.refreshControl = [UIRefreshControl new];
        
        self.refreshControl.backgroundColor=[UIColor whiteColor];
        self.refreshControl.tintColor=[UIColor flatSkyBlueColor];
    
        //[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0];s
        
        //SpringImageView *rcImageView =[[SpringImageView alloc] initWithFrame:CGRectMake(
          //                                                ((self.refreshControl.bounds.size.width)/2)-50, self.refreshControl.bounds.size.height/2,328, 228)];
       // SpringImageView *rcImageView =SpringImageView
        //;
        
        UIImageView *rcImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"asia-blue.png"]];
        
        [rcImageView setContentMode:UIViewContentModeScaleAspectFill];
        //UIViewContentModeScaleAspectFit
        [self.refreshControl insertSubview:rcImageView atIndex:0];
        
        
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
    
    if (self.needsUpdates) {
        
        self.messager.alpha=0.0;
        [self fadeInImage];
        [self refreshButtonPress:self];
        
    } else {
        
        [self fadeOutImage];
        [self fadeOutBanner];
        [self fadeInTableView];
        
    }
    

    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [self.view addSubview:self.loader];
    
    //disable scroll to top for all text views
    for (UITextView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextView class]]) {
            view.scrollsToTop = NO;
        }
    }
    
    
    self.eventTable.scrollsToTop =YES;
    
    //distance
    FAKFontAwesome *clockIcon = [FAKFontAwesome mapMarkerIconWithSize:25];
    [clockIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor] ];
    UIImage *iconImage = [clockIcon imageWithSize:CGSizeMake(35, 35)];
    //[UIImage imageNamed:@"sortByDistance32x32.png"]
    UIImage *image = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.bar1 = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(sortByDistance:)];
    
    //time
    clockIcon = [FAKFontAwesome clockOIconWithSize:25];
    [clockIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor] ];
    iconImage = [clockIcon imageWithSize:CGSizeMake(35, 35)];
    //[UIImage imageNamed:@"sortByDistance32x32.png"]
    image = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.bar2 = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(sortByDate:)];
    
    //cat
    clockIcon = [FAKFontAwesome sortAlphaAscIconWithSize:25];
    [clockIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor] ];
    iconImage = [clockIcon imageWithSize:CGSizeMake(35, 35)];
    //[UIImage imageNamed:@"sortByDistance32x32.png"]
    image = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.bar3 = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(sortByCategory:)];
    
    NSMutableArray * arr = [NSMutableArray arrayWithObjects: self.bar3,self.bar2,self.bar1, nil];
    
    [self.navigationItem setRightBarButtonItems:arr];
  
    
    
}
- (void) viewDidLoad:(BOOL) animated {
    
    [super viewDidLoad];

    
    
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
    
    // self.loader.alpha=1.0;
    self.hasUpdates=FALSE;
    self.needsUpdates=TRUE;
    
    self.eventTable.alpha=0.0;
    self.messager.alpha=0.0;
    
    [self startingLoadingAnimation];
  
    //data not available anymore
    //don't do this here you don't know if the call to update will be successful.
 
    if(!gettingUpdates){
        [[GFLocationManager sharedInstance] addLocationManagerDelegate:self];
    }
    
    
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
    return 90;
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
        
        //configure interaction buttons
        
        //get image
        FAKFontAwesome *likeIcon = [FAKFontAwesome heartOIconWithSize:50];
        [likeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatWhiteColor]];
        UIImage *iconImage = [likeIcon imageWithSize:CGSizeMake(75, 75)];
        cell.lotViewIndicator.contentMode=UIViewContentModeScaleAspectFit;
        
        //[UIImage imageNamed:@"fav.png"]
        
        MGSwipeButton *likeBtn = [MGSwipeButton buttonWithTitle:@"" icon:iconImage backgroundColor:[UIColor flatBlueColor] callback:^BOOL(MGSwipeTableCell *sender) {
            
            NSLog(@"Convenience callback for swipe buttons!");
             [self sendFavorite:sender withId:[text objectForKey:@"id"]];
            
            return true;
            
        } ];
        
        MGSwipeButton *spamBtn = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"reportSpam.png"] backgroundColor:[UIColor flatRedColor] callback:^BOOL(MGSwipeTableCell *sender) {
            NSLog(@"Convenience callback for reportSpam:!");
            
            [self reportSpam:[text objectForKey:@"id"] atIndex:indexPath];
            
            return true;
        } ];
        
        //get image
        FAKFontAwesome *dislikeIcon = [FAKFontAwesome thumbsDownIconWithSize:50];
        [dislikeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatWhiteColor]];
        iconImage = [dislikeIcon imageWithSize:CGSizeMake(75, 75)];
        cell.lotViewIndicator.contentMode=UIViewContentModeScaleAspectFit;
        
        MGSwipeButton *dislikeBtn = [MGSwipeButton buttonWithTitle:@"" icon:iconImage backgroundColor:[UIColor flatRedColorDark] callback:^BOOL(MGSwipeTableCell *sender) {
            NSLog(@"Convenience callback for dislikeBtn:!");
            
            [self sendDislike:sender withId:[text objectForKey:@"id"] atIndex:indexPath];
            
            return true;
        } ];
        
        
        cell.rightButtons = @[dislikeBtn,spamBtn];
        cell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
        
        cell.leftButtons = @[likeBtn];
        cell.leftSwipeSettings.transition = MGSwipeTransitionDrag;
        
        
        cell.title.text=[text objectForKey:@"title"];
        
        NSAttributedString *tmpStr = [[NSAttributedString alloc] initWithData:[[text objectForKey:@"description"] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
        
        cell.desc.text=[tmpStr string];

        
        NSString *dateString = [text objectForKey:@"start_time"];
        NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
        [startDateFormat setDateFormat:@"yyyy-MM-dd H:mm:ss"];
//        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        
        [startDateFormat setTimeZone:timeZone];
        [startDateFormat setFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDate *startDate1 = [startDateFormat dateFromString:dateString];
        
        int tInterval = (int)round([startDate1 timeIntervalSinceNow]/60);
        
        
        if(tInterval<=0){
            
            cell.inXMinutes.text=@"started";
            
           // cell.inXMinutes.textColor=[UIColor colorWithRed:0/255.0 green:174/255.0 blue:239/255.0 alpha:1.0];
            cell.inXMinutes.textColor=[UIColor flatSkyBlueColor];
            
            
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
                cell.inXMinutes.textColor= [UIColor flatSkyBlueColor];
                //[UIColor colorWithRed:57/255.0 green:181/255.0 blue:74/255.0 alpha:1.0];
            }
        }
        
        if ([[text objectForKey:@"recommend_flag"] isEqualToString:@"1"]){
            
            cell.inXMinutes.text=@"recommended";
            cell.inXMinutes.textColor=[UIColor flatGreenColor];
            
        }
        
        int durationCheck= [[text objectForKey:@"duration"] intValue]*-1 ;
        //which one is more negative
        if (tInterval <= durationCheck ){
            cell.inXMinutes.text=@"expired";
            cell.inXMinutes.textColor=[UIColor flatRedColor];
        }
        
    
        if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[0]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"arts.png"];
            cell.category.backgroundColor=[UIColor flatRedColor];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[1]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"business.png"];
            cell.category.backgroundColor=[UIColor flatPowderBlueColor];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[2]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"education.png"];
            cell.category.backgroundColor=[UIColor flatMintColorDark];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[3]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"entertainment.png"];
            cell.category.backgroundColor=[UIColor flatMintColor];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[4]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"family.png"];
            cell.category.backgroundColor=[UIColor flatPinkColor];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[5]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"food.png"];
            cell.category.backgroundColor=[UIColor flatSandColorDark];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[6]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"social.png"];
            cell.category.backgroundColor=[UIColor flatPurpleColor];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[7]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"mass.png"];
            cell.category.backgroundColor=[UIColor flatBlueColor];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[8]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"meeting.png"];
            cell.category.backgroundColor=[UIColor flatWatermelonColorDark];
        }
        
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[9]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"sports.png"];
            cell.category.backgroundColor=[UIColor flatBrownColor];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[10]", nil)]]) {
            cell.category.image = [UIImage imageNamed:@"tech.png"];
            cell.category.backgroundColor=[UIColor flatSkyBlueColorDark];
        }
        
        else if ([[text valueForKey:@"category"] isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[11]", nil)]]) {
           
            cell.category.image = [UIImage imageNamed:@"other.png"];
            cell.category.backgroundColor=[UIColor flatWhiteColorDark];
            
        } else {
            
            cell.category.image = [UIImage imageNamed:@"other.png"];
            cell.category.backgroundColor=[UIColor flatWhiteColorDark];

            
        }
        
        
        /* Rounded Edges */
        
       //Make it round
        // cell.category.layer.cornerRadius = cell.category.frame.size.height/2; // this value vary as per your desire
       // cell.category.clipsToBounds = YES;
        
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
                
                cell.priceLabel1.textColor = [UIColor flatYellowColorDark];
               // [UIColor colorWithRed:251/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0];
                cell.priceLabel2.textColor =[UIColor flatYellowColorDark];
                cell.priceLabel3.textColor =[UIColor flatYellowColorDark];
                
                cell.priceLabel1.alpha=1.0;
                cell.priceLabel2.alpha=1.0;
                cell.priceLabel3.alpha=1.0;
                
                
                
           } else if (10 < [someAmount floatValue] && [someAmount floatValue] <= 50.0) {
               
              /* cell.priceInd1.image=filledCoin;
               cell.priceInd2.image=filledCoin;*/
               
               cell.priceLabel1.textColor =[UIColor flatYellowColorDark];
               cell.priceLabel2.textColor =[UIColor flatYellowColorDark];
               
               cell.priceLabel1.alpha=1.0;
               cell.priceLabel2.alpha=1.0;
               cell.priceLabel3.alpha=0.35;
             
           }else if (1 <= [someAmount floatValue]&&[someAmount floatValue] <= 10.0) {
            
              // cell.priceInd1.image=filledCoin;
               
               cell.priceLabel1.textColor =[UIColor flatYellowColorDark];
               //[UIColor colorWithRed:251/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0];
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
         
           // cell.priceLabel1.textColor =[UIColor flatYellowColorDark];
            //[UIColor colorWithRed:251/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0];
            cell.priceLabel1.alpha=0.35;
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
                
                //get image
                FAKFontAwesome *likeIcon = [FAKFontAwesome heartIconWithSize:10];
                [likeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor]];
                UIImage *iconImage = [likeIcon imageWithSize:CGSizeMake(20, 20)];
                cell.lotViewIndicator.contentMode=UIViewContentModeScaleAspectFit;
               
                //set image
                //[self.favButton setBackgroundImage:iconImage forState:UIControlStateNormal];
                cell.lotViewIndicator.backgroundColor = [UIColor flatWhiteColor];
                [cell.lotViewIndicator setImage:iconImage];
                
                //round edges
                cell.lotViewIndicator.layer.cornerRadius = cell.lotViewIndicator.frame.size.height/2; // this value vary as per your desire
                cell.lotViewIndicator.clipsToBounds = YES;
                
                
              //--orig  [cell.lotViewIndicator setImage:[UIImage imageNamed:@"Liked.png"]];
                
            }
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
        
        return 0;
    
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
    
    lotCell *cell = [self.eventTable cellForRowAtIndexPath:indexPath];
    
    NSString* colorString = [cell.category.backgroundColor description];
    
   // eventDetails.themeColor = ;
    
    NSLog(@"%@", colorString);
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
    
    gettingUpdates=FALSE;
    
    [self stoppingLoadingAnimation ];
    self.eventTable.alpha=0.0;
    //[self.eventTable removeFromSuperview];
    
    if ([self.filteredEventList count]==0){
        /* Show message*/
        self.messagerLabel.text=[NSString stringWithFormat:NSLocalizedString(@"err-noloc", nil)];
        self.messager.alpha=1.0;
        self.eventTable.alpha=1.0;
    }
    
}

- (void)notificationsReceived:(NSDictionary *)resultData{
    
    gettingUpdates=FALSE;
    
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
    
    /* Case there are no events around you */
    
    gettingUpdates=FALSE;
    
    if ([resultData count] ==0){
        
        //Now you need to do the empty screen
        
        self.messagerLabel.text=[NSString stringWithFormat:NSLocalizedString(@"err-noloc", nil)];
        
        [self stoppingLoadingAnimation];
        [self fadeOutImage];
        self.messager.alpha=1.0;
        
        //
        self.needsUpdates=TRUE;
        
    } else {
    
        self.needsUpdates=FALSE;
        self.hasUpdates=TRUE;
        
        
        NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[resultData count]];
        
        
        self.eventList=nil;
        self.filteredEventList=nil;
        self.eventList = [NSMutableArray array];
        
       // NSLog(@"********************************");
        
        for (NSDictionary* campaignData in resultData) {
            
          // NSLog(@"Outputting cData %@", campaignData);
            [data addObject:campaignData];
            
            
        }
        
        self.eventList = [[NSArray alloc] initWithArray:data];
        self.filteredEventList = [self filterArrayWithCategories:self.eventList];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.eventList forKey:@"currentEvents"];
        [[NSUserDefaults standardUserDefaults] setObject:self.prefCats forKey:@"pref_Categories"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self.eventTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
        [[self.view viewWithTag:12] removeFromSuperview];
        
        //Now it is time to show the table again
        [self.eventTable reloadData];
      
        
    
    }
    
    [refreshControl endRefreshing];
    
    if(!self.needsUpdates){
        
        [self stoppingLoadingAnimation ];
        [self fadeInTableView];
        
    }
    
   
    
}


#pragma mark location delegate

- (void) locationManagerDidUpdateLocation:(CLLocation *)location {
    
    
  //  NSTimeInterval locationAge = -[location.timestamp timeIntervalSinceNow];
   // if (locationAge > 5.0) return;
    
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
       
     //   *fix that later
        if(!gettingUpdates){
        
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"getEventList"];
            [webby setDelegate:self];
            [webby submitLocationScan:(double)location.coordinate.latitude andLong:(double)location.coordinate.longitude email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] ];
            gettingUpdates=TRUE;
            
            //stop updating locations
            //[[GFLocationManager sharedInstance] removeLocationManagerDelegate:self];
                
        }
            
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
    
    /* --temp disable
    if ([filteredDict count]==0) {
        self.messagerLabel.text=@" No events found";
        return dict;
    } else {
        return filteredDict;
    }*/
    
     return filteredDict;
    
}

#pragma mark animations
- (void) startingLoadingAnimation {
    
    SpringImageView *springView = [[SpringImageView alloc] initWithFrame:CGRectMake(
                                    (([[UIScreen mainScreen] bounds].size.width)/2)-50,  (([[UIScreen mainScreen] bounds].size.width)/2)+50, 100, 100)];
    self.loading = springView;
    self.loading.image= [UIImage imageNamed:@"drop-transparent.png"];
    self.loading.backgroundColor = [UIColor clearColor];
    self.loading.animation = @"morph";
    self.loading.delay = 0;
    self.loading.duration = 3;
    self.loading.repeatCount=20;
    self.loading.autostart = true;
    self.loading.contentMode= UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.loading];
    [self.loading animate];
    [self fadeInBanner];
   
}

- (void) stoppingLoadingAnimation{
    
   //
   
    if ([self.loading isDescendantOfView:self.view]){
    
        [self.loading removeFromSuperview];
        
    }
    [self fadeOutBanner];
    [self fadeOutImage];
    
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
    self.loading.alpha = 1.0;
    [UIView commitAnimations];
    
}

- (void)fadeOutImage
{
    [UIView beginAnimations:@"fade out" context:nil];
    [UIView setAnimationDuration:1.5];
    self.loading.alpha = 0.0;
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
    [UIView setAnimationDuration:2.5];
    self.bannerView.alpha = 0.0;
    [UIView commitAnimations];
    
}



#pragma mark empty data set delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"city-master-02 small.png"];
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
   
    NSString *text =  [NSString stringWithFormat:NSLocalizedString(@"game", nil)];
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor flatGrayColorDark]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text =[NSString stringWithFormat:NSLocalizedString(@"err-noloc", nil)];
    //@"This allows you to share photos from your library and save photos to your camera roll.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:17],
                                 NSForegroundColorAttributeName: [UIColor flatGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
   //NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:17],
                                 NSForegroundColorAttributeName: [UIColor flatSkyBlueColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:@"go to settings" attributes:attributes];
  //  return nil;
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    //return [UIImage imageNamed:@"asia-color.png"];
    return nil;
    
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor flatWhiteColor];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSLog(@" this is here");
   /* UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    return activityView;*/
    
    return nil;
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
    NSLog(@"Hey view, you should go to settings now");
    
    UINavigationController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"THIRD_TOP_VIEW_CONTROLLER"];
    
    [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
    
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    // Do something
    NSLog(@"Hey Button you should go to settings now");
    
    UINavigationController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"THIRD_TOP_VIEW_CONTROLLER"];
    
    [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
    
    
}

#pragma mark interactions
- (void) reportSpam:(NSString*)idStr atIndex:(NSIndexPath *)indexPath {
    

    NSDictionary *tmpCell= [self.filteredEventList objectAtIndex:indexPath.row];
    
    NSLog(@" testing %@", [tmpCell objectForKey:@"id"]                              );
    
    // for(NSDictionary *vDic in self.eventList){
    
    int iValue=-1;
    for(int i=0; i < [self.eventList count]; i++){
        
        NSDictionary *vDic = self.eventList[i];
        
        if([tmpCell objectForKey:@"id"]  == [vDic objectForKey:@"id"] ){
            
            NSLog(@" Found it %@", [vDic objectForKey:@"title"]);
            iValue= i;
            break;
            
        }
    }
    
    if (iValue!=-1) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.eventList];
        [tmpArray removeObjectAtIndex:(NSInteger)iValue];
        self.eventList = [NSArray arrayWithArray: tmpArray];
        self.filteredEventList=[self filterArrayWithCategories:self.eventList];
        //Now sync back.
        [[NSUserDefaults standardUserDefaults] setObject:self.eventList forKey:@"currentEvents"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"saveImpression"];
    [webby setDelegate:self];
    
    NSLog(@" trying to send for user : %@ and id %@", [userDetails objectForKey:@"email"], idStr);
    
    [webby saveImpression:[NSString stringWithFormat:NSLocalizedString(@"imp-spam", nil)] onAsset:idStr email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] withLat:(double)self.currentLocation.coordinate.latitude  andLong:(double)(double)self.currentLocation.coordinate.longitude];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self notifyMe:@"game" withMessage:@"err-spam"];
    
    [self.eventTable reloadData];
    
}

- (void)sendFavorite:(id)sender withId:(NSString*)idStr{
    
    
        if ([self.likedIDs objectForKey: idStr]) // YES
        {
            // Do something
            
            [self.likedIDs removeObjectForKey:idStr];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"saveImpression"];
            [webby setDelegate:self];
            
            [webby saveImpression:[NSString stringWithFormat:NSLocalizedString(@"imp-unliked", nil)] onAsset:idStr email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] withLat:(double)self.currentLocation.coordinate.latitude andLong:(double)self.currentLocation.coordinate.longitude];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        
     } else {
        
        if(idStr && self.likedIDs) //or if(str != nil) or if(str.length>0)
        {
            
            if([self.likedIDs count]>0){
                [self.likedIDs setObject:[NSDate date] forKey:idStr];
            } else {
                
                self.likedIDs = [[[NSDictionary alloc] initWithObjectsAndKeys:[NSDate date ],idStr,nil] mutableCopy];
            }
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"saveImpression"];
            [webby setDelegate:self];
            
            [webby saveImpression:[NSString stringWithFormat:NSLocalizedString(@"imp-liked", nil)] onAsset:idStr email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] withLat:(double)self.currentLocation.coordinate.latitude andLong:(double)self.currentLocation.coordinate.longitude];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        }
   
         NSLog(@"%@", idStr);
        
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.likedIDs forKey:@"likedItems"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.eventTable reloadData];
}


- (void)sendDislike:(id)sender withId:(NSString*)idStr atIndex:(NSIndexPath *)indexPath{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    QyuWebAccess *webby = [[QyuWebAccess alloc] initWithConnectionType:@"saveImpression"];
    [webby setDelegate:self];
    
    [webby saveImpression:[NSString stringWithFormat:NSLocalizedString(@"imp-disliked", nil)] onAsset:idStr email:[userDetails objectForKey:@"email"] pwd:[userDetails objectForKey:@"pwd"]  mongoId:[userDetails objectForKey:@"id"] withLat:(double)self.currentLocation.coordinate.latitude andLong:(double)self.currentLocation.coordinate.longitude];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  
    //[self.likedIDs removeObjectForKey:idStr];
    
  //  NSDictionary *Tst = [self.eventList objectAtIndex:indexPath.row];
    
    // 1. find the element at current row.index from filteredEvent
    // 2. take the index and find it in the eventlist
    // 3. remove item in event list
    // 4. refilter
    
    NSDictionary *tmpCell= [self.filteredEventList objectAtIndex:indexPath.row];
    
    NSLog(@" testing %@", [tmpCell objectForKey:@"id"]                              );

   // for(NSDictionary *vDic in self.eventList){
    
    int iValue=-1;
    for(int i=0; i < [self.eventList count]; i++){
        
        NSDictionary *vDic = self.eventList[i];
        
        if([tmpCell objectForKey:@"id"]  == [vDic objectForKey:@"id"] ){
            
            NSLog(@" Found it %@", [vDic objectForKey:@"title"]);
            iValue= i;
            break;
            
        }
    }
    
    if (iValue!=-1) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.eventList];
        [tmpArray removeObjectAtIndex:(NSInteger)iValue];
        self.eventList = [NSArray arrayWithArray: tmpArray];
        self.filteredEventList=[self filterArrayWithCategories:self.eventList];
        //Now sync back.
        [[NSUserDefaults standardUserDefaults] setObject:self.eventList forKey:@"currentEvents"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
   
   
    
    [self.eventTable reloadData];
}

- (void) notifyMe:(NSString*)ttl withMessage:(NSString*)msg {
    
    [RKDropdownAlert title:[NSString stringWithFormat:NSLocalizedString(ttl, nil)] message:[NSString stringWithFormat:NSLocalizedString(msg, nil)] backgroundColor:[UIColor flatWhiteColor] textColor:[UIColor flatTealColor] time:5];
    
}

- (void) loadPreferences {
    
    //Try to load the prefcat
    NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
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
    
}

- (void) configureButtons {
    
    /* round edges */
    
    UIBezierPath * maskPath;
    CAShapeLayer *maskLayer;
    
    for(int i=1; i<=2;i++){
        
        UIButton *button = (UIButton*) [self.view viewWithTag:i];
        
        button.backgroundColor=[UIColor flatSkyBlueColor];
        
        maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5.0,5.0)];
        
        // Create the shape layer and set its path
        maskLayer = [CAShapeLayer layer];
        maskLayer.frame = button.bounds;
        maskLayer.path = maskPath.CGPath;
        
        // Set the newly created shape layer as the mask for the image view's layer
        button.layer.mask = maskLayer;
        button.clipsToBounds = NO;
        
    }
    
    
    
    
}



@end
