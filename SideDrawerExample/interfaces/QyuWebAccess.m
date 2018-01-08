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
@synthesize distance,timeFrame,timeZone;
@synthesize email, pwd, playerId, userDetails, currentScore;
@synthesize error;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    self.error=FALSE;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.distance = [[[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"distance"]] objectForKey:@"distance"];
    self.timeFrame = [[[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"timeFrame"]] objectForKey:@"time"];
    if(!self.distance){
        self.distance=[NSString stringWithFormat:NSLocalizedString(@"def-distance", nil)];
    }
    
    self.userDetails = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"userData"] ] ;
    self.email=[userDetails objectForKey:@"email"];
    self.pwd=[userDetails objectForKey:@"pwd"];
    self.playerId = [userDetails objectForKey:@"id"];
    
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
    
    self.error=FALSE;
    
    //Get the settings defaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.distance = [[[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"distance"]] objectForKey:@"distance"];
    
    if(!self.distance){
        
        self.distance=[NSString stringWithFormat:NSLocalizedString(@"def-distance", nil)];
        
    } else {
        
        self.error=TRUE;
    }
    
    self.timeFrame = [[[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"timeFrame"]] objectForKey:@"time"];
    
    if(!self.timeFrame) {
        
        self.timeFrame=@"8";
    } else {
        
        self.error=TRUE;
    }
    
    self.timeZone = [[NSTimeZone localTimeZone] name];
 
    //User details
    self.userDetails = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"userData"] ] ;
    
    if(self.userDetails) {
        
        self.email=[userDetails objectForKey:@"email"];
        self.pwd=[userDetails objectForKey:@"pwd"];
        self.playerId = [userDetails objectForKey:@"id"];
        
    } else {
        
        self.error=TRUE;
    }

    
    objName=@"Webby";
    finishedLoading=FALSE;
    connectionType =cType;
    
    return self;
}

-(void) submitQRScan:(NSString *)qrcode withLat:(double)lat andLong:(double)lon{
    
    NSLog(@" Entering submitQRScan");
    
    if (!qrcode){
        self.error=TRUE;
    }
    
    NSString *escapedQRCode = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( NULL, (CFStringRef)qrcode, NULL, (CFStringRef)@"!’\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8));

    NSString *base = @"https://choose.tenqyu.com/index.php";
    NSString *mailStr = [@"&email=" stringByAppendingString:self.email ];
    NSString *pwdStr = [@"&pwd=" stringByAppendingString:self.pwd];
    NSString *idstr = [@"id=" stringByAppendingString:@"validateCode"];
    NSString *qrcodeStr = [@"&qrcode=" stringByAppendingString:escapedQRCode];
    NSString *tzStr = [@"&tz=" stringByAppendingString:self.timeZone];
    NSString *playerIdStr = [@"&playerId=" stringByAppendingString:self.playerId];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *langPref = [@"&langPref=" stringByAppendingString:language];
    NSString *latStr = [@"&lat=" stringByAppendingString:[NSString stringWithFormat:@"%f", lat]];
    NSString *longStr = [@"&long=" stringByAppendingString:[NSString stringWithFormat:@"%f", lon]];
    NSString *gameId = @"&gameId=5";
    
    NSString *requestVars = [idstr stringByAppendingFormat:@"%@%@%@%@%@%@%@%@%@",  latStr, longStr,mailStr,pwdStr,playerIdStr,langPref, tzStr, qrcodeStr,gameId];
    
    [self prepareWebRequest:base withParam:requestVars withError:self.error];
    
} //End submitQRScan Function


-(void) getEventData:(double)lat andLong:(double)lon{


    // Configure the new event with information from the location
    NSString *base = @"https://choose.tenqyu.com/index.php";
    NSString *idstr = [@"id=" stringByAppendingString:@"getEventList"];
    NSString *distanceStr = [@"&distance=" stringByAppendingString:self.distance];
    NSString *latitude = [NSString stringWithFormat:@"%f", lat];
    NSString *longitude = [NSString stringWithFormat:@"%f", lon];
    NSString *latStr = [@"&lat=" stringByAppendingString:latitude];
    NSString *longStr = [@"&lng=" stringByAppendingString:longitude ];
    NSString *mailStr = [@"&email=" stringByAppendingString:self.email ];
    NSString *pwdStr = [@"&pwd=" stringByAppendingString:self.pwd];
    NSString *mongoStr = [@"&playerId=" stringByAppendingString:self.playerId];
    NSString *eventHrsStr = [@"&nextHours=" stringByAppendingString:self.timeFrame];
    NSString *tzStr = [@"&tz=" stringByAppendingString:self.timeZone];
    
    
    NSString *requestVars = [idstr stringByAppendingFormat:@"%@%@%@%@%@%@%@%@", latStr,longStr,distanceStr,eventHrsStr,mailStr,pwdStr,mongoStr,tzStr];

    NSLog(@"%@",requestVars);
    self.error=FALSE;
    
    [self prepareWebRequest:base withParam:requestVars withError:self.error];
    
}

-(void) setDailyEventPrefs:(double)lat andLong:(double)lon {
    
    // Configure the new event with information from the location
    NSString *base = @"https://choose.tenqyu.com/v1/context/index.php";
    NSString *idstr = [@"id=" stringByAppendingString:@"setDailyEventPrefs"];
    NSString *playerIdStr = [@"&playerId=" stringByAppendingString:self.playerId];
    NSString *mailStr = [@"&email=" stringByAppendingString:self.email ];
    NSString *pwdStr = [@"&pwd=" stringByAppendingString:self.pwd];
    
    //Now go for the event data
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *tmpEventPrefs = [prefs objectForKey:@"pref_Categories"];

   // NSLog (@"%@",tmpEventPrefs);

    NSString *ArtsStr= [@"&Arts=" stringByAppendingString: [tmpEventPrefs objectForKey:@"Arts"]];
    NSString *BusinessStr= [@"&Business=" stringByAppendingString:[tmpEventPrefs objectForKey:@"Business"]];
    NSString *EducationStr= [@"&Education=" stringByAppendingString:[tmpEventPrefs objectForKey:@"Education"]];
    NSString *EntertainmentStr=[@"&Entertainment=" stringByAppendingString: [tmpEventPrefs objectForKey:@"Entertainment"]];
    NSString *FamilyStr=[@"&Family=" stringByAppendingString: [tmpEventPrefs objectForKey:@"Family"]];
    NSString *FoodStr= [@"&Food=" stringByAppendingString:[tmpEventPrefs objectForKey:@"Food"]];
    NSString *LargeStr=[@"&Large=" stringByAppendingString: [tmpEventPrefs objectForKey:@"Large"]];
    NSString *MeetingStr= [@"&Meeting=" stringByAppendingString:[tmpEventPrefs objectForKey:@"Meeting"]];
    NSString *OtherStr=[@"&Other=" stringByAppendingString: [tmpEventPrefs objectForKey:@"Other"]];
    NSString *SocialStr= [@"&Social=" stringByAppendingString:[tmpEventPrefs objectForKey:@"Social"]];
    NSString *SportsStr=[@"&Sports=" stringByAppendingString: [tmpEventPrefs objectForKey:@"Sports"]];
    NSString *TechStr=[@"&Tech=" stringByAppendingString: [tmpEventPrefs objectForKey:@"Tech"]];
    
    NSString *latitude = [NSString stringWithFormat:@"%f", lat];
    NSString *longitude = [NSString stringWithFormat:@"%f", lon];
    NSString *latStr = [@"&latitude=" stringByAppendingString:latitude];
    NSString *longStr = [@"&longitude=" stringByAppendingString:longitude ];
    
    
    NSString *requestVars = [idstr stringByAppendingFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",mailStr,pwdStr,playerIdStr,ArtsStr,BusinessStr,EducationStr,EntertainmentStr,FamilyStr,FoodStr,LargeStr,MeetingStr,OtherStr,SocialStr,SportsStr,TechStr,latStr,longStr];
    
    NSLog(@"%@",requestVars);
    
    self.error=FALSE;
    
    [self prepareWebRequest:base withParam:requestVars withError:self.error];
}

-(void) saveImpression:(NSString *)impression onAsset:(NSString*)onAsset withLat:(double)lat andLong:(double)lon{
    
    NSLog(@" Entering save Impression");
    if (!impression){
        self.error=TRUE;
    }
    
    NSString *base = @"https://choose.tenqyu.com/v1/activity/index.php";
    NSString *mailStr = [@"&email=" stringByAppendingString:self.email ];
    NSString *pwdStr = [@"&pwd=" stringByAppendingString:self.pwd];
    NSString *idstr = [@"id=" stringByAppendingString:@"saveImpression"];
    NSString *impressionStr = [@"&impression=" stringByAppendingString:impression];
    NSString *onAssetStr = [@"&onAsset=" stringByAppendingString:onAsset];
    NSString *mongoStr = [@"&playerId=" stringByAppendingString:self.playerId];
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *langPref = [@"&langPref=" stringByAppendingString:language];
    NSString *latStr = [@"&lat=" stringByAppendingString:[NSString stringWithFormat:@"%f", lat]];
    NSString *longStr = [@"&lng=" stringByAppendingString:[NSString stringWithFormat:@"%f", lon]];
    NSString *gameId = @"&gameId=5";
    
    NSString *requestVars = [idstr stringByAppendingFormat:@"%@%@%@%@%@%@%@%@%@",  latStr, longStr,mailStr,pwdStr,mongoStr,langPref, impressionStr,onAssetStr,gameId];
    
    [self prepareWebRequest:base withParam:requestVars withError:self.error];
    
} //End saveImpression Function

-(void) getWeatherData:(double)lat andLong:(double)lon{
    
    NSLog(@" Entering submit weather");
    NSString *base = @"https://choose.tenqyu.com/v1/context/index.php";
    NSString *idstr = [@"id=" stringByAppendingString:@"getWeather"];
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *langPref = [@"&langPref=" stringByAppendingString:language];
    NSString *latStr = [@"&lat=" stringByAppendingString:[NSString stringWithFormat:@"%f", lat]];
    NSString *longStr = [@"&lng=" stringByAppendingString:[NSString stringWithFormat:@"%f", lon]];
    NSString *requestVars = [idstr stringByAppendingFormat:@"%@%@%@",  latStr, longStr,langPref];
    
    [self prepareWebRequest:base withParam:requestVars withError:self.error];
    
} //End getWeather Function

#pragma mark Connection Methods

-(id) prepareWebRequest:(NSString*)base withParam:(NSString*)parameters withError:(bool)error{
    
    if(error){
        //if there is an error then return false
        return false;
    }
    //NSLog(@"URL %@", requestVars);
    NSData *requestData = [NSData dataWithBytes: [parameters UTF8String] length: [parameters length]];
    
    // Create the request.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:base]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    // create the connection with the request and start loading the data
    [theRequest setHTTPMethod: @"POST"];
    [theRequest setHTTPBody: requestData];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest
                                                                   delegate:self];
    if (theConnection)
        
    {
        // Create the NSMutableData to hold the received data.
        self.receivedData = [NSMutableData data];
    } else {
        [self notifyMe:@"game" withMessage:@"err-lost"];
    }
    return self;
}



- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  
    [self.receivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  
    [self.receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError %@ at URL %@", error, connection.currentRequest.URL.absoluteString );

    if(![self.connectionType isEqual: @"saveImpression"]){
        [self notifyMe:@"game" withMessage:@"err-lost"];
    }
    
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
    // NSLog(@" Return dataset :  %@", messageStr);
    
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
    
    if ([self.connectionType isEqual: @"submitScan"] || [self.connectionType isEqual: @"saveImpression"]|| [self.connectionType isEqual: @"getWeatherContext"]|| [self.connectionType isEqual: @"updateDailyPreferences"]) {
      
        NSLog(@"[QuWebAccess] con type %@ with data  %@ ",self.connectionType, self.jsondata);
        
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

}

- (void) notifyMe:(NSString*)ttl withMessage:(NSString*)msg {
    
    [RKDropdownAlert title:[NSString stringWithFormat:NSLocalizedString(ttl, nil)] message:[NSString stringWithFormat:NSLocalizedString(msg, nil)] backgroundColor:[UIColor flatWhiteColor] textColor:[UIColor flatTealColor] time:5];
    
}

@end
