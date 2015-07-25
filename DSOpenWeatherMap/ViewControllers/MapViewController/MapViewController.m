//
//  MapViewController.m
//  DSOpenWeatherMap
//
//  Created by Degtyar Sergey on 25.07.15.
//  Copyright (c) 2015 Degtyar Serg. All rights reserved.
//

#import "MapViewController.h"
#import "DSWeatherMadel.h"

@interface MapViewController ()

@end

@implementation MapViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(51.51, -0.13);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:location];
    annotation.title = @"London";

    [self.mapView addAnnotation:annotation];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
    
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

- (IBAction)getLocation:(id)sender {
    
    self.mapView.showsUserLocation = YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
