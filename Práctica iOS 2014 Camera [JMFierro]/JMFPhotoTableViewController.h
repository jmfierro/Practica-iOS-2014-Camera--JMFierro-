//
//  JMFTablePhotoViewController.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 08/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhotoModel.h"
#import "JMFMetaDataModel.h"


@interface JMFPhotoTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) JMFMetaDataModel *metaDataModel;
@property (nonatomic, strong) FlickrPhotoModel *flickrPhotoModel;
@property (nonatomic, strong) UIImage *image, *imageAplyFilters;


-(id) initWithFlickrPhoto:(FlickrPhotoModel *)flickrPhoto;
-(id) initWithImage:(UIImage *) aImage;

@end
