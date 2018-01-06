//
//  QyuWebAccess.h
//  Qyu
//
//  Created by ファースト ラスト on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "RKDropdownAlert.h"

@protocol QyuWebDelegate <NSObject>

@required

- (void)notificationsReceived:(NSDictionary *)resultData;
- (void)locationsReceived:(NSDictionary *)resultData;
- (void) noLocationsReceived;
@end

@interface QyuWebAccess : NSObject
{
    
    NSURLConnection * conn;
    NSMutableData * receivedData;
    NSString *objName;
    NSString *imgMongoId; //This is for the image download
    BOOL finishedLoading;
    NSString *connectionType ; //this is for differentiating the connections
    NSDictionary *jsondata;
    UIImage *webImg;
    NSString *coreDataKey;
    NSString *iPath ;
    
    //User defaults
    NSString *distance;
    NSString *timeFrame;
    NSString *timeZone;
    NSMutableDictionary *userDetails;
    
    //All information about the player
    NSString *email;
    NSString *pwd;
    NSString *playerId;
    NSString *currentScore;
    
    
    __strong id<QyuWebDelegate> delegate;
     
}

@property (nonatomic, retain) CLLocationManager *locationManager;

@property(nonatomic, retain) NSURLConnection * conn;
@property(nonatomic, retain) NSMutableData * receivedData;
@property(nonatomic, retain) NSString *objName;
@property(nonatomic, retain) NSString *imgMongoId;
@property(nonatomic, retain) NSString *connectionType;
@property(nonatomic, retain) NSDictionary *jsondata;
@property(nonatomic, retain) UIImage *webImg;

@property(nonatomic, retain) NSString *distance ;
@property(nonatomic, retain) NSString *timeFrame ;
@property(nonatomic, retain) NSString *timeZone ;

//user detais
@property(nonatomic, retain) NSMutableDictionary *userDetails;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *pwd;
@property(nonatomic, retain) NSString *playerId;
@property(nonatomic, retain) NSString *currentScore;

@property(nonatomic, assign) BOOL error;

@property(nonatomic, assign) BOOL finishedLoading;
@property (nonatomic, retain) __strong id <QyuWebDelegate> delegate;

-(id)initWithConnectionType:(NSString *) cType;

-(void) submitLocationScan:(double)lat andLong:(double)lon;
-(void) submitQRScan:(NSString *)qrcode withLat:(double)lat andLong:(double)lon ;
-(void) saveImpression:(NSString *)impression onAsset:(NSString*)onAsset withLat:(double)lat andLong:(double)lon;
-(void) submitWeatherRequest:(double)lat andLong:(double)lon;
-(void) sendDailyEventPrefs;
-(id) prepareWebRequest:(NSString*)base withParam:(NSString*)parameters withError:(bool) error;

@end

