//
//  MapQuestItem.m
//  Shadow
//
//  Created by Ganesha on 5/23/13.
//
//

#import "MapOverlay.h"

@implementation MapOverlay

@synthesize questLoc;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (id)initWithAnnotation:(id <MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithAnnotation:annotation
                        reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation {
    super.annotation = annotation;
    
    if([annotation isMemberOfClass:[MapPin class]]) {
        questLoc = (MapPin *)annotation;
          } else {
        self.frame = CGRectMake(0,0,0,0);
    }
    
}

@end
