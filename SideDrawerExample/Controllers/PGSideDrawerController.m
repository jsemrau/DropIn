//
//  PGSideDrawerController.m
// SideDrawerExample
//
//  Created by Tenqyu on 18/09/14.
//  Copyright (c) 2014 Tenqyu. All rights reserved.
//

#import "PGSideDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface PGSideDrawerController ()

@property(nonatomic) int currentIndex;
@end

@implementation PGSideDrawerController

@synthesize settingImage,aboutImage,privacyImage,mapImage,tnCImage,upcomingImage;
@synthesize sideTable;


- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentIndex = 0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sky"]];
    self.tableView.backgroundView = imageView;
    self.tableView.contentMode=UIViewContentModeScaleToFill;
    
    float tSize = 30;
    
    
    FAKIonIcons *upCIcon = [FAKIonIcons waterdropIconWithSize:tSize];
    [upCIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor] ];
    UIImage *iconImage = [upCIcon imageWithSize:CGSizeMake(44, 44)];
    self.upcomingImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.upcomingImage setImage:iconImage];
    
    
    FAKIonIcons *mailIcon = [FAKIonIcons iosSettingsIconWithSize:tSize];
    [mailIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor] ];
    iconImage = [mailIcon imageWithSize:CGSizeMake(44, 44)];
    self.settingImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.settingImage setImage:iconImage];
    
  
    FAKIonIcons *mapIcon = [FAKIonIcons iosNavigateOutlineIconWithSize:tSize];
    [mapIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor] ];
    iconImage = [mapIcon imageWithSize:CGSizeMake(44, 44)];
    self.mapImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.mapImage setImage:iconImage];
    
    FAKIonIcons *aboutIcon = [FAKIonIcons iosInfiniteOutlineIconWithSize:tSize];
    [aboutIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor] ];
    iconImage = [aboutIcon imageWithSize:CGSizeMake(44, 44)];
    self.aboutImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.aboutImage setImage:iconImage];
    
    FAKIonIcons *privacyIcon = [FAKIonIcons clipboardIconWithSize:tSize];
    [privacyIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor] ];
    iconImage = [privacyIcon imageWithSize:CGSizeMake(44, 44)];
    self.privacyImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.privacyImage setImage:iconImage];
    
    /*
    likeIcon = [FAKFontAwesome laptopIconWithSize:tSize];
    [likeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor] ];
    iconImage = [likeIcon imageWithSize:CGSizeMake(44, 44)];
    self.tnCImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.tnCImage setImage:iconImage];
    */
    
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  /*  if (self.currentIndex == indexPath.row) {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        return;
    }
*/
    UIViewController *centerViewController;
    switch (indexPath.row) {
        case 0:
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FIRST_TOP_VIEW_CONTROLLER"];
            break;
        case 1:
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"THIRD_TOP_VIEW_CONTROLLER"];
            break;
        case 2:
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SECOND_TOP_VIEW_CONTROLLER"];
            break;
        case 3:
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FOURTH_TOP_VIEW_CONTROLLER"];
            break;
        case 4:
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PRIVACY_POLICY"];
            break;
            
        default:
            break;
    }

    if (centerViewController) {
        self.currentIndex = (int)indexPath.row;
        [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
    } else {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }
}

@end
