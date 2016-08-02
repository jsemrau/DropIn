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

@interface PGSideDrawerController : UITableViewController

{
    
    IBOutlet UIImage *settingImage;
    IBOutlet UIImage *aboutImage;
    IBOutlet UIImage *privacyImage;
    
}

@property(nonatomic, retain) IBOutlet UIImage *settingImage;
@property(nonatomic, retain) IBOutlet UIImage *aboutImage;
@property(nonatomic, retain) IBOutlet UIImage *privacyImage;

@end
