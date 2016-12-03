//
//  lotCell.m
//  ParkerMeister
//
//  Created by Ganesha on 20/2/15.
//  Copyright (c) 2015 tenqyu. All rights reserved.
//

#import "lotCell.h"

@implementation lotCell

@synthesize title,desc, goingCount, maxCount, distance, inXMinutes,price,recurringLabel;
@synthesize lotViewIndicator,category,catLabel;
@synthesize priceInd1,priceInd2,priceInd3,priceInd4 ;
@synthesize priceLabel1,priceLabel2,priceLabel3 ;
@synthesize favInd1,favInd2,favInd3,favInd4;



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        title=[[UILabel alloc]initWithFrame:CGRectZero];
        desc=[[UILabel alloc]initWithFrame:CGRectZero];
        inXMinutes=[[UILabel alloc]initWithFrame:CGRectZero];
        goingCount=[[UILabel alloc]initWithFrame:CGRectZero];
        maxCount=[[UILabel alloc]initWithFrame:CGRectZero];
        distance=[[UILabel alloc]initWithFrame:CGRectZero];
        lotViewIndicator = [[UIImageView alloc] initWithFrame:CGRectZero];
        category= [[UIImageView alloc] initWithFrame:CGRectZero];
        price=[[UILabel alloc]initWithFrame:CGRectZero];
        catLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        
        recurringLabel= [[UIImageView alloc] initWithFrame:CGRectZero];
        
        
        priceLabel1=[[UILabel alloc]initWithFrame:CGRectZero];
        priceLabel2=[[UILabel alloc]initWithFrame:CGRectZero];
        priceLabel3=[[UILabel alloc]initWithFrame:CGRectZero];
        
        priceInd1= [[UIImageView alloc] initWithFrame:CGRectZero];
        priceInd2= [[UIImageView alloc] initWithFrame:CGRectZero];
        priceInd3= [[UIImageView alloc] initWithFrame:CGRectZero];
        priceInd4= [[UIImageView alloc] initWithFrame:CGRectZero];
        
        favInd1= [[UIImageView alloc] initWithFrame:CGRectZero];
        favInd2= [[UIImageView alloc] initWithFrame:CGRectZero];
        favInd3= [[UIImageView alloc] initWithFrame:CGRectZero];
        favInd4= [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:title];
        [self.contentView addSubview:desc];
        [self.contentView addSubview:inXMinutes];
        [self.contentView addSubview:goingCount];
        [self.contentView addSubview:maxCount];
        [self.contentView addSubview:distance];
        [self.contentView addSubview:lotViewIndicator];
        [self.contentView addSubview:category];
        [self.contentView addSubview:price];
        [self.contentView addSubview:catLabel];
        [self.contentView addSubview:recurringLabel];
        [self.contentView addSubview:priceLabel1];
        [self.contentView addSubview:priceLabel2];
        [self.contentView addSubview:priceLabel3];
        
        [self.contentView addSubview:priceInd1];
        [self.contentView addSubview:priceInd2];
        [self.contentView addSubview:priceInd3];
        [self.contentView addSubview:priceInd4];
        
        [self.contentView addSubview:favInd1];
        [self.contentView addSubview:favInd2];
        [self.contentView addSubview:favInd3];
        [self.contentView addSubview:favInd4];
        
        
    }
    
    
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if(!self){
        
        NSLog(@" oh shit");
        
    }
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
/*
- (void) prepareforReuse{

    [super prepareForReuse];
    
    BOOL hasContentView = [self.subviews containsObject:self.contentView];
    if(hasContentView){
        [self.contentView removeFromSuperview];
    }
    
}
*/
@end
