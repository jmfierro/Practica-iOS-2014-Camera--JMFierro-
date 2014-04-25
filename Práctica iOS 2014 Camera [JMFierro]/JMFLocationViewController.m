//
//  JMFLocationViewController.m
//  Práctica iOS 2014 Camera [JMFierro]

//
//  Created by José Manuel Fierro Conchouso on 21/02/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//


#import "JMFLocationViewController.h"

@interface JMFLocationViewController ()

@property (strong,nonatomic) CLLocationManager *manager;

@end

@implementation JMFLocationViewController


@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

-(id) initWithMapView:(MKMapView *)mapView {
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        /*--------------------------------------------------------
         *
         *  Localización
         *
         ---------------------------------------------------------*/
        if ([CLLocationManager locationServicesEnabled]) {
            self.manager = [[CLLocationManager alloc] init];
            self.manager.desiredAccuracy = kCLLocationAccuracyBest;
            self.manager.delegate = self;
            
//            [self.manager startUpdatingLocation];

            
            [self.manager setDistanceFilter:kCLDistanceFilterNone];
      

        }

        
        /*--------------------------------------------------------
         *
         *  Mapa
         *
         ---------------------------------------------------------*/
        self.mapkit = mapView;
        
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
            chincheta.coordinate = CLLocationCoordinate2DMake(40.4133967f, -3.694118f);
            chincheta.title = @"Chincheta";
            chincheta.subtitle = @"texto ejemplo";
            
            [self.mapkit addAnnotation:chincheta];
        });
        

        
    }
                
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if ([CLLocationManager locationServicesEnabled]) {
//        self.manager = [[CLLocationManager alloc] init];
//        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
//        self.manager.delegate = self;
//     
//        [self.manager startUpdatingLocation];
//    }
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
        chincheta.coordinate = CLLocationCoordinate2DMake(45.0f, -3.0f);
        chincheta.title = @"Chincheta";
        chincheta.subtitle = @"texto ejemplo";
        
        [self.mapkit addAnnotation:chincheta];
    });
    
    [self.manager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
//    [mapView setRegion:MKCoordinateRegionMake(<#CLLocationCoordinate2D centerCoordinate#>, <#MKCoordinateSpan span#>)]
    
    
//    CLGeocoder *geocoder2 = [[CLGeocoder alloc] init];
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
//    [geocoder2 reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        NSLog(@"Finding address");
//        if (error) {
//            NSLog(@"Error %@", error.description);
//        } else {
//            CLPlacemark *placemark = [placemarks lastObject];
//            self.myAddress.text = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
//        }
//    }];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *userCLLocation = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
//    [geocoder reverseGeocodeLocation:userCLLocation completionHandler:^(NSArray *placemarks. NSError )];
    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    CLLocation *userCLLocation = [[CLLocation alloc] itWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    __block JMFLocationViewController *weakSelf = self;
    [geocoder reverseGeocodeLocation:userCLLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                CLPlacemark *info = [placemarks lastObject];
//                [self.delegate setInfoGeocoder:info];
//            });

            CLPlacemark *info = [placemarks lastObject];
            self.infoGeocoder = [placemarks lastObject];
            [self.delegate setInfoGeocoder:info];
            
            /* -----------------------------------------------------------------------
             *
             *
             (lldb) po [info.addressDictionary allKeys]
             <__NSArrayI 0x16edd270>(
             FormattedAddressLines,
             Street,
             SubAdministrativeArea,
             Thoroughfare,
             ZIP,
             Name,
             City,
             Country,
             State,
             SubThoroughfare,
             CountryCode
             )
             
             Rdo:
             2014-04-14 17:06:28.412 Práctica iOS 2014 Camera [JMFierro][332:60b] Calle: (
             "Calle de la Playa de Fuengirola 2",
             "28290 Punta Galea",
             "Madrid, Espa\U00f1a"
             )
             2014-04-14 17:06:28.413 Práctica iOS 2014 Camera [JMFierro][332:60b] Código postal: Calle de la Playa de Fuengirola 2
             2014-04-14 17:06:28.414 Práctica iOS 2014 Camera [JMFierro][332:60b] País: (null)
             *
             *
             -----------------------------------------------------------------------*/
            
//            NSLog(@"Calle: %@", [[info addressDictionary] objectForKey:(NSString*)kABPersonAddressStreetKey]);
//            NSLog(@"Código postal: %@", [[info addressDictionary] objectForKey:(NSString*)kABPersonAddressZIPKey]);
//            NSLog(@"País: %@", [[info addressDictionary] objectForKey:(NSString*)kABPersonAddressCountryKey]);
 
            NSLog(@"FormattedAddressLines: %@", [[info addressDictionary] objectForKey:(NSString*)@"FormattedAddressLines"]);
            NSLog(@"Street: %@", [[info addressDictionary] objectForKey:(NSString*)@"Street"]);
            NSLog(@"SubAdministrativeArea: %@", [[info addressDictionary] objectForKey:(NSString*)@"Thoroughfare"]);
            NSLog(@"Thoroughfare: %@", [[info addressDictionary] objectForKey:(NSString*)@"Country"]);
            NSLog(@"ZIP: %@", [[info addressDictionary] objectForKey:(NSString*)@"ZIP"]);
            NSLog(@"Name: %@", [[info addressDictionary] objectForKey:(NSString*)@"Name"]);
            NSLog(@"City: %@", [[info addressDictionary] objectForKey:(NSString*)@"City"]);
            NSLog(@"Country: %@", [[info addressDictionary] objectForKey:(NSString*)@"Country"]);
            NSLog(@"State: %@", [[info addressDictionary] objectForKey:(NSString*)@"State"]);
            NSLog(@"SubThoroughfare: %@", [[info addressDictionary] objectForKey:(NSString*)@"SubThoroughfare"]);
            NSLog(@"CountryCode: %@", [[info addressDictionary] objectForKey:(NSString*)@"CountryCode"]);
            

//            weakSelf.reverseGeocoding.text = [[info addressDictionary] objectForKey:(NSString*)@"kABPersonAddressCountryKey"];
        }
    }];
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pines"];
    
    pin.pinColor = MKPinAnnotationColorGreen;
    pin.animatesDrop = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    return pin;
    
    
}


@end
