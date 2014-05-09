//
//  JMFCoreViewController.m
//  EjemploCoreLocation
//
//  Created by José Manuel Fierro Conchouso on 21/02/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//



#import "JMFCoreViewController.h"

@interface JMFCoreViewController ()

@property (strong,nonatomic) CLLocationManager *manager;

@end

@implementation JMFCoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([CLLocationManager locationServicesEnabled]) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        self.manager.delegate = self;
     
        [self.manager startUpdatingLocation];
    }
}


-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.manager stopUpdatingLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapkit setMapType:MKMapTypeHybrid];
    self.mapkit.rotateEnabled = YES;
    self.mapkit.zoomEnabled = YES;
    self.mapkit.pitchEnabled = YES;
    self.mapkit.showsBuildings = YES;
    self.mapkit.showsUserLocation = YES;
    self.mapkit.delegate = self;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        MKPointAnnotation *chincheta = [[MKPointAnnotation alloc] init];
        chincheta.coordinate = CLLocationCoordinate2DMake(40.0f, -3.0f);
        chincheta.title = @"Chincheta";
        chincheta.subtitle = @"texto ejemplo";
        
        [self.mapkit addAnnotation:chincheta];
    });
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"Cambio de localizacion");
    
    CLLocation *lastLocation = [locations lastObject];
    self.latitud.text = [NSString stringWithFormat:@"%.4f", lastLocation.coordinate.latitude];
    self.Longitud.text = [NSString stringWithFormat:@"%.4f", lastLocation.coordinate.longitude];
    self.Altitud.text = [NSString stringWithFormat:@"%.4f", lastLocation.altitude];
}







-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
////    [mapView setRegion:MKCoordinateRegionMake(<#CLLocationCoordinate2D centerCoordinate#>, <#MKCoordinateSpan span#>)]
//    
//    CLGeocode *geocoder = [[CLGeocoder alloc]init];
//    CLLocation *userCLLocation = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
//    [geocoder reverseGeocodeLocation:userCLLocation completionHandler:^(NSArray *placemarks. NSError )]
    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    CLLocation *userCLLocation = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
//    __block JMFCoreViewController *weakSelf = self;
//    [geocoder reverseGeocodeLocation:userCLLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (placemarks.count > 0) {
//            CLPlacemark *info = [placemarks lastObject];
//            NSLog(@"Calle: %@", [[info addressDictionary] objectForKey:(NSString*)kABPersonAddressStreetKey]);
//            NSLog(@"Código postal: %@", [[info addressDictionary] objectForKey:(NSString*)kABPersonAddressZIPKey]);
//            NSLog(@"País: %@", [[info addressDictionary] objectForKey:(NSString*)kABPersonAddressCountryKey]);
//            weakSelf.reverseGeocoding.text = [[info addressDictionary] objectForKey:(NSString*)kABPersonAddressCountryKey];
//        }
//    }];
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pines"];
    
    pin.pinColor = MKPinAnnotationColorGreen;
    pin.animatesDrop = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    return pin;
    
    
}

@end
