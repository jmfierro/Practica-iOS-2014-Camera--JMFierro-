//
//  JMFModel.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 24/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMFMetaData.h"
#import "JMFImageCamera.h"
#import "ImageFlickr.h"

@interface JMFModel : NSObject


// Camara
@property (nonatomic, strong) NSMutableArray *imagesCamera;


// Flick
@property(nonatomic, strong) NSMutableDictionary *imagesFlickr;
@property(nonatomic, strong) NSMutableArray *termsSearchesFlickr;




-(id)initWith;
//-(id)initWithImage:(JMFImageCamera *) imageCamera;
//-(id)initWithFlickr:(FlickrPhoto *) imageFlickr;


-(NSInteger) countTotal;
-(NSInteger) countSections;
-(NSInteger) countOfPhotosCamera;
-(NSInteger) countOfPhotosFlickrSearchResults:(NSString *)termSearchFlickr;

-(UIImage *) imageCamera:(NSInteger *) item;

@end
