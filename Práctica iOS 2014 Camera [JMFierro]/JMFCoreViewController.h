//
//  JMFCoreViewController.h
//  EjemploCoreLocation
//
//  Created by José Manuel Fierro Conchouso on 21/02/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

@import CoreLocation;
@import MapKit;

#import <UIKit/UIKit.h>

@interface JMFCoreViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *latitud;
@property (weak, nonatomic) IBOutlet UILabel *Longitud;
@property (weak, nonatomic) IBOutlet UILabel *Altitud;
@property (weak, nonatomic) IBOutlet MKMapView *mapkit;

@end
