//
//  JMFTablePhotoViewController.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 08/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

@import CoreLocation;

#import <UIKit/UIKit.h>

#import "JMFModel.h"
#import "JMFImageCamera.h"
#import "ImageFlickr.h"

#define kJMFTablePhotoViewControlle @"facesRects"


@interface JMFImageTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>


@property (nonatomic, strong) JMFMetaData *metaData;
@property (nonatomic,strong) JMFImageCamera *imageCamera;
@property (nonatomic, strong) ImageFlickr *imageFlickr;
@property (nonatomic, strong) UIImage *image, *imageThumbnail;


-(id) initWithImage:(JMFImageCamera *) image;
-(id) initWithImageCamera:(JMFImageCamera *) imageCamera;
-(id) initWithFlickrPhoto:(ImageFlickr *)flickrPhoto;


@end
