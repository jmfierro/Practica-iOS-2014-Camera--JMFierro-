//
//  JMFTablePhotoViewController.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 08/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

@import CoreLocation;

#import <UIKit/UIKit.h>
#import "ModelFlickrPhoto.h"
#import "JMFModelMetaData.h"
//#import 	


@interface JMFPhotoTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>


@property (nonatomic, strong) JMFModelMetaData *modelMetaData;
@property (nonatomic, strong) ModelFlickrPhoto *modelFlickrPhoto;
@property (nonatomic, strong) UIImage *image, *imageAplyFilters, *imageThumbnail;



-(id) initWithFlickrPhoto:(ModelFlickrPhoto *)flickrPhoto;
-(id) initWithImage:(UIImage *) aImage;

@end
