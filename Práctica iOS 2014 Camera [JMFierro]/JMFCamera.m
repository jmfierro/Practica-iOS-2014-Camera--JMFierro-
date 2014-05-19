//
//  JMFCamera.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 19/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

@import CoreLocation;

#import "JMFCamera.h"
#import "JMFMetaData.h"
//#import "JMFLocation.h"

@interface JMFCamera () {
    CLLocationManager *managerLocation;
}
@end


@implementation JMFCamera

-(id) initWithImage:(UIImage *)image {
    
    if (self = [super init]) {
    
        _image = image;
        _metaData = [[JMFMetaData alloc] initWithImage:image];
        
//        JMFLocation *location = [[JMFLocation alloc] init];
//        location.lastLocation
        
        // Localización
 
        if ([CLLocationManager locationServicesEnabled]) {
            managerLocation = [[CLLocationManager alloc] init];
            managerLocation.desiredAccuracy = kCLLocationAccuracyBest;
            managerLocation.delegate = self;
            
            [managerLocation startUpdatingLocation];
        }


    }
    
    return self;
}


#pragma mark - Loaction Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"Cambio de localizacion (JMFCamera.m)");
    
    CLLocation *lastLocation = [locations lastObject];
    self.latitude = lastLocation.coordinate.latitude;
    self.longitude = lastLocation.coordinate.longitude;
    
    [managerLocation stopUpdatingLocation];
}


@end
