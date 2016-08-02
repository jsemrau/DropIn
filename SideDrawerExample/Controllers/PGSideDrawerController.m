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

@synthesize settingImage,aboutImage,privacyImage;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentIndex = 0;
    
    FAKFontAwesome *likeIcon = [FAKFontAwesome spaceShuttleIconWithSize:37.5];
    [likeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor] ];
    settingImage = [likeIcon imageWithSize:CGSizeMake(44, 43.5)];
    
    
    likeIcon = [FAKFontAwesome heartOIconWithSize:37.5];
    [likeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor]];
    aboutImage = [likeIcon imageWithSize:CGSizeMake(44, 43.5)];
    
    
    likeIcon = [FAKFontAwesome heartOIconWithSize:37.5];
    [likeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor] ];
    privacyImage = [likeIcon imageWithSize:CGSizeMake(44, 43.5)];
    
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
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FOURTH_TOP_VIEW_CONTROLLER"];
            break;
        case 3:
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PRIVACY_POLICY"];
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
