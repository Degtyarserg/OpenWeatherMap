//
//  DSWeatherIconByCondition.h
//  DSOpenWeatherMap
//
//  Created by Degtyar Sergey on 26.07.15.
//  Copyright (c) 2015 Degtyar Serg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSWeatherIconByCondition : NSObject

+ (NSString *)updateWeatherIcon:(NSInteger)condition isNight:(BOOL)nightTine;

@end
