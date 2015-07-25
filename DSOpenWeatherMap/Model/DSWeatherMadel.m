//
//  DSWeatherMadel.m
//  DSOpenWeatherMap
//
//  Created by Degtyar Sergey on 22.07.15.
//  Copyright (c) 2015 Degtyar Serg. All rights reserved.
//

#import "DSWeatherMadel.h"
#import <AFNetworking.h>

static NSString * const kStringWithUrl = @"http://api.openweathermap.org/data/2.5/weather/?";
static NSInteger const tempK = 273;

@interface DSWeatherMadel ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation DSWeatherMadel

#pragma mark - init/dealloc methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL *url = [NSURL URLWithString:kStringWithUrl];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}

#pragma mark Pablic methods

- (void) weatherForCity:(NSString *)string {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:string, @"q", nil];
    [self setRequest:params];
    
   }

- (void)setRequest:(NSDictionary *)params {
    
    __weak DSWeatherMadel *weakSelf = self;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kStringWithUrl parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.delegate updateWeatherInfo:responseObject];
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        [self.delegate failure];
    }];

}

- (NSInteger)convertTemperature:(NSInteger)temperature {
    
    return (temperature - tempK);
}

#pragma mark - Helper methods

- (NSString *)dateFromUnixFormat:(NSInteger)unixFormat {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixFormat];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, HH:mm"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString *stringWithDate=[dateFormatter stringFromDate:date];
    
    return stringWithDate;
}

- (UIImage *)updateWeatherIcon:(NSInteger)condition isNight:(BOOL)nightTine {
    
    NSString *imageName;
    
    if (condition < 300 && nightTine == YES) {
        imageName = @"11n";
    };
    if (condition < 300 && nightTine == NO) {
        imageName = @"11d";
    };
    
    if (condition > 300 && condition < 500 && nightTine == YES) {
        imageName = @"09n";
    };
    if (condition > 300 && condition < 500 && nightTine == NO) {
        imageName = @"09d";
    };
    
    if (condition >= 500 && condition <= 504 && nightTine == YES) {
        imageName = @"10n";
    };
    if (condition >= 500 && condition <= 504 && nightTine == NO) {
        imageName = @"10d";
    };
    
    if (condition == 511 && nightTine == YES) {
        imageName = @"13n";
    };
    if (condition == 511 && nightTine == NO) {
        imageName = @"13d";
    };
    
    if (condition >= 520 && condition <= 531 && nightTine == YES) {
        imageName = @"09n";
    };
    if (condition >= 520 && condition <= 531 && nightTine == NO) {
        imageName = @"09d";
    };

    if (condition >= 600 && condition <= 622 && nightTine == YES) {
        imageName = @"13n";
    };
    if (condition >= 600 && condition <= 622 && nightTine == NO) {
        imageName = @"13d";
    };
    
    if (condition > 700 && condition < 800 && nightTine == YES) {
        imageName = @"50n";
    };
    if (condition > 700 && condition < 800 && nightTine == NO) {
        imageName = @"50d";
    };
    
    if (condition == 800 && nightTine == YES) {
        imageName = @"01n";
    };
    if (condition == 800 && nightTine == NO) {
        imageName = @"01d";
    };
    
    if (condition == 801 && nightTine == YES) {
        imageName = @"02n";
    };
    if (condition == 801 && nightTine == NO) {
        imageName = @"02d";
    };
    
    if (condition == 802 && nightTine == YES) {
        imageName = @"03n";
    };
    if (condition == 802 && nightTine == NO) {
        imageName = @"03d";
    };
    
    if (condition >= 803 && condition <=804 && nightTine == YES) {
        imageName = @"04n";
    };
    if (condition == 803 && condition <=804 && nightTine == NO) {
        imageName = @"04d";
    };
    
    if (condition >= 900 && condition <=1000 && nightTine == YES) {
        imageName = @"11n";
    };
    if (condition == 900 && condition <=1000 && nightTine == NO) {
        imageName = @"011d";
    };
    
    UIImage *imageIcon = [UIImage imageNamed:imageName];
    return imageIcon;
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
