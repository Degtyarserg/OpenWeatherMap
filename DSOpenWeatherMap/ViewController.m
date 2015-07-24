//
//  ViewController.m
//  DSOpenWeatherMap
//
//  Created by Degtyar Sergey on 21.07.15.
//  Copyright (c) 2015 Degtyar Serg. All rights reserved.
//

#import "ViewController.h"
#import "DSWeatherMadel.h"
#import <MBProgressHUD.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <DSWeatherMadelDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) NSURL *rootUrl;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) DSWeatherMadel *weatherModel;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

#pragma mark - Life cycle

-(void)loadView {
    [super loadView];
    
//    UIImage *backgroundImage = [UIImage imageNamed:@"background"];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.view.backgroundColor = [UIColor purpleColor];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.weatherModel = [[DSWeatherMadel alloc] init];
    self.weatherModel.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action methods

- (IBAction)cityButton:(UIBarButtonItem *)sender {
    
    [self displayCityAlert];
}

#pragma mark - Helper methods

- (void)displayCityAlert {
    
    __weak ViewController *weakSelf = self;

    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"City"
                                          message:@"Enter city name"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   [self activityIndicatorHud];
                                   UITextField *textField = alertController.textFields.firstObject;
                                   [weakSelf.weatherModel weatherForCity:textField.text];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"City name";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)activityIndicatorHud {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

#pragma mark - DSWeatherMadelDelegate methods

- (void)updateWeatherInfo:(NSDictionary *)dictWithWeather {
    
    DSWeatherMadel *weatherMadel = [[DSWeatherMadel alloc] init];
    
    weatherMadel.cityName = dictWithWeather[@"name"];
    NSDictionary *sys = [dictWithWeather objectForKey:@"sys"];
    weatherMadel.country = sys[@"country"];
    self.cityLabel.text = [NSString stringWithFormat:@"%@, %@", weatherMadel.cityName, weatherMadel.country];
    NSLog(@"%@, %@", weatherMadel.cityName, weatherMadel.country);
    
    NSInteger time = [[dictWithWeather objectForKey:@"dt"] integerValue];
    NSString *stringWithTime = [weatherMadel dateFromUnixFormat:time];
    self.timeLabel.text = stringWithTime;
    
    NSDictionary *main = [dictWithWeather objectForKey:@"main"];
    NSInteger tempK = [main[@"temp"] integerValue];
    NSInteger maxTempK = [main[@"temp_max"] integerValue];
    NSInteger minTempK = [main[@"temp_min"] integerValue];
    weatherMadel.weatherTemp = [weatherMadel convertTemperature:tempK];
    weatherMadel.weatherMaxTemp = [weatherMadel convertTemperature:maxTempK];
    weatherMadel.weatherMinTemp = [weatherMadel convertTemperature:minTempK];
    self.tempLabel.text = [NSString stringWithFormat:@"%li", weatherMadel.weatherTemp];
    self.maxTempLabel.text = [NSString stringWithFormat:@"%li", weatherMadel.weatherMaxTemp];
    self.minTempLabel.text = [NSString stringWithFormat:@"%li", weatherMadel.weatherMinTemp];
    
    weatherMadel.weatherHumidity = [main[@"humidity"]integerValue];
    self.humidityLabel.text = [NSString stringWithFormat:@"%li", weatherMadel.weatherHumidity];
    
    NSDictionary *wind = [dictWithWeather objectForKey:@"wind"];
    weatherMadel.weatherWind = [wind[@"speed"] doubleValue];
    self.windLabel.text = [NSString stringWithFormat:@"%.2f", weatherMadel.weatherWind];
    
    NSArray *arrayWithWeather = [dictWithWeather objectForKey:@"weather"];
    NSDictionary *weather = [arrayWithWeather objectAtIndex:0];
    weatherMadel.weatherDescriotion = [weather objectForKey:@"description"];
    self.descriptionLabel.text = weatherMadel.weatherDescriotion;
    
    NSInteger condition = [[weather objectForKey:@"id"] integerValue];
    BOOL nightTime = [weatherMadel isTimaNight:dictWithWeather];
    
    UIImage *icon = [weatherMadel updateWeatherIcon:condition isNight:nightTime];
    self.iconImageView.image = icon;

    NSLog(@"%@", weatherMadel.cityName);
    NSLog(@"%li", weatherMadel.weatherTemp);
}

- (void)failure {
 
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Error"
                                          message:@"No connection"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:nil];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"%@", manager.location);
    [self activityIndicatorHud];
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation.horizontalAccuracy > 0) {
        [self.locationManager stopUpdatingLocation];
        
        CLLocationCoordinate2D coords  = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
        
        [self.weatherModel weatherForLocation:coords];
        NSLog(@"%f, %f", coords.latitude, coords.longitude);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"Can't get your location");
    NSLog(@"Error: %@", error);
}

@end
