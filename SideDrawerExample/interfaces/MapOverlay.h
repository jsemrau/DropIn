//
//  MapOverlay
//  Shadow
//
//  Created by Ganesha on 5/23/13.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MapPin.h"

@interface MapOverlay : MKAnnotationView {
    
    
    MapPin *questLoc;
    
}

@property (nonatomic, retain) MapPin *questLoc;

@end
