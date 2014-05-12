//
//  JMFLocationViewController.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 08/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

@import CoreLocation;
@import MapKit;

#import <UIKit/UIKit.h>

@protocol JMFLocationViewControllerDelegate

-(void) setInfoGeocoder:(CLPlacemark *)aInfo;
-(void) setLastLocation:(CLLocation *)aLastLocation;

@end

@interface JMFLocationViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate> {
    
    id delegate;
    
}

@property (nonatomic,retain) id<JMFLocationViewControllerDelegate> delegate;

@property (nonatomic,strong) CLPlacemark *infoGeocoder;
@property (nonatomic,strong) CLLocation *lastLocation;

@property (weak, nonatomic) IBOutlet UILabel *latitud;
@property (weak, nonatomic) IBOutlet UILabel *Longitud;
@property (weak, nonatomic) IBOutlet UILabel *Altitud;
@property (weak, nonatomic) IBOutlet MKMapView *mapkit;

-(id) initWithMapView:(MKMapView *) mapView;


@end