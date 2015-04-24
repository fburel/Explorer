//
//  CityLocator.m
//  Explorer
//
//  Created by florian BUREL on 24/04/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

#import "CityLocator.h"

@import CoreLocation;

@interface CityLocator ()
<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager * manager;

@property (strong, nonatomic) City * city;


@end

@implementation CityLocator

- (CLLocationManager *)manager
{
    if(!_manager)
    {
        
        _manager = [CLLocationManager new];
        [_manager requestWhenInUseAuthorization];
        _manager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _manager.delegate = self;
    }
    return _manager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * location = [locations lastObject];
    
    self.city.longitude = @(location.coordinate.longitude);
    self.city.latitude = @(location.coordinate.latitude);
    
    [self.manager stopUpdatingLocation];
    
    CLGeocoder * geoCoder = [CLGeocoder new];
    
    [geoCoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error)
    {
         CLPlacemark * pm = [placemarks lastObject];
        self.city.name = pm.locality;
    }];
    
    
}

- (void)LocalizeCity:(City *)city
{
    self.city = city;
    
    [self.manager startUpdatingLocation];
}

@end
