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

@protocol DSWeatherModelDelegate;

@interface DSWeatherModel : NSObject

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong, readonly) NSString *country;
@property (nonatomic, assign, readonly) NSInteger weatherTemp;
@property (nonatomic, assign, readonly) NSInteger weatherMaxTemp;
@property (nonatomic, assign, readonly) NSInteger weatherMinTemp;
@property (nonatomic, assign, readonly) NSInteger weatherHumidity;
@property (nonatomic, strong, readonly) NSString *weatherDescriotion;
@property (nonatomic, strong, readonly) NSString *weatherDate;
@property (nonatomic, strong, readonly) UIImage *weatherIcon;
@property (nonatomic, assign, readonly) double weatherWind;
@property (nonatomic, strong, readonly) NSNumber *cityLat;
@property (nonatomic, strong, readonly) NSNumber *cityLon;
@property (nonatomic, strong, readonly) NSString *stringWithTime;
@property (nonatomic, strong, readonly) NSString *iconName;
@property (nonatomic, weak) id<DSWeatherModelDelegate> delegate;

- (void)weatherForCity:(NSString *)string;
- (void)setRequest:(NSDictionary *)params;
- (void)weatherForLocation:(CLLocationCoordinate2D)geo;

@end

@protocol DSWeatherModelDelegate

@required

- (void)weatherDataDidUpdated;
- (void)failure;

@end
