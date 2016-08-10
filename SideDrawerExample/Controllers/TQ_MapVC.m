//
//  TQ_MapVC.m
//  dropin
//
//  Created by tenqyu on 11/10/15.
//  Copyright © 2015 tenqyu. All rights reserved.
//

#import "TQ_MapVC.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"


@interface TQ_MapVC ()

@end

@implementation TQ_MapVC

@synthesize setLocation,currentLocation,eventList,myMapView,selectDialog,explainer;

- (void) viewWillAppear:(BOOL)animated{
    
    [[GFLocationManager sharedInstance] addLocationManagerDelegate:self];
    
    [myMapView setDelegate:self];
    
    [self.myMapView setMapType:MKMapTypeStandard];
    [self.myMapView setZoomEnabled:YES];
    [self.myMapView setScrollEnabled:YES];
    self.myMapView.showsUserLocation=TRUE;
    
    [self.myMapView .layer setMasksToBounds:YES];
    self.myMapView.layer.shadowOpacity = 0.5f;

    self.explainer.alpha=0.65;
    self.selectDialog.alpha=0.0;
    
    
    
}

- (void) configureMapData{
    
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[self.eventList count]];
    NSMutableArray *placeArray = [NSMutableArray array];
    
    for (NSDictionary* campaignData in self.eventList) {
        
        [data addObject:campaignData];
        
        self.eventList = [[NSArray alloc] initWithArray:data];
        
        NSString *place = [[campaignData objectForKey:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *lat = [campaignData objectForKey:@"latitude"];
        NSString *lng  =[campaignData objectForKey:@"longitude"];
        
        //  NSDictionary *locStr = [campaignData objectForKey:@"Location"];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[lat floatValue] longitude:(CLLocationDegrees)[lng floatValue]];
        
        MapPin *marker = [[MapPin alloc] initWithCoordinates:location.coordinate placeName:place description:@""];
        marker.coordinate=location.coordinate;
        marker.status=@"parked";
        
        [placeArray addObject:marker];
    }
    
    [self.myMapView addAnnotations:placeArray];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLeftMenuButton];
    
   
    
}

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //Here
  //  [self.myMapView selectAnnotation:[[self.myMapView annotations] firstObject] animated:YES];
    
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
    
        UIImage *iconImage = [UIImage imageNamed:@"drop-new@32.png"];
        
         qItem.contentMode=UIViewContentModeScaleAspectFit;
        [qItem setImage:iconImage];
        
        //rightButton.imageView.image=pinImage;
    }
    qItem.annotation = annotation;
    
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


- (void) locationManagerDidUpdateLocation:(CLLocation *)location {
    
    self.currentLocation = location;
    
    NSLog(@"Long %f and Lat %f",location.coordinate.longitude,location.coordinate.latitude);
    
    /* if an object is given, then use this one */
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    self.eventList= [prefs objectForKey:@"currentEvents"];
    [self configureMapData];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 5000.0, 5000.0);
    MKCoordinateRegion adjustedRegion = [self.myMapView regionThatFits:region];
    adjustedRegion.center = location.coordinate;
    [self.myMapView setRegion:adjustedRegion animated:YES];
    
    
    // [self.myMapView setNeedsLayout];
    
    [self.myMapView setNeedsDisplay];
}

- (IBAction)removeClueView:(id)sender  {
    
    [self.explainer removeFromSuperview];
}

#pragma mark web service functions

- (void) noLocationsReceived{
    
    gettingUpdates=FALSE;
    
    NSLog(@" No event received");
    
}

- (void)locationsReceived:(NSDictionary *)resultData
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([resultData count] ==0){
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Tenqyu.com"
                                                          message:@"No Parking data available in your vincinity!"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
        return;
        
    }
    
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[resultData count]];
    NSMutableArray *placeArray = [NSMutableArray array];
    
    self.eventList=nil;
    self.eventList = [NSMutableArray array];
    
    NSLog(@"********************************");
    
    for (NSDictionary* campaignData in resultData) {
        
        NSLog(@"Outputting cData %@", campaignData);
        [data addObject:campaignData];
        
        self.eventList = [[NSArray alloc] initWithArray:data];
        
        NSString *place = [[campaignData objectForKey:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *lat = [campaignData objectForKey:@"lat"];
        NSString *lng  =[campaignData objectForKey:@"lng"];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[lat floatValue] longitude:(CLLocationDegrees)[lng floatValue]];
        
        MapPin *marker = [[MapPin alloc] initWithCoordinates:location.coordinate placeName:place description:[campaignData objectForKey:@"venue_address"]];
        marker.coordinate=location.coordinate;
        marker.status=@"parked";
        
        [placeArray addObject:marker];
    }
    
    [self.myMapView addAnnotations:placeArray];
    
    
    /*if ([activityIndicator isAnimating]) {
     [activityIndicator stopAnimating];
     }*/
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self.myMapView setNeedsLayout];
}

- (void)notificationsReceived:(NSDictionary *)resultData{
    
    gettingUpdates=FALSE;
    
    NSLog(@" -> %@",resultData);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
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
