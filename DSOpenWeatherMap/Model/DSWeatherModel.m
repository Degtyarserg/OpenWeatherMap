//
//  DSWeatherMadel.m
//  DSOpenWeatherMap
//
//  Created by Degtyar Sergey on 22.07.15.
//  Copyright (c) 2015 Degtyar Serg. All rights reserved.
//

#import "DSWeatherModel.h"
#import <AFNetworking.h>
#import "DSWeatherIconByCondition.h"

static NSString * const kStringWithUrl = @"http://api.openweathermap.org/data/2.5/weather/?";
static NSInteger const tempK = 273;

@interface DSWeatherModel ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation DSWeatherModel

#pragma mark - Pablic methods

- (void)parseWeatherInfo:(NSDictionary *)dictWithWeather {
    
    self.cityName = dictWithWeather[@"name"];
    NSDictionary *sys = [dictWithWeather objectForKey:@"sys"];
    _country = sys[@"country"];
    
    NSDictionary *coord = [dictWithWeather objectForKey:@"coord"];
    _cityLat = [coord objectForKey:@"lat"];
    _cityLon = [coord objectForKey:@"lon"];
    
    NSInteger time = [[dictWithWeather objectForKey:@"dt"] integerValue];
    _stringWithTime = [self dateFromUnixFormat:time];
    
    NSDictionary *main = [dictWithWeather objectForKey:@"main"];
    NSInteger tempK = [main[@"temp"] integerValue];
    NSInteger maxTempK = [main[@"temp_max"] integerValue];
    NSInteger minTempK = [main[@"temp_min"] integerValue];
    _weatherTemp = [self convertTemperature:tempK];
    _weatherMaxTemp = [self convertTemperature:maxTempK];
    _weatherMinTemp = [self convertTemperature:minTempK];
    
    _weatherHumidity = [main[@"humidity"]integerValue];
    
    NSDictionary *wind = [dictWithWeather objectForKey:@"wind"];
    _weatherWind = [wind[@"speed"] doubleValue];
    
    NSArray *arrayWithWeather = [dictWithWeather objectForKey:@"weather"];
    NSDictionary *weather = [arrayWithWeather objectAtIndex:0];
    _weatherDescriotion = [weather objectForKey:@"description"];
    
    NSInteger condition = [[weather objectForKey:@"id"] integerValue];
    NSString *stringWithIcon = [weather objectForKey:@"icon"];
    BOOL nightTime = [self isTimaNight:stringWithIcon];
    
    _iconName = [DSWeatherIconByCondition updateWeatherIcon:condition isNight:nightTime];
}

- (void)weatherForCity:(NSString *)string {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:string, @"q", nil];
    [self setRequest:params];
}

- (void)setRequest:(NSDictionary *)params {
    
    NSURL *url = [NSURL URLWithString:kStringWithUrl];
    self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    __weak DSWeatherModel *weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kStringWithUrl parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf parseWeatherInfo:responseObject];
            [weakSelf.delegate weatherDataDidUpdated];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [weakSelf.delegate failure];
    }];
}

- (NSInteger)convertTemperature:(NSInteger)temperature {
    
    return (temperature - tempK);
}

#pragma mark - Privat methods

- (NSString *)dateFromUnixFormat:(NSInteger)unixFormat {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixFormat];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, HH:mm"];
    NSString *stringWithDate = [dateFormatter stringFromDate:date];
    
    return stringWithDate;
}

- (BOOL)isTimaNight:(NSString *)icon {
    
    return [icon rangeOfString:@"n"].location == 0;
}

- (void)weatherForLocation:(CLLocationCoordinate2D)geo {
    
    NSNumber *latitude = [NSNumber numberWithDouble:geo.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:geo.longitude];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:latitude, @"lat", longitude, @"lon", nil];
    [self setRequest:params];
}

@end
