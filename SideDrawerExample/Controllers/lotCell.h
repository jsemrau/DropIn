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
    IBOutlet UIImageView *category;
    
    IBOutlet UIImageView *priceInd1;
    IBOutlet UIImageView *priceInd2;
    IBOutlet UIImageView *priceInd3;
    IBOutlet UIImageView *priceInd4;
    
    IBOutlet UIImageView *favInd1;
    IBOutlet UIImageView *favInd2;
    IBOutlet UIImageView *favInd3;
    IBOutlet UIImageView *favInd4;
    
    IBOutlet UILabel *catLabel;
    
    IBOutlet UILabel *priceLabel1;
    IBOutlet UILabel *priceLabel2;
    IBOutlet UILabel *priceLabel3;
    
}


@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *inXMinutes;
@property (nonatomic, retain) IBOutlet UILabel *goingCount;
@property (nonatomic, retain) IBOutlet UILabel *maxCount;
@property (nonatomic, retain) IBOutlet UILabel *distance;
@property (nonatomic, retain) IBOutlet UIImageView *lotViewIndicator;
@property (nonatomic, retain) IBOutlet UIImageView *category;
@property (nonatomic, retain) IBOutlet UILabel *price;
@property (nonatomic, retain) IBOutlet UILabel *catLabel;

@property (nonatomic, retain) IBOutlet UILabel *priceLabel1;
@property (nonatomic, retain) IBOutlet UILabel *priceLabel2;
@property (nonatomic, retain) IBOutlet UILabel *priceLabel3;

@property (nonatomic, retain) IBOutlet UIImageView *priceInd1;
@property (nonatomic, retain) IBOutlet UIImageView *priceInd2;
@property (nonatomic, retain) IBOutlet UIImageView *priceInd3;
@property (nonatomic, retain) IBOutlet UIImageView *priceInd4;

@property (nonatomic, retain) IBOutlet UIImageView *favInd1;
@property (nonatomic, retain) IBOutlet UIImageView *favInd2;
@property (nonatomic, retain) IBOutlet UIImageView *favInd3;
@property (nonatomic, retain) IBOutlet UIImageView *favInd4;

@end
