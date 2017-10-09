//
//  TQ_LocationDenied.h
//  dropin
//
//  Created by tenqyu on 9/10/17.
//  Copyright © 2017 tenqyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQ_LocationDenied : UIViewController

{
    
    IBOutlet UIButton *settings;
    
}

- (IBAction) gotoSettings;
- (IBAction) moveToLogin:(id)sender ;

@property (nonatomic, retain) IBOutlet UIButton *settings;

@end
