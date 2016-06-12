//
//  lotCell.m
//  ParkerMeister
//
//  Created by Ganesha on 20/2/15.
//  Copyright (c) 2015 tenqyu. All rights reserved.
//

#import "lotCell.h"

@implementation lotCell

@synthesize title,desc, goingCount, maxCount, distance, inXMinutes,price;
@synthesize lotViewIndicator,category,catLabel;
@synthesize priceInd1,priceInd2,priceInd3,priceInd4 ;
@synthesize priceLabel1,priceLabel2,priceLabel3 ;
@synthesize favInd1,favInd2,favInd3,favInd4;



- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.lotViewIndicator.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10.0, 10.0)];
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.lotViewIndicator.bounds;
    maskLayer.path = maskPath.CGPath;
    // Set the newly created shape layer as the mask for the image view's layer
    self.lotViewIndicator.layer.mask = maskLayer;
    self.lotViewIndicator.clipsToBounds = NO;
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
