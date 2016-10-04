
//
//  MapPin.h
//  MapPin
//
//  Created by JSEMRAU 
//  Copyright 2011 Tenqyu Japan All rights reserved.
//

#import "MapPin.h"


@implementation MapPin

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize pinAnnotationView;
@synthesize distance, category;
@synthesize coolImage;
@synthesize latitude,longitude, idStr;


- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName subTitle:(NSString*)sTitle description:description {
    self = [super init];
    
    if (self != nil) {
        
        coordinate = location;
        title = placeName;
        subtitle = sTitle;
        
    }
    
    return self;
}







@end
