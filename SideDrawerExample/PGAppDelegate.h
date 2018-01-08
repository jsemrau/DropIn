//
//  PGAppDelegate.h
// SideDrawerExample
//
//  Created by Pulkit Goyal on 11/12/13.
//  Copyright (c) 2013 Pulkit Goyal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFLocationManager.h"
#import <ChameleonFramework/Chameleon.h>
#import <UserNotifications/UserNotifications.h>
#import "QyuWebAccess.h"

//#import "Socialize.h"

@interface PGAppDelegate : UIResponder <UIApplicationDelegate,GFLocationManagerDelegate,QyuWebDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,assign) bool sendsData;
@end
