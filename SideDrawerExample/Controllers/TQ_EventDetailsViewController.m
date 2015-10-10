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

@synthesize distance,duration,going_count,max_count,latitude,longitude,price,start_time,stop_time,eTitle,eDescription,eURL,eSource,vAddress,vName,vRecur,vStop_time,vStart_time,vNameStr;

- (void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"********** %@ **************",self.eURL);
    
    if ([self.vNameStr isEqualToString:@""]) {
        self.vName.text=@"Unnamed Venue";
        [self geoLookUp];
    }
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
