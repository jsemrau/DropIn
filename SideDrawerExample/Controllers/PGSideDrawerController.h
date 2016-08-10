//
//  PGSideDrawerController.h
// SideDrawerExample
//
//  Created by Pulkit Goyal on 18/09/14.
//  Copyright (c) 2014 Pulkit Goyal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>
#import "FontAwesomeKit/FontAwesomeKit.h"
#import "FontAwesomeKit/FAKZocial.h"
#import "FontAwesomeKit/FontAwesomeKit/FAKIonIcons.h"

@interface PGSideDrawerController : UITableViewController

{
    
    IBOutlet UIImageView *upcomingImage;
    
    IBOutlet UIImageView *settingImage;
    IBOutlet UIImageView *mapImage;
    IBOutlet UIImageView *tnCImage;
    
    IBOutlet UIImageView *aboutImage;
    IBOutlet UIImageView *privacyImage;
    
    IBOutlet UITableView *sideTable;
}

@property(nonatomic, retain) IBOutlet UIImageView *upcomingImage;
@property(nonatomic, retain) IBOutlet UIImageView *settingImage;
@property(nonatomic, retain) IBOutlet UIImageView *mapImage;
@property(nonatomic, retain) IBOutlet UIImageView *aboutImage;
@property(nonatomic, retain) IBOutlet UIImageView *privacyImage;
@property(nonatomic, retain) IBOutlet UIImageView *tnCImage;
@property(nonatomic, retain) IBOutlet UITableView *sideTable;


@end
