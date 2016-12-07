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
#import "TQ_EventDetailsViewController.h"


@interface TQ_MapVC ()

@end

@implementation TQ_MapVC

@synthesize setLocation,currentLocation,eventList,myMapView,selectDialog,explainer,distance;

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
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    self.distance = [[[[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"distance"]] objectForKey:@"distance"] floatValue]*1000;
    
    
    
}

- (void) configureMapData{
    
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[self.eventList count]];
    NSMutableArray *placeArray = [NSMutableArray array];
    
    int index =0;
    
    for (NSDictionary* campaignData in self.eventList) {
        
        [data addObject:campaignData];
        
        self.eventList = [[NSArray alloc] initWithArray:data];
        
        NSString *place = [[campaignData objectForKey:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *lat = [campaignData objectForKey:@"latitude"];
        NSString *lng  =[campaignData objectForKey:@"longitude"];
        
        //  NSDictionary *locStr = [campaignData objectForKey:@"Location"];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[lat floatValue] longitude:(CLLocationDegrees)[lng floatValue]];
        
        MapPin *marker = [[MapPin alloc] initWithCoordinates:location.coordinate placeName:place subTitle:[campaignData objectForKey:@"description"] description:[campaignData objectForKey:@"description"]];
        
        marker.coordinate=location.coordinate;
        marker.idStr=[NSString stringWithFormat:@"%d",index];
        marker.category=[campaignData objectForKey:@"category"];
        
        [placeArray addObject:marker];
        index++;
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
    
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    
    MapOverlay *qItem = (MapOverlay *)[lmapView dequeueReusableAnnotationViewWithIdentifier: @"qView"];
    MapPin *tPin;
    
    if([annotation isMemberOfClass:[MapPin class]]) {
        
       tPin  = (MapPin*)annotation;
        
        NSLog(@" **** %@", [tPin category]);
    }
        
    
    
    if (qItem == nil)
    {
        qItem = (MapOverlay*)[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"qView"];
        qItem.canShowCallout = YES;
        
        UIImage *iconImage = [self getCategoryImage:[tPin category]] ;
        qItem.contentMode=UIViewContentModeScaleAspectFit;
        
        UIImage *newImage = [self imageWithImage:iconImage scaledToSize:CGSizeMake(20, 20)];
        [qItem setImage:newImage];
        
        qItem.backgroundColor = [self getCategoryColor:[tPin category]];
        
        qItem.layer.cornerRadius = qItem.frame.size.height/2;
        qItem.clipsToBounds = NO;
    
        
        qItem.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        //qItem.rightButton.imageView.image=pinImage;
    }
    qItem.annotation = annotation;
    
    return qItem;
         
   
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control

{ if ([view.annotation isKindOfClass:[MapPin class]])
{
    MapPin *myAnn = (MapPin *)view.annotation;
    NSLog(@"callout button tapped for station id %@", myAnn.title);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    TQ_EventDetailsViewController *eventDetails = [storyboard instantiateViewControllerWithIdentifier:@"EVENT_DETAILS"];
    
    NSLog(@"%@",myAnn.idStr );
    
    
    NSMutableDictionary *text=[self.eventList objectAtIndex:[myAnn.idStr intValue] ];
    
    eventDetails.handOver=text;
    
    [self.navigationController pushViewController:eventDetails animated:YES];
    
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
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, self.distance, self.distance);
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
    
    int index=0;
    
    for (NSDictionary* campaignData in resultData) {
        
        NSLog(@"Outputting cData %@", campaignData);
        [data addObject:campaignData];
        
        self.eventList = [[NSArray alloc] initWithArray:data];
        
        NSString *place = [[campaignData objectForKey:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *lat = [campaignData objectForKey:@"lat"];
        NSString *lng  =[campaignData objectForKey:@"lng"];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[lat floatValue] longitude:(CLLocationDegrees)[lng floatValue]];
        
        MapPin *marker = [[MapPin alloc] initWithCoordinates:location.coordinate placeName:place subTitle:[campaignData objectForKey:@"description"] description:[campaignData objectForKey:@"venue_address"]];
        
        //marker.subTitle=;
        marker.coordinate=location.coordinate;
        marker.idStr=[NSString stringWithFormat:@"%d",index];
        marker.category=[campaignData objectForKey:@"category"];
        
        NSLog(@" marker %@", marker.idStr);
        
        [placeArray addObject:marker];
        index++;
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

-(UIImage*) getCategoryImage:(NSString *)category{

    NSLog(@" *** Cat *** %@", category);
    
    UIImage *iconImage;
   // UIImageView *tmpView;
    
    if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[0]", nil)]]) {
        iconImage = [UIImage imageNamed:@"arts.png"];
    }

    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[1]", nil)]]) {
        iconImage = [UIImage imageNamed:@"business.png"];
    }

    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[2]", nil)]]) {
        iconImage = [UIImage imageNamed:@"education.png"];
    }

    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[3]", nil)]]) {
        iconImage = [UIImage imageNamed:@"entertainment.png"];
    }

    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[4]", nil)]]) {
        iconImage = [UIImage imageNamed:@"family.png"];
    }

    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[5]", nil)]]) {
        iconImage = [UIImage imageNamed:@"food.png"];
    }

    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[6]", nil)]]) {
        iconImage = [UIImage imageNamed:@"social.png"];
    }

    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[7]", nil)]]) {
        iconImage = [UIImage imageNamed:@"mass.png"];
    }

    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[8]", nil)]]) {
        iconImage = [UIImage imageNamed:@"meeting.png"];
    }


    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[9]", nil)]]) {
        iconImage = [UIImage imageNamed:@"sports.png"];
    }

    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[10]", nil)]]) {
        iconImage = [UIImage imageNamed:@"tech.png"];
    }

    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[11]", nil)]]) {
        
        iconImage = [UIImage imageNamed:@"other.png"];
        
    } else {
        
        iconImage = [UIImage imageNamed:@"other.png"];
        
        
    }

    return iconImage;
    
}

-(UIColor*) getCategoryColor:(NSString *)category{
    
    NSLog(@" *** Cat *** %@", category);
    
    UIColor *returnColor;
    // UIImageView *tmpView;
    
    if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[0]", nil)]]) {
        returnColor=[UIColor flatRedColor];
    }
    
    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[1]", nil)]]) {
        returnColor=[UIColor flatPowderBlueColor];
    }
    
    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[2]", nil)]]) {
        returnColor=[UIColor flatMintColorDark];
    }
    
    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[3]", nil)]]) {
        returnColor=[UIColor flatMintColor];
    }
    
    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[4]", nil)]]) {
        returnColor=[UIColor flatPinkColor];
    }
    
    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[5]", nil)]]) {
        returnColor=[UIColor flatSandColorDark];
    }
    
    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[6]", nil)]]) {
        returnColor=[UIColor flatPurpleColor];
    }
    
    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[7]", nil)]]) {
        
        returnColor=[UIColor flatBlueColor];
    }
    
    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[8]", nil)]]) {
        returnColor=[UIColor flatWatermelonColorDark];
    }
    
    
    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[9]", nil)]]) {
        returnColor=[UIColor flatBrownColor];
    }
    
    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[10]", nil)]]) {
       
        returnColor=[UIColor flatSkyBlueColorDark];
    }
    
    else if ([category isEqualToString: [NSString stringWithFormat:NSLocalizedString(@"category[11]", nil)]]) {
        
        returnColor=[UIColor flatWhiteColorDark];
        
    } else {
        
        returnColor=[UIColor flatWhiteColorDark];
        
        
    }
    
    return returnColor;
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
