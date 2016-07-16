//
//  TQ_SettingsVC.m
//  dropin
//
//  Created by tenqyu on 11/10/15.
//  Copyright © 2015 tenqyu. All rights reserved.
//

#import "TQ_SettingsVC.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"


@interface TQ_SettingsVC ()

@end

@implementation TQ_SettingsVC

@synthesize dSlide,tSlide,distanceLabel,timeLabel,saveButton, logo,relevantUpdates,distanceString,timeString,deSelectString,quoteString;

- (void) viewWillAppear:(BOOL)animated{
    
    self.relevantUpdates=false;
    
    UIImage *sliderLeftTrackImage = [UIImage imageNamed: @"master-slider_01.png"];
    UIImage *sliderRightTrackImage = [UIImage imageNamed: @"master-slider_02.png"] ;
    [sliderLeftTrackImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [sliderRightTrackImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    
    [self.dSlide setMinimumTrackImage: sliderLeftTrackImage forState: UIControlStateNormal];
    [self.dSlide setMaximumTrackImage: sliderRightTrackImage forState: UIControlStateNormal];
    
    [self.tSlide setMinimumTrackImage: sliderLeftTrackImage forState: UIControlStateNormal];
    [self.tSlide setMaximumTrackImage: sliderRightTrackImage forState: UIControlStateNormal];

    //setup the reader strings
    self.distanceString.text=[NSString stringWithFormat:NSLocalizedString(@"dist", nil)];
    self.timeString.text=[NSString stringWithFormat:NSLocalizedString(@"time", nil)];
    self.deSelectString.text=[NSString stringWithFormat:NSLocalizedString(@"de-select", nil)];
    self.quoteString.text=[NSString stringWithFormat:NSLocalizedString(@"quote", nil)];
    
    NSUserDefaults *prefs;
    
    prefs= [NSUserDefaults standardUserDefaults];
    self.prefCats=[[prefs objectForKey:@"pref_Categories"] mutableCopy] ;

    
    
    
    //Loop over categories
   
    if ([[self.prefCats valueForKey:[NSString stringWithFormat:NSLocalizedString(@"category[0]", nil)]] isEqualToString:@"0"]) {
        self.artsButton.selected=TRUE;
        self.artsButton.backgroundColor=[UIColor flatWhiteColor];
        
    } else {
        self.artsButton.selected=FALSE;
        self.artsButton.backgroundColor=[UIColor flatRedColor];
        }
    
    if ([[self.prefCats valueForKey:[NSString stringWithFormat:NSLocalizedString(@"category[1]", nil)]] isEqualToString:@"0"]) {
        self.businessButton.selected=TRUE;
        self.businessButton.backgroundColor=[UIColor flatWhiteColor];
        
    } else {
        self.businessButton.selected=FALSE;
        self.businessButton.backgroundColor=[UIColor flatPowderBlueColor];
        
    }
    
    if ([[self.prefCats valueForKey:[NSString stringWithFormat:NSLocalizedString(@"category[2]", nil)]] isEqualToString:@"0"]) {
        self.educationButton.selected=TRUE;
        self.educationButton.backgroundColor=[UIColor flatWhiteColor];
        
    } else {
        self.educationButton.selected=FALSE;
        self.educationButton.backgroundColor=[UIColor flatMintColorDark];
        
    }
    
    if ([[self.prefCats valueForKey:[NSString stringWithFormat:NSLocalizedString(@"category[3]", nil)]] isEqualToString:@"0"]) {
        self.entertainmentButton.selected=TRUE;
        self.entertainmentButton.backgroundColor=[UIColor flatWhiteColor];
        
    } else {
        self.entertainmentButton.selected=FALSE;
        self.entertainmentButton.backgroundColor=[UIColor flatMintColor];
    }
    
    if ([[self.prefCats valueForKey:[NSString stringWithFormat:NSLocalizedString(@"category[4]", nil)]] isEqualToString:@"0"]) {
        self.familyButton.selected=TRUE;
        self.familyButton.backgroundColor=[UIColor flatWhiteColor];
        
        
    } else {
        self.familyButton.selected=FALSE;
        self.familyButton.backgroundColor=[UIColor flatPinkColor];
    }
    
    if ([[self.prefCats valueForKey:[NSString stringWithFormat:NSLocalizedString(@"category[5]", nil)]] isEqualToString:@"0"]) {
        self.foodButton.selected=TRUE;
        self.foodButton.backgroundColor=[UIColor flatWhiteColor];
        
    } else {
        self.foodButton.selected=FALSE;
        self.foodButton.backgroundColor=[UIColor flatSandColorDark];
    }
    
    if ([[self.prefCats valueForKey:[NSString stringWithFormat:NSLocalizedString(@"category[6]", nil)]] isEqualToString:@"0"]) {
        self.socialButton.selected=TRUE;
        self.socialButton.backgroundColor=[UIColor flatWhiteColor];
       
    } else {
        self.socialButton.selected=FALSE;
        self.socialButton.backgroundColor=[UIColor flatPurpleColor];
        
    }
    
    if ([[self.prefCats valueForKey:[NSString stringWithFormat:NSLocalizedString(@"category[7]", nil)]] isEqualToString:@"0"]) {
        self.massButton.selected=TRUE;
        self.massButton.backgroundColor=[UIColor flatWhiteColor];
       
    } else {
        self.massButton.selected=FALSE;
        self.massButton.backgroundColor=[UIColor flatBlueColor];
    }
    
    if ([[self.prefCats valueForKey:[NSString stringWithFormat:NSLocalizedString(@"category[8]", nil)]] isEqualToString:@"0"]) {
        self.meetingButton.selected=TRUE;
        self.meetingButton.backgroundColor=[UIColor flatWhiteColor];
       
    } else {
        self.meetingButton.selected=FALSE;
        self.meetingButton.backgroundColor=[UIColor flatWatermelonColorDark];
    }
    
    if ([[self.prefCats valueForKey:[NSString stringWithFormat:NSLocalizedString(@"category[9]", nil)]] isEqualToString:@"0"]) {
        self.sportsButton.selected=TRUE;
         self.sportsButton.backgroundColor=[UIColor flatWhiteColor];
     
        
    } else {
        self.sportsButton.selected=FALSE;
        self.sportsButton.backgroundColor=[UIColor flatBrownColor];
    }
    
    if ([[self.prefCats valueForKey:[NSString stringWithFormat:NSLocalizedString(@"category[10]", nil)]] isEqualToString:@"0"]) {
        self.techButton.selected=TRUE;
         self.techButton.backgroundColor=[UIColor flatWhiteColor];
        
    } else {
        self.techButton.selected=FALSE;
        self.techButton.backgroundColor=[UIColor flatSkyBlueColorDark];
       
    }
    
    if ([[self.prefCats valueForKey:[NSString stringWithFormat:NSLocalizedString(@"category[11]", nil)]] isEqualToString:@"0"]) {
        self.otherButton.selected=TRUE;
        self.otherButton.backgroundColor=[UIColor flatWhiteColor];
        
    } else {
        self.otherButton.selected=FALSE;
        self.otherButton.backgroundColor=[UIColor flatWhiteColorDark];
        
    }
    
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLeftMenuButton];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    int dVal=[[[[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"distance"]] objectForKey:@"distance"]intValue];
    
    int tVal = [[[[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"timeFrame"]] objectForKey:@"time"] intValue];
    
    if (dVal==0 || tVal==0) {
        
        dVal=10;
        tVal=12;
    }
    //present existing values
    self.distanceLabel.text = [NSString stringWithFormat:@"%d",dVal];
    self.timeLabel.text = [NSString stringWithFormat:@"%d", tVal];
    
    self.dSlide.value=dVal;
    self.tSlide.value=tVal;
    
  
    if(!self.navigationItem.titleView){
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.text = @"Settings";
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0];
    lblTitle.shadowColor = [UIColor whiteColor];
    lblTitle.shadowOffset = CGSizeMake(0, 1);
    lblTitle.font = [UIFont fontWithName:@"AvenirNext-Regular" size:17.0];
    [lblTitle sizeToFit];
    
    self.navigationItem.titleView = lblTitle;
    
    }
    
   
    /* Loop over all buttons */
     
    [self configureButtons];
    
    //save
    FAKFontAwesome *clockIcon = [FAKFontAwesome saveIconWithSize:25];
    [clockIcon addAttribute:NSForegroundColorAttributeName value:[UIColor flatSkyBlueColor] ];
    UIImage *iconImage = [clockIcon imageWithSize:CGSizeMake(35, 35)];
    //[UIImage imageNamed:@"sortByDistance32x32.png"]
    UIImage *image = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.bar1 = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(distanceSettingUpdate:)];
    

    NSMutableArray * arr = [NSMutableArray arrayWithObjects: self.bar1, nil];
    
    [self.navigationItem setRightBarButtonItems:arr];
    

    
    
    [self.view sendSubviewToBack:self.logo];
    
}

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)distanceSliderChanged:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    
    int newVal = (int)lroundf(slider.value);
    // < 50? (int)lroundf(slider.value): 1;
    
    distanceLabel.text = [NSString stringWithFormat:@"%d", newVal];
    
    self.relevantUpdates=true;
}

-(IBAction)timeSliderChanged:(id)sender {
    
    UISlider *slider = (UISlider *)sender;

    int newVal = (int)lroundf(slider.value);
    //< 24 ? (int)lroundf(slider.value) : 1;
    
    if (newVal<1) {
        newVal=1;
    }
    timeLabel.text = [NSString stringWithFormat:@"%d", newVal];
    self.relevantUpdates=true;
}


- (IBAction)distanceSettingUpdate:(id)sender{
    
    NSMutableDictionary *distanceDic =[[NSMutableDictionary alloc] init];
    [distanceDic setObject:[NSString stringWithFormat:@"%f", self.dSlide.value] forKey:@"distance"];
    [[NSUserDefaults standardUserDefaults] setObject:distanceDic forKey:@"distance"] ;
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *timeDic =[[NSMutableDictionary alloc] init];
    [timeDic setObject:[NSString stringWithFormat:@"%f", self.tSlide.value] forKey:@"time"];
    [[NSUserDefaults standardUserDefaults] setObject:timeDic forKey:@"timeFrame"] ;
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    NSMutableDictionary *savedDic =[[NSMutableDictionary alloc] init];
    [savedDic setObject:[NSString stringWithFormat:@"%@", [NSDate date]] forKey:@"lastSaved"];
    [[NSUserDefaults standardUserDefaults] setObject:savedDic forKey:@"lastSaved"] ;
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.prefCats forKey:@"pref_Categories"] ;
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //present existing values
    self.distanceLabel.text = [NSString stringWithFormat:@"%d", (int)self.dSlide.value];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Tenqyu.com"
                                                      message:@"Saved"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    
    /*
     
    [RKDropdownAlert title:[NSString stringWithFormat:NSLocalizedString(@"game", nil)] message:[NSString stringWithFormat:NSLocalizedString(@"Saved", nil)] backgroundColor:[UIColor flatWhiteColor] textColor:[UIColor flatTealColor] time:10];
    */
    
}

-(BOOL)dropdownAlertWasTapped:(RKDropdownAlert*)alert {
    // Handle the tap, then return whether or not the alert should hide.
    
    UINavigationController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FIRST_TOP_VIEW_CONTROLLER"];
    
    if(self.relevantUpdates){
        PGFirstViewController *vc= [centerViewController.viewControllers objectAtIndex:0];
        vc.needsUpdates=TRUE;
    }
    
    [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
    
    return true;
}

- (BOOL)dropdownAlertWasDismissed{ return YES; }

-(BOOL)dropdownAlertWasDismissed:(RKDropdownAlert*)alert{
    
    return true;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UINavigationController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FIRST_TOP_VIEW_CONTROLLER"];
    
    if(self.relevantUpdates){
        PGFirstViewController *vc= [centerViewController.viewControllers objectAtIndex:0];
        vc.hasUpdates=FALSE;
        vc.needsUpdates=TRUE;
    }
    
    //  [[self navigationController] presentViewController:centerViewController animated:YES completion:nil];
    
    [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
    
}
-(IBAction)buttonSelected:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    if([btn.currentTitle isEqualToString:[NSString stringWithFormat:NSLocalizedString(@"category[0]", nil)]]){
        
        if (self.artsButton.selected) {
            [self.artsButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey:[NSString stringWithFormat:NSLocalizedString(@"category[0]", nil)]];
            self.artsButton.backgroundColor=[UIColor flatRedColor];
            
        } else {
            [self.artsButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey:[NSString stringWithFormat:NSLocalizedString(@"category[0]", nil)]];
            
            self.artsButton.backgroundColor=[UIColor flatWhiteColor];
        }
        
    } else if ([btn.currentTitle isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[1]", nil)]]) {
    
        if (self.businessButton.selected) {
            [self.businessButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[1]", nil)]];
            self.businessButton.backgroundColor=[UIColor flatPowderBlueColor ];
        } else {
            [self.businessButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[1]", nil)]];
            self.businessButton.backgroundColor=[UIColor flatWhiteColor ];
        }
        
    } else if ([btn.currentTitle isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[2]", nil)]]) {
    
        if (self.educationButton.selected) {
            [self.educationButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[2]", nil)]];
            self.educationButton.backgroundColor=[UIColor flatMintColorDark];
        } else {
            [self.educationButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[2]", nil)]];
            self.educationButton.backgroundColor=[UIColor flatWhiteColor];
        }
        
    } else if ([btn.currentTitle isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[3]", nil)]]) {
        
        if (self.entertainmentButton.selected) {
            [self.entertainmentButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[3]", nil)]];
            self.entertainmentButton.backgroundColor=[UIColor flatMintColor];
        } else {
            [self.entertainmentButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[3]", nil)]];
            self.entertainmentButton.backgroundColor=[UIColor flatWhiteColor];
        }
    
    } else if ([btn.currentTitle isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[4]", nil)]]) {
        
        if (self.familyButton.selected) {
            [self.familyButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[4]", nil)]];
            self.familyButton.backgroundColor=[UIColor flatPinkColor];
        } else {
            [self.familyButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[4]", nil)]];
            self.familyButton.backgroundColor=[UIColor flatWhiteColor];
        }
        
    } else if ([btn.currentTitle isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[5]", nil)]]) {
        
        if (self.foodButton.selected) {
            [self.foodButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[5]", nil)]];
            self.foodButton.backgroundColor=[UIColor flatSandColorDark];
        } else {
            [self.foodButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[5]", nil)]];
            self.foodButton.backgroundColor=[UIColor flatWhiteColor];
        }
    } else if ([btn.currentTitle isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[6]", nil)]]) {
        
        if (self.socialButton.selected) {
            [self.socialButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[6]", nil)]];
            self.socialButton.backgroundColor=[UIColor flatPurpleColor];
            
        } else {
            [self.socialButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[6]", nil)]];
            self.socialButton.backgroundColor=[UIColor  flatWhiteColor];
        }
    
    } else if ([btn.currentTitle isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[7]", nil)]]) {
        
        if (self.massButton.selected) {
            [self.massButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[7]", nil)]];
            self.massButton.backgroundColor=[UIColor flatBlueColor];
        } else {
            [self.massButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[7]", nil)]];
            self.massButton.backgroundColor=[UIColor flatWhiteColor];
        }
        
    } else if ([btn.currentTitle isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[8]", nil)]]) {
        
        if (self.meetingButton.selected) {
            [self.meetingButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[8]", nil)]];
            self.meetingButton.backgroundColor=[UIColor flatWatermelonColorDark];
        } else {
            [self.meetingButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[8]", nil)]];
            self.meetingButton.backgroundColor=[UIColor flatWhiteColor];
        }
        
    } else if ([btn.currentTitle isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[9]", nil)]]) {
        
        if (self.sportsButton.selected) {
            [self.sportsButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[9]", nil)]];
            self.sportsButton.backgroundColor=[UIColor flatBrownColor];
        } else {
            [self.sportsButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[9]", nil)]];
            self.sportsButton.backgroundColor=[UIColor flatWhiteColor];
        }
    
    } else if ([btn.currentTitle isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[10]", nil)]])  {
        
        if (self.techButton.selected) {
            [self.techButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[10]", nil)]];
            self.techButton.backgroundColor=[UIColor flatSkyBlueColorDark];
        } else {
            [self.techButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[10]", nil)]];
            self.techButton.backgroundColor=[UIColor flatWhiteColor];
        }

    } else if ([btn.currentTitle isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[11]", nil)]]) {
        
        if (self.otherButton.selected) {
            [self.otherButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[11]", nil)]];
            self.otherButton.backgroundColor=[UIColor flatWhiteColorDark];
        } else {
            [self.otherButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey: [NSString stringWithFormat:NSLocalizedString(@"category[11]", nil)]];
            self.otherButton.backgroundColor=[UIColor flatWhiteColor];
        }
        
        
    }   else {
        
    
    }
    
    self.relevantUpdates=false;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) configureButtons {
    
    /* round edges */
   
    UIBezierPath * maskPath;
    CAShapeLayer *maskLayer;
    
    for(int i=1; i<=12;i++){
        
        UIButton *button = (UIButton*) [self.view viewWithTag:i];
      
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
