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
    
    self.dSlide.value=dVal;
    self.tSlide.value=tVal;
    self.distanceLabel.text = [NSString stringWithFormat:@"%d", dVal];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%d",tVal ];
    
    
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
    
    [self.tSlide setValue:val1 animated:YES];
    self.timeLabel.text=[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%ld", (long)val1]];
    
}

- (IBAction)distanceSliderChanged:(id)sender

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
    
    [self.dSlide setValue:val1 animated:YES];
    self.distanceLabel.text=[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%ld", (long)val1]];
    
}


- (IBAction)distanceSettingUpdate:(id)sender{
    
    NSMutableDictionary *distanceDic =[[NSMutableDictionary alloc] init];
    [distanceDic setObject:[NSString stringWithFormat:@"%f", self.dSlide.value] forKey:@"distance"];
    self.distanceLabel.text=[NSString stringWithFormat:@"%d", (int)self.dSlide.value ];
    [[NSUserDefaults standardUserDefaults] setObject:distanceDic forKey:@"distance"] ;
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *timeDic =[[NSMutableDictionary alloc] init];
    [timeDic setObject:[NSString stringWithFormat:@"%f", self.tSlide.value] forKey:@"time"];
    self.timeLabel.text=[NSString stringWithFormat:@"%d", (int)self.tSlide.value ];
    [[NSUserDefaults standardUserDefaults] setObject:timeDic forKey:@"timeFrame"] ;
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Tenqyu.com"
                                                      message:@"Saved"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    
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
