//
//  JMFLocation.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 13/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "JMFLocation.h"

@interface JMFLocation ()

@property (strong,nonatomic) CLLocationManager *manager;

@end

@implementation JMFLocation


- (id)init {
    self = [super init];
    if (self) {
        if ([CLLocationManager locationServicesEnabled]) {
            self.manager = [[CLLocationManager alloc] init];
            self.manager.desiredAccuracy = kCLLocationAccuracyBest;
            self.manager.delegate = self;
            
            [self.manager startUpdatingLocation];
        }
    }
    return self;
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"Cambio de localizacion (JMFLocationViewController.m)");
    
    CLLocation *lastLocation = [locations lastObject];
    
    [self.manager stopUpdatingLocation];
}


@end
