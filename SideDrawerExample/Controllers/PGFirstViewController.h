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


@interface PGFirstViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,QyuWebDelegate,GFLocationManagerDelegate>

{
    
    
    IBOutlet UITableView* eventTable;
    IBOutlet UITableViewCell *eventTableCellItem;
    
    bool gettingUpdates;
    bool needsUpdates;
    bool weatherNeedsUpdates;
    
    CLLocation *currentLocation;
    IBOutlet UIView *loader ;
    IBOutlet UILabel *weatherString ;
    IBOutlet UIView *messager ;
    IBOutlet UILabel *messagerLabel;
    IBOutlet UIView *cityHeader;
    
    UIImageView * loading ;
    
    NSMutableDictionary *notiDictionary;
    NSMutableDictionary *likedIDs;
 
    
    IBOutlet UIRefreshControl *refreshControl;
}

@property (retain, nonatomic) CLLocation *currentLocation;

@property (nonatomic, retain) IBOutlet UIButton* refreshButton;

@property (nonatomic, retain) IBOutlet UITableView* eventTable;
@property (nonatomic, retain) IBOutlet UITableViewCell *eventTableCellItem;
@property (nonatomic, retain) IBOutlet UILabel *weatherString ;
@property(nonatomic, assign) bool loadedWithLocation;
@property(nonatomic, retain) NSArray *eventList;

@property(nonatomic, retain) IBOutlet UIView * loader ;
@property(nonatomic, retain) IBOutlet UIView * messager ;
@property(nonatomic, retain) IBOutlet UIView * cityHeader ;
@property(nonatomic, retain) IBOutlet UILabel *messagerLabel;
@property(nonatomic, retain) IBOutlet UIImageView * loading ;
@property(nonatomic, retain) IBOutlet UIImageView * whiter ;
@property(nonatomic )bool needsUpdates;
@property(nonatomic )bool weatherNeedsUpdates;

@property(nonatomic, retain) NSMutableDictionary *notiDictionary;
@property (nonatomic, retain) NSMutableDictionary *likedIDs;
@property (nonatomic, retain) IBOutlet UIRefreshControl *refreshControl;


- (void) playSound:(NSString*) path;
- (IBAction)refreshButtonPress:(id)sender;

-(IBAction) sortByDate :(id)sender ;
-(IBAction) sortByDistance :(id)sender;
-(IBAction) sortByCategory :(id)sender;

@end
