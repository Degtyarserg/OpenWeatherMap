//
//  ViewController.h
//  DSOpenWeatherMap
//
//  Created by Degtyar Sergey on 21.07.15.
//  Copyright (c) 2015 Degtyar Serg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DSWeatherViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *cityLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *maxTempLabel;
@property (nonatomic, weak) IBOutlet UILabel *minTempLabel;
@property (nonatomic, weak) IBOutlet UILabel *tempLabel;
@property (nonatomic, weak) IBOutlet UILabel *windLabel;
@property (nonatomic, weak) IBOutlet UILabel *humidityLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

- (IBAction)cityButton:(UIBarButtonItem *)sender;

@end

