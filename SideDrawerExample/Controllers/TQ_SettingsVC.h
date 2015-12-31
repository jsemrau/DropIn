//
//  TQ_SettingsVC.h
//  dropin
//
//  Created by tenqyu on 11/10/15.
//  Copyright © 2015 tenqyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGFirstViewController.h"


@interface TQ_SettingsVC : UIViewController <UIAlertViewDelegate>

{
    
    IBOutlet UISlider *dSlide;
    IBOutlet UISlider *tSlide;
    
    
}
@property (nonatomic, retain) IBOutlet UISlider *dSlide;
@property (nonatomic, retain) IBOutlet UISlider *tSlide;

@property (nonatomic, retain) IBOutlet UIButton *saveButton;

@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *distanceString;
@property (nonatomic, retain) IBOutlet UILabel *timeString;
@property (nonatomic, retain) IBOutlet UILabel *deSelectString;
@property (nonatomic, retain) IBOutlet UILabel *quoteString;

@property (nonatomic, retain) IBOutlet UIImageView *logo;

@property (nonatomic, retain) IBOutlet UIButton *artsButton;
@property (nonatomic, retain) IBOutlet UIButton *businessButton;
@property (nonatomic, retain) IBOutlet UIButton *educationButton;
@property (nonatomic, retain) IBOutlet UIButton *entertainmentButton;
@property (nonatomic, retain) IBOutlet UIButton *familyButton;
@property (nonatomic, retain) IBOutlet UIButton *foodButton;
@property (nonatomic, retain) IBOutlet UIButton *massButton;
@property (nonatomic, retain) IBOutlet UIButton *meetingButton;
@property (nonatomic, retain) IBOutlet UIButton *otherButton;
@property (nonatomic, retain) IBOutlet UIButton *socialButton;
@property (nonatomic, retain) IBOutlet UIButton *sportsButton;
@property (nonatomic, retain) IBOutlet UIButton *techButton;

@property (assign) bool relevantUpdates;

@property (nonatomic, retain) NSMutableDictionary *prefCats; //there are 12 categories

//- (IBAction)distanceSettingUpdate:(id)sender;
-(IBAction)distanceSliderChanged:(id)sender;
-(IBAction)timeSliderChanged:(id)sender ;
-(IBAction)buttonSelected:(id)sender ;

@end
