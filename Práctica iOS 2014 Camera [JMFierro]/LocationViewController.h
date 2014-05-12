//
//  LocationViewController.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 08/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@interface LocationViewController : UIViewController

@property (nonatomic,strong) UIView *viewMap;
@property (nonatomic,strong) MKMapView *mapView;

-(id) initWithViewMap:(UIView *) viewMap;

- (void)viewDidLoad;

@end
