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

@synthesize dSlide,tSlide,distanceLabel,timeLabel,saveButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLeftMenuButton];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    int dVal=[[[[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"distance"]] objectForKey:@"distance"]intValue];
    
    int tVal = [[[[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"timeFrame"]] objectForKey:@"time"] intValue];
    
    //present existing values
    self.distanceLabel.text = [NSString stringWithFormat:@"%d",dVal];
    self.timeLabel.text = [NSString stringWithFormat:@"%d", tVal];
    
    
    CGRect minuteSliderFrame = CGRectMake(5, 170, 310, 310);
    dSlide = [[EFCircularSlider alloc] initWithFrame:minuteSliderFrame];
    dSlide.unfilledColor = [UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1.0f];
    dSlide.filledColor = [UIColor colorWithRed:44/255.0f green:174/255.0f blue:228/255.0f alpha:1.0f];
    [dSlide setInnerMarkingLabels:@[@" 5", @"10", @"15", @"20", @"25", @"30"]];
    
    dSlide.labelFont = [UIFont systemFontOfSize:23.0f];
    dSlide.lineWidth = 16;
    dSlide.minimumValue = 1;
    dSlide.maximumValue = 30;
    dSlide.labelColor = [UIColor colorWithRed:137/255.0f green:137/255.0f blue:137/255.0f alpha:1.0f];
    dSlide.handleType = EFSemiTransparentWhiteCircle;
    dSlide.handleType=1;
    dSlide.handleColor =[UIColor whiteColor];
    //dSlide.filledColor;
    [self.view addSubview:dSlide];
    [dSlide addTarget:self action:@selector(distanceSliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    CGRect hourSliderFrame = CGRectMake(55, 220, 210, 210);
    tSlide = [[EFCircularSlider alloc] initWithFrame:hourSliderFrame];
    tSlide.unfilledColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f];
    tSlide.filledColor = [UIColor colorWithRed:51/255.0f green:182/255.0f blue:232/255.0f alpha:1.0f];
    
    [tSlide setInnerMarkingLabels:@[@" 6", @" 12", @"18",@"24"]];
  
    tSlide.labelFont = [UIFont systemFontOfSize:23.0f];
    tSlide.lineWidth = 16;
    tSlide.snapToLabels = NO;
    tSlide.minimumValue = 1;
    tSlide.maximumValue = 24;
    tSlide.labelColor = [UIColor colorWithRed:137/255.0f green:137/255.0f blue:137/255.0f alpha:1.0f];
    tSlide.handleType = EFSemiTransparentWhiteCircle;
    tSlide.handleColor = [UIColor whiteColor];
    //tSlide.filledColor;
    [self.view addSubview:tSlide];
    [tSlide addTarget:self action:@selector(timeSliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.dSlide.currentValue=dVal;
    self.tSlide.currentValue=tVal;
    
    [self.view bringSubviewToFront:saveButton];
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


-(void)distanceSliderChanged:(EFCircularSlider*)slider {
    
    int newVal = (int)slider.currentValue < 30? (int)slider.currentValue : 1;
    
    distanceLabel.text = [NSString stringWithFormat:@"%d", newVal];
}

-(void)timeSliderChanged:(EFCircularSlider*)slider {
    
    int newVal = (int)slider.currentValue < 24 ? (int)slider.currentValue : 1;
    
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
    [distanceDic setObject:[NSString stringWithFormat:@"%f", self.dSlide.currentValue] forKey:@"distance"];
    [[NSUserDefaults standardUserDefaults] setObject:distanceDic forKey:@"distance"] ;
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *timeDic =[[NSMutableDictionary alloc] init];
    [timeDic setObject:[NSString stringWithFormat:@"%f", self.tSlide.currentValue] forKey:@"time"];
    [[NSUserDefaults standardUserDefaults] setObject:timeDic forKey:@"timeFrame"] ;
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    NSMutableDictionary *savedDic =[[NSMutableDictionary alloc] init];
    [savedDic setObject:[NSString stringWithFormat:@"%@", [NSDate date]] forKey:@"lastSaved"];
    [[NSUserDefaults standardUserDefaults] setObject:savedDic forKey:@"lastSaved"] ;
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //present existing values
    self.distanceLabel.text = [NSString stringWithFormat:@"%d", (int)self.dSlide.currentValue];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Tenqyu.com"
                                                      message:@"Saved"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    /*UIViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FIRST_TOP_VIEW_CONTROLLER"];
    [self.mm_drawerController setCenterViewController:myController withCloseAnimation:YES completion:nil];
    */
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
