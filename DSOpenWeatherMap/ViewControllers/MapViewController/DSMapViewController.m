//
//  MapViewController.m
//  DSOpenWeatherMap
//
//  Created by Degtyar Sergey on 25.07.15.
//  Copyright (c) 2015 Degtyar Serg. All rights reserved.
//

#import "DSMapViewController.h"
#import "DSWeatherModel.h"

@interface DSMapViewController () <MKMapViewDelegate>

@end

@implementation DSMapViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
//    DSWeatherModel *weatherModel = [[DSWeatherModel alloc] init];
    
//    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([weatherModel.cityLat doubleValue], [weatherModel.cityLon doubleValue]);
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(51.51, -0.13);

    
//    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//    [annotation setCoordinate:location];
//    annotation.title = weatherModel.cityName;
//
//    [self.mapView addAnnotation:annotation];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    
    [self.mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action methods

- (IBAction)setMap:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
            
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
            
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
            
        default:
            break;
    }
}

#pragma mark - Action methods

- (IBAction)getLocation:(id)sender {
    
    [self.mapView setShowsUserLocation:YES];
    NSLog(@"My location");
}

- (void)longpressToGetLocation:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D location =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
}

#pragma mark - MKMapViewDelegate methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.mapView];
    NSLog(@"%f, %f", location.x, location.y);
}


@end
