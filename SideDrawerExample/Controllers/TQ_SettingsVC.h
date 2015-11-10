//
//  TQ_SettingsVC.h
//  dropin
//
//  Created by tenqyu on 11/10/15.
//  Copyright © 2015 tenqyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFCircularSlider.h"

@interface TQ_SettingsVC : UIViewController <UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet EFCircularSlider *dSlide;
@property (nonatomic, retain) IBOutlet EFCircularSlider *tSlide;

@property (nonatomic, retain) IBOutlet UIButton *saveButton;

@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;

- (IBAction)distanceSettingUpdate:(id)sender;


@end
