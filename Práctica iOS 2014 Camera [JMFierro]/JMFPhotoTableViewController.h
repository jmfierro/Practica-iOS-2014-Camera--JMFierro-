//
//  JMFTablePhotoViewController.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 08/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhoto.h"


@interface JMFPhotoTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) FlickrPhoto *flickrPhoto;
@property (nonatomic, strong) UIImage *image;


-(id) initWithFlickrPhoto:(FlickrPhoto *)flickrPhoto;
-(id) initWithImage:(UIImage *) image;

@end
