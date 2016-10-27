//
//  TQ_Favorites.h
//  dropin
//
//  Created by tenqyu on 24/10/16.
//  Copyright © 2016 tenqyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "favCell.h"
#import "TQ_EventDetailsViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface TQ_Favorites : UIViewController <UITableViewDelegate, UITableViewDataSource>

{
    
    NSMutableDictionary *likedIDs;
    NSMutableDictionary *favEventsAll;
    
    NSArray *likedArray;
    
    IBOutlet UITableView* likesTable;
    
}

@property (nonatomic, retain) NSMutableDictionary *likedIDs;
@property (nonatomic, retain) NSMutableDictionary *favEventsAll;
@property (nonatomic, retain) IBOutlet UITableView* likesTable;
@property (nonatomic, retain) IBOutlet NSArray* likedArray;


@end
