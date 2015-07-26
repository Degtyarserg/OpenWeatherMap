//
//  ViewController.m
//  DSOpenWeatherMap
//
//  Created by Degtyar Sergey on 21.07.15.
//  Copyright (c) 2015 Degtyar Serg. All rights reserved.
//

#import "DSWeatherViewController.h"
#import "DSWeatherModel.h"
#import <MBProgressHUD.h>
#import <CoreLocation/CoreLocation.h>
#import "DSMapViewController.h"

static NSString * const kMapSegueID = @"DSMapSegueID";
static NSString * const imageName = @"background";

@interface DSWeatherViewController () <DSWeatherModelDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *cityLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *maxTempLabel;
@property (nonatomic, weak) IBOutlet UILabel *minTempLabel;
@property (nonatomic, weak) IBOutlet UILabel *tempLabel;
@property (nonatomic, weak) IBOutlet UILabel *windLabel;
@property (nonatomic, weak) IBOutlet UILabel *humidityLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, strong) NSURL *rootUrl;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) DSWeatherModel *weatherModel;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation DSWeatherViewController

#pragma mark - Life cycle

- (void)loadView {
    [super loadView];
    
    UIImage *backgroundImage = [UIImage imageNamed:imageName];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.weatherModel = [[DSWeatherModel alloc] init];
    self.weatherModel.delegate = self;
    
    [self setupLocationManager];
    
    [self setTitle:NSLocalizedString(@"Weather", nil)];
    
}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kMapSegueID]) {
        DSMapViewController *mapVC = (DSMapViewController *)[segue destinationViewController];
        mapVC.weatherModel = self.weatherModel;
    }
}

#pragma mark - Action methods

- (IBAction)cityButton:(UIBarButtonItem *)sender {
    
    [self displayCityAlert];
}

#pragma mark - Privat methods

- (void)setupLocationManager {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)displayCityAlert {
    
    __weak DSWeatherViewController *weakSelf = self;

    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"City", nil)
                                          message:NSLocalizedString(@"Enter city name", nil)
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [weakSelf activityIndicatorHud];
                                   UITextField *textField = alertController.textFields.firstObject;
                                   [weakSelf.weatherModel weatherForCity:textField.text];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"City name", nil);
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)activityIndicatorHud {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak DSWeatherViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    });
}

#pragma mark - DSWeatherModelDelegate methods

- (void)weatherDataDidUpdated {
    
    self.cityLabel.text = [NSString stringWithFormat:@"%@, %@", self.weatherModel.cityName, self.weatherModel.country];
    self.timeLabel.text = self.weatherModel.stringWithTime;
    
    self.tempLabel.text = [NSString stringWithFormat:@"%li°", self.weatherModel.weatherTemp];
    self.maxTempLabel.text = [NSString stringWithFormat:@"%li°", self.weatherModel.weatherMaxTemp];
    self.minTempLabel.text = [NSString stringWithFormat:@"%li°", self.weatherModel.weatherMinTemp];
    
    self.humidityLabel.text = [NSString stringWithFormat:@"%li", self.weatherModel.weatherHumidity];
    self.windLabel.text = [NSString stringWithFormat:@"%.2f", self.weatherModel.weatherWind];
    self.descriptionLabel.text = self.weatherModel.weatherDescriotion;
    
    self.iconImageView.image = [UIImage imageNamed:self.weatherModel.iconName];
}

- (void)failure {
 
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                          message:NSLocalizedString(@"No connection", nil)
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", nil)
                               style:UIAlertActionStyleDefault
                               handler:nil];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [self activityIndicatorHud];
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation.horizontalAccuracy > 0) {
        [self.locationManager stopUpdatingLocation];
        
        CLLocationCoordinate2D coords  = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude,
                                                                    currentLocation.coordinate.longitude);
        [self.weatherModel weatherForLocation:coords];
    }
}

@end
