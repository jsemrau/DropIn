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

@synthesize dSlide,tSlide,distanceLabel,timeLabel,saveButton, logo;

- (void) viewWillAppear:(BOOL)animated{
    
    UIImage *sliderLeftTrackImage = [UIImage imageNamed: @"master-slider_01.png"];
    UIImage *sliderRightTrackImage = [UIImage imageNamed: @"master-slider_02.png"] ;
    [sliderLeftTrackImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [sliderRightTrackImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    
    [self.dSlide setMinimumTrackImage: sliderLeftTrackImage forState: UIControlStateNormal];
    [self.dSlide setMaximumTrackImage: sliderRightTrackImage forState: UIControlStateNormal];
    
    [self.tSlide setMinimumTrackImage: sliderLeftTrackImage forState: UIControlStateNormal];
    [self.tSlide setMaximumTrackImage: sliderRightTrackImage forState: UIControlStateNormal];
    
    NSUserDefaults *prefs;
    
    prefs= [NSUserDefaults standardUserDefaults];
    self.prefCats=[[prefs objectForKey:@"pref_Categories"] mutableCopy] ;
    
    //Loop over categories
    
    
    if ([[self.prefCats valueForKey:@"Arts"] isEqualToString:@"0"]) {
        self.artsButton.selected=TRUE;
    } else {
        self.artsButton.selected=FALSE;
    }
    
    if ([[self.prefCats valueForKey:@"Business"] isEqualToString:@"0"]) {
        self.businessButton.selected=TRUE;
    } else {
        self.businessButton.selected=FALSE;
    }
    
    if ([[self.prefCats valueForKey:@"Education"] isEqualToString:@"0"]) {
        self.educationButton.selected=TRUE;
    } else {
        self.educationButton.selected=FALSE;
    }
    
    if ([[self.prefCats valueForKey:@"Entertainment"] isEqualToString:@"0"]) {
        self.entertainmentButton.selected=TRUE;
    } else {
        self.entertainmentButton.selected=FALSE;
    }
    
    if ([[self.prefCats valueForKey:@"Family"] isEqualToString:@"0"]) {
        self.familyButton.selected=TRUE;
    } else {
        self.familyButton.selected=FALSE;
    }
    
    if ([[self.prefCats valueForKey:@"Food"] isEqualToString:@"0"]) {
        self.foodButton.selected=TRUE;
    } else {
        self.foodButton.selected=FALSE;
    }
    
    if ([[self.prefCats valueForKey:@"Social"] isEqualToString:@"0"]) {
        self.socialButton.selected=TRUE;
    } else {
        self.socialButton.selected=FALSE;
    }
    
    if ([[self.prefCats valueForKey:@"Large"] isEqualToString:@"0"]) {
        self.massButton.selected=TRUE;
    } else {
        self.massButton.selected=FALSE;
    }
    
    if ([[self.prefCats valueForKey:@"Meeting"] isEqualToString:@"0"]) {
        self.meetingButton.selected=TRUE;
    } else {
        self.meetingButton.selected=FALSE;
    }
    
    if ([[self.prefCats valueForKey:@"Sports"] isEqualToString:@"0"]) {
        self.sportsButton.selected=TRUE;
    } else {
        self.sportsButton.selected=FALSE;
    }
    
    if ([[self.prefCats valueForKey:@"Tech"] isEqualToString:@"0"]) {
        self.techButton.selected=TRUE;
    } else {
        self.techButton.selected=FALSE;
    }
    
    if ([[self.prefCats valueForKey:@"Other"] isEqualToString:@"0"]) {
        self.otherButton.selected=TRUE;
    } else {
        self.otherButton.selected=FALSE;
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
}

-(IBAction)timeSliderChanged:(id)sender {
    
    UISlider *slider = (UISlider *)sender;

    int newVal = (int)lroundf(slider.value);
    //< 24 ? (int)lroundf(slider.value) : 1;
    
    if (newVal<1) {
        newVal=1;
    }
    timeLabel.text = [NSString stringWithFormat:@"%d", newVal];
}

/*

- (IBAction)timeSliderChanged:(id)sender

{
    
    //  [self playSound:@"button_click.mp3"];
    UISlider *slider = (UISlider *)sender;
    
    // NSInteger val = lroundf(slider.value);
    NSInteger val = lroundf(slider.value);
    NSInteger val1;
    
    if (val<0) {
        val1=1;
    }else{
        val1=val;
    }
    
   // NSLog(@" Slider Value %@", [NSString stringWithFormat:@"%ld", (long)slider.value]);
    
    // NSLog(@"Updating slider val %li from %li", (long)val, (long)val1);
    
   // [self.tSlide setValue:val1 animated:YES];
    self.timeLabel.text=[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%ld", (long)val1]];
    
}
*/
/*- (IBAction)distanceSliderChanged:(id)sender

{
    
    //  [self playSound:@"button_click.mp3"];
    UISlider *slider = (UISlider *)sender;
    
    // NSInteger val = lroundf(slider.value);
    NSInteger val = lroundf(slider.value);
    NSInteger val1;
    
    if (val<0) {
        val1=1;
    }else{
        val1=val;
    }
    
   // NSLog(@" Slider Value %@", [NSString stringWithFormat:@"%ld", (long)slider.value]);
    
    // NSLog(@"Updating slider val %li from %li", (long)val, (long)val1);
    
  //  [self.dSlide setValue:val1 animated:YES];
    self.distanceLabel.text=[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%ld", (long)val1]];
    
}
*/

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
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UINavigationController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FIRST_TOP_VIEW_CONTROLLER"];
    PGFirstViewController *vc= [centerViewController.viewControllers objectAtIndex:0];
    vc.hasUpdates=TRUE;
    
    //  [[self navigationController] presentViewController:centerViewController animated:YES completion:nil];
    
    [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
    
}
-(IBAction)buttonSelected:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    NSLog(@" button %@", btn.currentTitle);
    
    
    if([btn.currentTitle isEqualToString:@"Arts"]){
        
        if (self.artsButton.selected) {
            [self.artsButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey:@"Arts"];
            
        } else {
            [self.artsButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey:@"Arts"];
            
            
        }
        
    } else if ([btn.currentTitle isEqualToString:@"Business"]) {
    
        if (self.businessButton.selected) {
            [self.businessButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey:@"Business"];
        } else {
            [self.businessButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey:@"Business"];
        }
        
    } else if ([btn.currentTitle isEqualToString:@"Education"]) {
    
        if (self.educationButton.selected) {
            [self.educationButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey:@"Education"];
        } else {
            [self.educationButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey:@"Education"];
        }
        
    } else if ([btn.currentTitle isEqualToString:@"Entertainment"]) {
        
        if (self.entertainmentButton.selected) {
            [self.entertainmentButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey:@"Entertainment"];
        } else {
            [self.entertainmentButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey:@"Entertainment"];
        }
    
    } else if ([btn.currentTitle isEqualToString:@"Family"]) {
        
        if (self.familyButton.selected) {
            [self.familyButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey:@"Family"];
        } else {
            [self.familyButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey:@"Family"];
        }
        
    } else if ([btn.currentTitle isEqualToString:@"Food"]) {
        
        if (self.foodButton.selected) {
            [self.foodButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey:@"Food"];
        } else {
            [self.foodButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey:@"Food"];
        }
        
    } else if ([btn.currentTitle isEqualToString:@"Large"]) {
        
        if (self.massButton.selected) {
            [self.massButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey:@"Large"];
        } else {
            [self.massButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey:@"Large"];
        }
        
    } else if ([btn.currentTitle isEqualToString:@"Meeting"]) {
        
        if (self.meetingButton.selected) {
            [self.meetingButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey:@"Meeting"];
        } else {
            [self.meetingButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey:@"Meeting"];
        }
        
    } else if ([btn.currentTitle isEqualToString:@"Other"]) {
        
        if (self.otherButton.selected) {
            [self.otherButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey:@"Other"];
        } else {
            [self.otherButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey:@"Other"];
        }
        
    } else if ([btn.currentTitle isEqualToString:@"Social"]) {
        
        if (self.socialButton.selected) {
            [self.socialButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey:@"Social"];
        } else {
            [self.socialButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey:@"Social"];
        }
        
    } else if ([btn.currentTitle isEqualToString:@"Sports"]) {
        
        if (self.sportsButton.selected) {
            [self.sportsButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey:@"Sports"];
        } else {
            [self.sportsButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey:@"Sports"];
        }
        
    } else if ([btn.currentTitle isEqualToString:@"Tech"])  {
        
        if (self.techButton.selected) {
            [self.techButton setSelected:NO];
            [self.prefCats setValue:@"1" forKey:@"Tech"];
        } else {
            [self.techButton setSelected:YES];
            [self.prefCats setValue:@"0" forKey:@"Tech"];
        }
            
    }   else {
        
    
    }
    
    NSLog(@" Dictionary %@", self.prefCats);
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
