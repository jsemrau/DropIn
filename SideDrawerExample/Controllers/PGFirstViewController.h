//
//  PGFirstViewController.h
// SideDrawerExample
//
//  Created by Tenqyu on 18/09/14.
//  Copyright (c) 2014 Tenqyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QyuWebAccess.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GFLocationManager.h"
#import "lotCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import <Spring/spring-Swift.h>
#import <ChameleonFramework/Chameleon.h>
#import "RKDropdownAlert.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIViewController+MMDrawerController.h"
#import <QuartzCore/QuartzCore.h>

@import GoogleMobileAds;


@interface PGFirstViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,QyuWebDelegate,GFLocationManagerDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

{
    
    
    IBOutlet UITableView* eventTable;
    IBOutlet UITableViewCell *eventTableCellItem;
    
    bool gettingUpdates;
    bool needsUpdates;
    bool weatherNeedsUpdates;
    
    CLLocation *currentLocation;
//    IBOutlet SpringView *loader ;
    IBOutlet UILabel *weatherString ;
    IBOutlet UIView *messager ;
    IBOutlet UILabel *messagerLabel;
    IBOutlet UIView *cityHeader;
    
    IBOutlet UIBarButtonItem *bar1;
    IBOutlet UIBarButtonItem *bar2;
    IBOutlet UIBarButtonItem *bar3;
    
  //  UIImageView * loading ;
    
    CGRect *loadingLocation;
    
    NSMutableDictionary *notiDictionary;
    NSMutableDictionary *likedIDs;
 
    
    IBOutlet UIRefreshControl *refreshControl;
    IBOutlet UIView *blurry;
    
}

@property (retain, nonatomic) CLLocation *currentLocation;
//@property (retain, nonatomic) CGRect *loadingLocation;

@property (nonatomic, retain) IBOutlet UIButton* refreshButton;

@property (nonatomic, retain) IBOutlet UITableView* eventTable;
@property (nonatomic, retain) IBOutlet UITableViewCell *eventTableCellItem;
@property (nonatomic, retain) IBOutlet UILabel *weatherString ;

@property(nonatomic, assign) bool loadedWithLocation;
@property(nonatomic,assign) bool hasUpdates;
@property(nonatomic,assign) bool hasCategories;

@property(nonatomic, retain) NSArray *eventList;
@property(nonatomic, retain) NSArray *filteredEventList;

@property(nonatomic, retain) IBOutlet UIView * messager ;
@property(nonatomic, retain) IBOutlet UIView * cityHeader ;
@property(nonatomic,retain) IBOutlet UIView *blurry;


@property(nonatomic, retain) IBOutlet UILabel *messagerLabel;
@property(nonatomic, retain) IBOutlet UIImageView * whiter ;
@property(nonatomic, retain) IBOutlet UIImageView * footerImageView ;


@property (nonatomic, retain) IBOutlet UIButton* gotoSettings;
@property (nonatomic, retain) IBOutlet UIButton* gotoRefresh;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *bar1;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *bar2;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *bar3;


@property(nonatomic )bool needsUpdates;
@property(nonatomic )bool weatherNeedsUpdates;

@property(nonatomic, retain) NSMutableDictionary *notiDictionary;
@property (nonatomic, retain) NSMutableDictionary *likedIDs;
@property (nonatomic, retain) NSMutableDictionary *prefCats; //there are 12 categories
@property(nonatomic, retain) NSMutableDictionary *userDetails;

@property (nonatomic, retain) IBOutlet UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet GADBannerView  *bannerView;


- (void) playSound:(NSString*) path;
- (void) loadPreferences;

- (IBAction)refreshButtonPress:(id)sender;
- (IBAction)settingsButtonPress:(id)sender;

-(IBAction) sortByDate :(id)sender ;
-(IBAction) sortByDistance :(id)sender;
-(IBAction) sortByCategory :(id)sender;

@end
