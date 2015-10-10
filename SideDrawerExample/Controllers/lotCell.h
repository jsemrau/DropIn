//
//  lotCell.h
//  ParkerMeister
//
//  Created by Ganesha on 20/2/15.
//  Copyright (c) 2015 tenqyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lotCell : UITableViewCell

{
    
    IBOutlet UILabel *title;
    IBOutlet UILabel *inXMinutes;
    IBOutlet UILabel *goingCount;
    IBOutlet UILabel *maxCount;
    IBOutlet UILabel *distance;
    IBOutlet UIImageView *lotViewIndicator;
    IBOutlet UILabel *price;
    
    
    
}


@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *inXMinutes;
@property (nonatomic, retain) IBOutlet UILabel *goingCount;
@property (nonatomic, retain) IBOutlet UILabel *maxCount;
@property (nonatomic, retain) IBOutlet UILabel *distance;
@property (nonatomic, retain) IBOutlet UIImageView *lotViewIndicator;
@property (nonatomic, retain) IBOutlet UILabel *price;

@end
