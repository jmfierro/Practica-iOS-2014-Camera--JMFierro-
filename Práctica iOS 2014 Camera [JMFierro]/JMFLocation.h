//
//  JMFLocation.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 13/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//
@import CoreLocation;

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

//@interface JMFLocation : UIViewController <CLLocationManagerDelegate>
@interface JMFLocation : NSObject <CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocation *lastLocation;

-(id)init;
@end
