//
//  favCell.h
//  dropin
//
//  Created by tenqyu on 24/10/16.
//  Copyright © 2016 tenqyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontAwesomeKit/FontAwesomeKit.h"
#import "FontAwesomeKit/FAKZocial.h"
#import "FontAwesomeKit/FontAwesomeKit/FAKIonIcons.h"


@interface favCell : UITableViewCell

{
    IBOutlet UILabel *title;
    IBOutlet UILabel *desc;
    IBOutlet UILabel *tStamped ;
    IBOutlet UILabel *goingCount;
    IBOutlet UILabel *maxCount;
    IBOutlet UILabel *distance;
    IBOutlet UIImageView *lotViewIndicator;
    IBOutlet UILabel *price;
    
    IBOutlet UIImageView *category;
    
    IBOutlet UIImageView *priceInd1;
    
    IBOutlet UIImageView *favInd1;
   
    IBOutlet UILabel *catLabel;
    
    
    IBOutlet UIImageView *recurringLabel;
    
}


@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *desc;
@property (nonatomic, retain) IBOutlet UILabel *inXMinutes;
@property (nonatomic, retain) IBOutlet UILabel *tStamped;
@property (nonatomic, retain) IBOutlet UILabel *maxCount;
@property (nonatomic, retain) IBOutlet UILabel *distance;
@property (nonatomic, retain) IBOutlet UIImageView *lotViewIndicator;
@property (nonatomic, retain) IBOutlet UIImageView *category;
@property (nonatomic, retain) IBOutlet UILabel *price;
@property (nonatomic, retain) IBOutlet UILabel *catLabel;

@property (nonatomic, retain) IBOutlet UIImageView *recurringLabel;


@property (nonatomic, retain) IBOutlet UILabel *priceLabel1;

@property (nonatomic, retain) IBOutlet UIImageView *priceInd1;

@property (nonatomic, retain) IBOutlet UIImageView *favInd1;


@end
