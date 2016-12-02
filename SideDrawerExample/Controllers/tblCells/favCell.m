//
//  favCell.m
//  dropin
//
//  Created by tenqyu on 24/10/16.
//  Copyright © 2016 tenqyu. All rights reserved.
//

#import "favCell.h"

@implementation favCell

@synthesize title,desc, maxCount, distance, inXMinutes,price,recurringLabel;
@synthesize lotViewIndicator,category,catLabel;
@synthesize priceInd1;
@synthesize priceLabel1,tStamped;
@synthesize favInd1;

- (void)awakeFromNib {
    [super awakeFromNib];
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

-(id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
