//
//  MapViewController.m
//  DSOpenWeatherMap
//
//  Created by Degtyar Sergey on 25.07.15.
//  Copyright (c) 2015 Degtyar Serg. All rights reserved.
//

#import "DSMapViewController.h"

@interface DSMapViewController () <MKMapViewDelegate>

@end

@implementation DSMapViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:self.weatherModel.cityName];
    
    self.mapView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateMapView];
}

# pragma mark - Privat methods

- (void)updateMapView {
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.weatherModel.cityLat doubleValue],
                                                                 [self.weatherModel.cityLon doubleValue]);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.title = self.weatherModel.cityName;
    annotation.subtitle = [NSString stringWithFormat:@"%li°", self.weatherModel.weatherTemp];
    [annotation setCoordinate:location];

    [self.mapView addAnnotation:annotation];
    [self.mapView setRegion:region animated:YES];
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
}

- (IBAction)longpressToGetLocation:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D location = [self.mapView convertPoint:touchPoint
                                            toCoordinateFromView:self.mapView];
    
    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
}

#pragma mark - MKMapViewDelegate methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

@end
