
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
@synthesize subTitle;
@synthesize pinAnnotationView;
@synthesize distance, category;
@synthesize coolImage;
@synthesize latitude,longitude, idStr;


- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description {
    self = [super init];
    
    if (self != nil) {
        
        coordinate = location;
        title = placeName;
        subTitle = description;
        
    }
    
    return self;
}







@end
