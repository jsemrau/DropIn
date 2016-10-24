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
  //  CLLocationManager *locationManager;
    NSString *iPath ;
    
    NSString *distance;
    NSString *timeFrame;
    NSString *timeZone;
    
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
@property(nonatomic, retain) NSString *coreDataKey;
@property(nonatomic, retain) NSString *iPath ;
@property(nonatomic, retain) NSString *distance ;
@property(nonatomic, retain) NSString *timeFrame ;
@property(nonatomic, retain) NSString *timeZone ;

@property(nonatomic, assign) BOOL finishedLoading;
@property (nonatomic, retain) __strong id <QyuWebDelegate> delegate;

-(id)initWithConnectionType:(NSString *) cType;
//-(id) submitLocationScan:(NSString *)latitude longitude:(NSString *)longitude distance:(NSString *)distance ;

-(id) submitLocationScan:(double)lat andLong:(double)lon email:(NSString *)email pwd:(NSString *)pwd  mongoId:(NSString *)mongoId;
-(id) submitQRScan:(NSString *)qrcode email:(NSString *)email pwd:(NSString *)pwd  mongoId:(NSString *)mongoId withLat:(double)lat andLong:(double)lon ;
-(id) saveImpression:(NSString *)impression onAsset:(NSString*)onAsset email:(NSString *)email pwd:(NSString *)pwd  mongoId:(NSString *)mongoId withLat:(double)lat andLong:(double)lon;
-(id) submitWeatherRequest:(double)lat andLong:(double)lon;

@end

