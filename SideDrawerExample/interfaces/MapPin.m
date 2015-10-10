
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
@synthesize status;
@synthesize coolImage;
@synthesize latitude;
@synthesize longitude;
@synthesize mapIconURL;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description {
    self = [super init];
    if (self != nil) {
        coordinate = location;
        title = placeName;
        subtitle = description;
        
    }
    return self;
}







@end
