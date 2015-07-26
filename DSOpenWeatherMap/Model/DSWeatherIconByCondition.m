//
//  DSWeatherIconByCondition.m
//  DSOpenWeatherMap
//
//  Created by Degtyar Sergey on 26.07.15.
//  Copyright (c) 2015 Degtyar Serg. All rights reserved.
//

#import "DSWeatherIconByCondition.h"

@implementation DSWeatherIconByCondition

+ (NSString *)updateWeatherIcon:(NSInteger)condition isNight:(BOOL)nightTine {
    
    NSString *imageName;
    
    if (condition < 300 && nightTine == YES) {
        imageName = @"11n";
    }
    if (condition < 300 && nightTine == NO) {
        imageName = @"11d";
    }
    
    if (condition > 300 && condition < 500 && nightTine == YES) {
        imageName = @"09n";
    }
    if (condition > 300 && condition < 500 && nightTine == NO) {
        imageName = @"09d";
    }
    
    if (condition >= 500 && condition <= 504 && nightTine == YES) {
        imageName = @"10n";
    }
    if (condition >= 500 && condition <= 504 && nightTine == NO) {
        imageName = @"10d";
    }
    
    if (condition == 511 && nightTine == YES) {
        imageName = @"13n";
    }
    if (condition == 511 && nightTine == NO) {
        imageName = @"13d";
    }
    
    if (condition >= 520 && condition <= 531 && nightTine == YES) {
        imageName = @"09n";
    }
    if (condition >= 520 && condition <= 531 && nightTine == NO) {
        imageName = @"09d";
    }
    
    if (condition >= 600 && condition <= 622 && nightTine == YES) {
        imageName = @"13n";
    }
    if (condition >= 600 && condition <= 622 && nightTine == NO) {
        imageName = @"13d";
    }
    
    if (condition > 700 && condition < 800 && nightTine == YES) {
        imageName = @"50n";
    }
    if (condition > 700 && condition < 800 && nightTine == NO) {
        imageName = @"50d";
    }
    
    if (condition == 800 && nightTine == YES) {
        imageName = @"01n";
    }
    if (condition == 800 && nightTine == NO) {
        imageName = @"01d";
    }
    
    if (condition == 801 && nightTine == YES) {
        imageName = @"02n";
    }
    if (condition == 801 && nightTine == NO) {
        imageName = @"02d";
    }
    
    if (condition == 802 && nightTine == YES) {
        imageName = @"03n";
    }
    if (condition == 802 && nightTine == NO) {
        imageName = @"03d";
    }
    
    if (condition >= 803 && condition <=804 && nightTine == YES) {
        imageName = @"04n";
    }
    if (condition == 803 && condition <=804 && nightTine == NO) {
        imageName = @"04d";
    }
    
    if (condition >= 900 && condition <=1000 && nightTine == YES) {
        imageName = @"11n";
    }
    if (condition == 900 && condition <=1000 && nightTine == NO) {
        imageName = @"011d";
    }
    return imageName;
}

@end
