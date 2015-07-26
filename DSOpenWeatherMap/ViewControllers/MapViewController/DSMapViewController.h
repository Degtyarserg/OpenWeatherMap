//
//  MapViewController.h
//  DSOpenWeatherMap
//
//  Created by Degtyar Sergey on 25.07.15.
//  Copyright (c) 2015 Degtyar Serg. All rights reserved.
//

#import "DSWeatherViewController.h"
#import <MapKit/MapKit.h>

@interface DSMapViewController : DSWeatherViewController 

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)setMap:(UISegmentedControl *)sender;
- (IBAction)getLocation:(id)sender;

@end