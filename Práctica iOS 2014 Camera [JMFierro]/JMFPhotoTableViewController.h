//
//  JMFTablePhotoViewController.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 08/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

@import CoreLocation;

#import <UIKit/UIKit.h>

#import "FlickrPhoto.h"
#import "JMFModel.h"
//#import "JMFMetaData.h"
//#import


@interface JMFPhotoTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>


@property (nonatomic, strong) JMFMetaData *metaData;
@property (nonatomic,strong) JMFCamera *imageCamera;
@property (nonatomic, strong) FlickrPhoto *imageFlickr;
@property (nonatomic, strong) UIImage *image, *imageThumbnail;


-(id) initWithImage:(UIImage *) image;
-(id) initWithImageCamera:(JMFCamera *) imageCamera;
-(id) initWithFlickrPhoto:(FlickrPhoto *)flickrPhoto;
//-(id) initWithModel:(JMFModel *)model andFlickr:(FlickrPhoto *)flickrPhoto;
//-(id) initWithModel:(JMFModel *)model andImage:(UIImage *) aImage;

@end
