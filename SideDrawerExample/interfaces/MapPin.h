
//
//  MapPin.h
//  MapPin
//
//  Created by JSEMRAU 
//  Copyright 2011 Tenqyu Japan All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapPin : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D coordinate;
    NSString *eTitle;
    NSString *eDesc;
    NSString *category;
    NSString *idStr;
    NSString *distance;
    UIImage  *coolImage;
    
    float latitude;
    float longitude;
   // MKPinAnnotationView *pinAnnotationView;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *idStr;
@property (nonatomic, retain) UIImage *coolImage;

@property (readwrite, nonatomic) float latitude;
@property (readwrite, nonatomic) float longitude;

@property (nonatomic, retain) MKPinAnnotationView *pinAnnotationView;;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description;

@end

/*

pin = [[MapPin alloc] initWithCoordinates:[track startCoordinates] placeName:@"Start" description:@""];
[map addAnnotation:pin];


*/