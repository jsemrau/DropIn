//
//  TQ_EventDetailsViewController.m
//  SideDrawerExample
//
//  Created by tenqyu on 30/9/15.
//  Copyright © 2015 Pulkit Goyal. All rights reserved.
//

#import "TQ_EventDetailsViewController.h"

@interface TQ_EventDetailsViewController ()

@end

@implementation TQ_EventDetailsViewController

@synthesize distance,duration,going_count,max_count,latitude,longitude,price,start_time,stop_time,eTitle,eDescription,eURL,eSource,vAddress,vName,vRecur,vStop_time,vStart_time,vNameStr, timeDiff,fScore,openLocation, debugView,mapView,shareView, myMapView;

- (void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"********** %@ **************",self.eURL);
    
    if ([self.vNameStr isEqualToString:@""]) {
        self.vName.text=@"Unnamed Venue";
        [self geoLookUp];
    }
    
    self.mapView.alpha=0;
    self.debugView.alpha=0;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) geoLookUp {
    
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *location= [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude] ;
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    [geoCoder reverseGeocodeLocation: location completionHandler: ^(NSArray *placemarks, NSError *error) {
        //do something
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        // NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
        
   
        
        self.vAddress.text=[placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressStreetKey];
        
    }];
    
    
    
}

- (IBAction)openURL:(id)sender{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.eURL]];
    
}

- (IBAction)openLocationView:(id)sender{
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.eURL]];
    
  
    
    if (self.mapView.alpha==1) {
        self.mapView.alpha=0;
    } else {
        
        [self.myMapView setDelegate:self];
        [self.myMapView setMapType:MKMapTypeStandard];
        [self.myMapView setZoomEnabled:YES];
        [self.myMapView setScrollEnabled:YES];
        self.myMapView.showsUserLocation=TRUE;
        [self.myMapView .layer setMasksToBounds:YES];
        self.myMapView.layer.shadowOpacity = 0.5f;
   
        
      //  [self.myMapView setRegion:region animated:NO];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)self.latitude  longitude:(CLLocationDegrees)self.longitude ];
        
        MapPin *marker = [[MapPin alloc] initWithCoordinates:location.coordinate placeName:@"" description:@""];
        marker.coordinate=location.coordinate;
        marker.status=@"event here";
        
        [self.myMapView addAnnotation:marker];
       
        MKMapPoint annotationPoint = MKMapPointForCoordinate(location.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.15f, 0.15f);
        [myMapView setVisibleMapRect:pointRect animated:YES];
        self.mapView.alpha=1;
        
        MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
        region.center.latitude = location.coordinate.latitude;
        region.center.longitude = location.coordinate.longitude;
        
        region.span.longitudeDelta = 0.005f;
        region.span.latitudeDelta = 0.005f;
        
        [self.myMapView setRegion:region animated:NO];
      /*
        
        CLLocationCoordinate2D co1 = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        CLLocationCoordinate2D co2 = CLLocationCoordinate2DMake(myMapView.userLocation.coordinate.latitude, myMapView.userLocation.coordinate.longitude);
        
        MKMapPoint p1 = MKMapPointForCoordinate(co1);
        MKMapPoint p2 = MKMapPointForCoordinate(co2);
        
        MKMapRect mapRect = MKMapRectMake(fmin(p1.x,p2.x), fmin(p1.y,p2.y), fabs(p1.x-p2.x), fabs(p1.y-p2.y));
        
        [myMapView setVisibleMapRect:mapRect animated:YES];
      */
        //Now set the region to fit both points
        /*
        MKMapPoint userPoint = MKMapPointForCoordinate(myMapView.userLocation.coordinate);
        MKMapRect zoomRect = MKMapRectMake(userPoint.x, userPoint.y, 0.1, 0.1);
        
        for (id <MKAnnotation> annotation in myMapView.annotations)
        {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
        [myMapView setVisibleMapRect:zoomRect animated:YES];*/
        
        
        
    }
    
}

- (IBAction)toggleDebugView:(id)sender{
    
    if (self.debugView.alpha==1) {
        self.debugView.alpha=0;
    } else {
        self.debugView.alpha=1;
    }
    
}

#pragma mark - MapView

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //Here
    [self.myMapView selectAnnotation:[[self.myMapView annotations] lastObject] animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)lmapView viewForAnnotation:(id < MKAnnotation >)annotation{
    
    if ([[annotation title] isEqualToString:@"Current Location"]) {
        return nil;
    }
    
    MapOverlay *qItem = (MapOverlay *)[lmapView dequeueReusableAnnotationViewWithIdentifier: @"qView"];
    
    if (qItem == nil)
    {
        qItem = (MapOverlay*)[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"qView"];
        qItem.canShowCallout = YES;
        
        //  UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //  qItem.rightCalloutAccessoryView = rightButton;
        
        //  NSLog(@"%@",qItem.questLoc.description);
        
        UIImage *pinImage = [UIImage imageNamed:@"pk_tbl_icon_marker_blue.png"];
        [qItem setImage:pinImage];
        
        //rightButton.imageView.image=pinImage;
    }
    qItem.annotation = annotation;
    
    NSLog(@" Status %@",qItem.annotation );
    
    return qItem;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control

{ if ([view.annotation isKindOfClass:[MapPin class]])
{
    MapPin *myAnn = (MapPin *)view.annotation;
    NSLog(@"callout button tapped for station id %@", myAnn.title);
}
else
{
    NSLog(@"callout button tapped for annotation %@", view.annotation);
}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
