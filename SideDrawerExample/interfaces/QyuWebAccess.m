//
//  QyuWebAccess.m
//  Qyu
//
//  Created by ファースト ラスト on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QyuWebAccess.h"
#import "PGAppDelegate.h"

@implementation QyuWebAccess

@synthesize receivedData;
@synthesize conn;
@synthesize objName;
@synthesize finishedLoading;
@synthesize connectionType;
@synthesize jsondata;
@synthesize delegate;
@synthesize webImg;
@synthesize imgMongoId;
@synthesize coreDataKey;
//@synthesize locationManager;
@synthesize iPath,distance,timeFrame,timeZone;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.distance = [[[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"distance"]] objectForKey:@"distance"];
    
    self.timeFrame = [[[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"timeFrame"]] objectForKey:@"time"];
    
    if(!self.distance){
        
        self.distance=@"5";
        
    }
    
  
    
    objName=@"Webby";
    finishedLoading=FALSE;
    connectionType = @"submitScan";
    
    self.timeZone = [[NSTimeZone localTimeZone] name];
    
    return self;
}

- (id)initWithConnectionType:(NSString *) cType
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    if(![self.connectionType isEqual: @"imageContent"])  {
    
  /*  locationManager = [[CLLocationManager alloc] init];
    //locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];*/
    
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.distance = [[[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"distance"]] objectForKey:@"distance"];
    
    if(!self.distance){
        
        self.distance=@"5";
        
    }
    
    self.timeFrame = [[[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"timeFrame"]] objectForKey:@"time"];
    
    if(!self.timeFrame) {
        
        self.timeFrame=@"8";
    }
    
    self.timeZone = [[NSTimeZone localTimeZone] name];
    
    objName=@"Webby";
    finishedLoading=FALSE;
    connectionType =cType;
    
    return self;
}

-(id) submitQRScan:(NSString *)qrcode email:(NSString *)email pwd:(NSString *)pwd  mongoId:(NSString *)mongoId withLat:(double)lat andLong:(double)lon{
    
    
    NSLog(@" Entering submitQRScan");
    
    if (![CLLocationManager locationServicesEnabled]){
        
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"game", nil)]
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"err-loc", nil)]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        */
        
       // [RKDropdownAlert title:[NSString stringWithFormat:NSLocalizedString(@"game", nil)] message:[NSString stringWithFormat:NSLocalizedString(@"err-loc", nil)] backgroundColor:[UIColor flatWhiteColor] textColor:[UIColor flatTealColor] time:5];
        
         [self notifyMe:@"game" withMessage:@"err-loc"];
        
        return false;
    }
    
    if (!qrcode){
        return false;
        
    }
    
    if (!email){
        return false;
        
    }
    
    if (!pwd){
        return false;
        
    }
    
    if (!mongoId){
        return false;
        
    }
    
    
    NSString *escapedQRCode = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( NULL, (CFStringRef)qrcode, NULL, (CFStringRef)@"!’\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8));

    
    NSString *base = @"https://choose.tenqyu.com/index.php";
    
    NSString *mailStr = [@"&email=" stringByAppendingString:email ];
    NSString *pwdStr = [@"&pwd=" stringByAppendingString:pwd];
    
    NSString *idstr = [@"id=" stringByAppendingString:@"validateCode"];
    NSString *qrcodeStr = [@"&qrcode=" stringByAppendingString:escapedQRCode];
    
    NSString *tzStr = [@"&tz=" stringByAppendingString:self.timeZone];
    
    NSString *mongoStr = [@"&playerId=" stringByAppendingString:mongoId];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *langPref = [@"&langPref=" stringByAppendingString:language];
    
    NSString *latStr = [@"&lat=" stringByAppendingString:[NSString stringWithFormat:@"%f", lat]];
    NSString *longStr = [@"&long=" stringByAppendingString:[NSString stringWithFormat:@"%f", lon]];
    
    NSString *gameId = @"&gameId=5";
    
    
    NSString *requestVars = [idstr stringByAppendingFormat:@"%@%@%@%@%@%@%@%@%@",  latStr, longStr,mailStr,pwdStr,mongoStr,langPref, tzStr, qrcodeStr,gameId];
    
    //NSLog(@"URL %@", requestVars);
    
    NSData *requestData = [NSData dataWithBytes: [requestVars UTF8String] length: [requestVars length]];
    
    // Create the request.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:base]
                                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    [theRequest setHTTPMethod: @"POST"];
    [theRequest setHTTPBody: requestData];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest
                                                                    delegate:self];
    
    if (theConnection)
        
    {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        
        self.receivedData = [NSMutableData data];
        
        
    } else {
        
        // Inform the user that the connection failed.
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"game", nil)]
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"err-lost", nil)]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];*/
        
     //   [RKDropdownAlert title:[NSString stringWithFormat:NSLocalizedString(@"game", nil)] message:[NSString stringWithFormat:NSLocalizedString(@"err-lost", nil)] backgroundColor:[UIColor flatWhiteColor] textColor:[UIColor flatTealColor] time:5];
        
        [self notifyMe:@"game" withMessage:@"err-lost"];
        
    }

    
    return self;
    
} //End submitQRScan Function


-(id) submitLocationScan:(double)lat andLong:(double)lon email:(NSString *)email pwd:(NSString *)pwd  mongoId:(NSString *)mongoId{


    // Configure the new event with information from the location


NSString *base = @"https://choose.tenqyu.com/index.php";
NSString *idstr = [@"id=" stringByAppendingString:@"getEventList"];
    
    
NSString *distanceStr = [@"&distance=" stringByAppendingString:self.distance];
    
    
NSString *latitude = [NSString stringWithFormat:@"%f", lat];
NSString *longitude = [NSString stringWithFormat:@"%f", lon];

NSString *latStr = [@"&lat=" stringByAppendingString:latitude];
NSString *longStr = [@"&lng=" stringByAppendingString:longitude ];
    
NSString *mailStr = [@"&email=" stringByAppendingString:email ];
NSString *pwdStr = [@"&pwd=" stringByAppendingString:pwd];
NSString *mongoStr = [@"&playerId=" stringByAppendingString:mongoId];
    
NSString *eventHrsStr = [@"&nextHours=" stringByAppendingString:self.timeFrame];
NSString *tzStr = [@"&tz=" stringByAppendingString:self.timeZone];
 
    
NSString *requestVars = [idstr stringByAppendingFormat:@"%@%@%@%@%@%@%@%@", latStr,longStr,distanceStr,eventHrsStr,mailStr,pwdStr,mongoStr,tzStr];

NSLog(@"URL %@", tzStr);
    
NSData *requestData = [NSData dataWithBytes: [requestVars UTF8String] length: [requestVars length]];

    // Create the request. 
NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:base]
                                          cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
// create the connection with the request 
// and start loading the data 
[theRequest setHTTPMethod: @"POST"];
[theRequest setHTTPBody: requestData];

NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest
                                                               delegate:self];

if (theConnection) 

{
    // Create the NSMutableData to hold the received data.
    // receivedData is an instance variable declared elsewhere. 
    
    self.receivedData = [NSMutableData data];
    
        
} else { 
    
    // Inform the user that the connection failed.
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"game", nil)]
                                                    message:[NSString stringWithFormat:NSLocalizedString(@"err-lost", nil)]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];*/
    
   // [RKDropdownAlert title:[NSString stringWithFormat:NSLocalizedString(@"game", nil)] message:[NSString stringWithFormat:NSLocalizedString(@"err-lost", nil)] backgroundColor:[UIColor flatWhiteColor] textColor:[UIColor flatTealColor] time:5];
    
    [self notifyMe:@"game" withMessage:@"err-lost"];
    
}

    return self;
    
} //End submitQRScan Function


-(id) saveImpression:(NSString *)impression onAsset:(NSString*)onAsset email:(NSString *)email pwd:(NSString *)pwd  mongoId:(NSString *)mongoId withLat:(double)lat andLong:(double)lon{
    
    
    NSLog(@" Entering save Impression");
    
    
    if (!impression){
        return false;
        
    }
    
    if (!email){
        return false;
        
    }
    
    if (!pwd){
        return false;
        
    }
    
    if (!mongoId){
        return false;
        
    }
    
    
    
    NSString *base = @"https://choose.tenqyu.com/v1/activity/index.php";
    
    NSString *mailStr = [@"&email=" stringByAppendingString:email ];
    NSString *pwdStr = [@"&pwd=" stringByAppendingString:pwd];
    
    NSString *idstr = [@"id=" stringByAppendingString:@"saveImpression"];
    NSString *impressionStr = [@"&impression=" stringByAppendingString:impression];
    NSString *onAssetStr = [@"&onAsset=" stringByAppendingString:onAsset];
    
    
    NSString *mongoStr = [@"&playerId=" stringByAppendingString:mongoId];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *langPref = [@"&langPref=" stringByAppendingString:language];
    
    NSString *latStr = [@"&lat=" stringByAppendingString:[NSString stringWithFormat:@"%f", lat]];
    NSString *longStr = [@"&lng=" stringByAppendingString:[NSString stringWithFormat:@"%f", lon]];
    
    NSString *gameId = @"&gameId=5";
    
    NSString *requestVars = [idstr stringByAppendingFormat:@"%@%@%@%@%@%@%@%@%@",  latStr, longStr,mailStr,pwdStr,mongoStr,langPref, impressionStr,onAssetStr,gameId];
    
    //NSLog(@"URL %@", requestVars);
    
    NSData *requestData = [NSData dataWithBytes: [requestVars UTF8String] length: [requestVars length]];
    
    // Create the request.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:base]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    
    [theRequest setHTTPMethod: @"POST"];
    [theRequest setHTTPBody: requestData];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest
                                                                   delegate:self];
    
    if (theConnection)
        
    {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        
        self.receivedData = [NSMutableData data];
        
        
    } else {
        
        // Inform the user that the connection failed.
        /*
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"game", nil)]
                                                          message:[NSString stringWithFormat:NSLocalizedString(@"err-lost", nil)]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];*/
        
        
    }
    
    
    return self;
    
} //End submitQRScan Function



-(id) submitWeatherRequest:(double)lat andLong:(double)lon{
    
    
    NSLog(@" Entering submit weather");
    
    
    
    
    NSString *base = @"https://choose.tenqyu.com/v1/context/index.php";
    
    NSString *idstr = [@"id=" stringByAppendingString:@"getWeather"];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *langPref = [@"&langPref=" stringByAppendingString:language];
    
    NSString *latStr = [@"&lat=" stringByAppendingString:[NSString stringWithFormat:@"%f", lat]];
    NSString *longStr = [@"&lng=" stringByAppendingString:[NSString stringWithFormat:@"%f", lon]];
    
    NSString *requestVars = [idstr stringByAppendingFormat:@"%@%@%@",  latStr, longStr,langPref];
    
    //NSLog(@"URL %@", requestVars);
    
    NSData *requestData = [NSData dataWithBytes: [requestVars UTF8String] length: [requestVars length]];
    
    // Create the request.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:base]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    [theRequest setHTTPMethod: @"POST"];
    [theRequest setHTTPBody: requestData];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest
                                                                   delegate:self];
    
    if (theConnection)
        
    {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        
        self.receivedData = [NSMutableData data];
        
        
    } else {
        
        // Inform the user that the connection failed.
       /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"game", nil)]
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"err-lost", nil)]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];*/
        
       // [RKDropdownAlert title:[NSString stringWithFormat:NSLocalizedString(@"game", nil)] message:[NSString stringWithFormat:NSLocalizedString(@"err-lost", nil)] backgroundColor:[UIColor flatWhiteColor] textColor:[UIColor flatTealColor] time:5];
        
        [self notifyMe:@"game" withMessage:@"err-lost"];
    }
    
    
    return self;
    
} //End submitQRScan Function

#pragma mark Connection Methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  
    [self.receivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  
    [self.receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError %@ at URL %@", error, connection.currentRequest.URL.absoluteString );
/*

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"game", nil)]
                                                    message:[NSString stringWithFormat:NSLocalizedString(@"err-lost", nil)]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];*/
    
  //  [RKDropdownAlert title:[NSString stringWithFormat:NSLocalizedString(@"game", nil)] message:[NSString stringWithFormat:NSLocalizedString(@"err-lost", nil)] backgroundColor:[UIColor flatWhiteColor] textColor:[UIColor flatTealColor] time:5];
    
    [self notifyMe:@"game" withMessage:@"err-lost"];
    
    
    if(delegate && [delegate respondsToSelector:@selector(noLocationsReceived)]) {
        NSLog(@"Delegating no locations");
        [delegate noLocationsReceived];
        
    }
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    // do something with the data // receivedData is declared as a method instance elsewhere
    //  NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
  
    NSString *messageStr = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@" Return dataset :  %@", messageStr);
    
    if ([messageStr isEqual:@""]) {
        NSLog(@"Empty string !!");
        // return;
        
        self.jsondata=nil;
        
        if(delegate && [delegate respondsToSelector:@selector(noLocationsReceived)]) {
            //  NSLog(@"Delegating! %@",self.jsondata);
            [delegate noLocationsReceived];
        } else {
            NSLog(@"Not Delegating. I dont know why.");
        }
        
    } else {
        
        //By default read the json data
        NSError *e = nil;
        self.jsondata  = [NSJSONSerialization JSONObjectWithData: self.receivedData  options: NSJSONReadingMutableContainers error: &e];
        
        
     //   NSLog(@"%@",self.jsondata);
        
    
    }
    
    if ([self.connectionType isEqual: @"submitScan"] || [self.connectionType isEqual: @"saveImpression"]|| [self.connectionType isEqual: @"getWeatherContext"]) {
        
        
      //  NSLog(@" submitScan String %@ ",self.jsondata);
        
        if(delegate && [delegate respondsToSelector:@selector(notificationsReceived:)]) {
            //NSLog(@"Delegating!");
            [delegate notificationsReceived:self.jsondata];
            
        }
    
        

    }
    else {
    
        if(delegate && [delegate respondsToSelector:@selector(locationsReceived:)]) {
          //  NSLog(@"Delegating! %@",self.jsondata);
            [delegate locationsReceived:self.jsondata];
        } else {
            NSLog(@"Not Delegating. I dont know why.");
        }
            
    }
    
}


- (void) downloadUrlContent:(NSURL *)url {
    
    
    NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url 
                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                  timeoutInterval:60.0];
    
    conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    if (conn) {
    //    self.receivedData = [[NSMutableData data] retain];
    }
    
  //  [urlRequest release];

}

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (void) notifyMe:(NSString*)ttl withMessage:(NSString*)msg {
    
    [RKDropdownAlert title:[NSString stringWithFormat:NSLocalizedString(ttl, nil)] message:[NSString stringWithFormat:NSLocalizedString(msg, nil)] backgroundColor:[UIColor flatWhiteColor] textColor:[UIColor flatTealColor] time:5];
    
}

- (void)dealloc {
    
    //[conn release];
    //[receivedData release];
    //[locationManager release];
  //  [super dealloc];
}


@end
