//
//  MapViewController.h
//  DSOpenWeatherMap
//
//  Created by Degtyar Sergey on 25.07.15.
//  Copyright (c) 2015 Degtyar Serg. All rights reserved.
//

#import "DSWeatherViewController.h"
#import <MapKit/MapKit.h>
#import "DSWeatherModel.h"

@interface DSMapViewController : UIViewController

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) DSWeatherModel *weatherModel;

- (IBAction)setMap:(UISegmentedControl *)sender;
- (IBAction)getLocation:(id)sender;

@end
