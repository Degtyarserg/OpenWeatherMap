//
//  DSWeatherMadel.h
//  DSOpenWeatherMap
//
//  Created by Degtyar Sergey on 22.07.15.
//  Copyright (c) 2015 Degtyar Serg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@protocol DSWeatherMadelDelegate;

@interface DSWeatherMadel : NSObject

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, assign) NSInteger weatherTemp;
@property (nonatomic, assign) NSInteger weatherMaxTemp;
@property (nonatomic, assign) NSInteger weatherMinTemp;
@property (nonatomic, assign) NSInteger weatherHumidity;
@property (nonatomic, assign) double weatherWind;
@property (nonatomic, strong) NSString *weatherDescriotion;
@property (nonatomic ,strong) NSString *weatherDate;
@property (nonatomic, strong) UIImage *weatherIcon;
@property (nonatomic, weak) CLLocation *currentLocation;
@property (nonatomic, weak) id<DSWeatherMadelDelegate> delegate;

- (void) weatherForCity:(NSString *)string;
- (void)setRequest:(NSDictionary *)params;
- (NSInteger)convertTemperature:(NSInteger)temperature;
- (UIImage *)updateWeatherIcon:(NSInteger)condition isNight:(BOOL)nightTine;
- (BOOL)isTimaNight:(NSString *)icon;
- (void)weatherForLocation:(CLLocationCoordinate2D)geo;
- (NSString *)dateFromUnixFormat:(NSInteger)unixFormat;

@end

@protocol DSWeatherMadelDelegate

@required
- (void)updateWeatherInfo:(NSDictionary *)dictWithWeather;
- (void)failure;

@end