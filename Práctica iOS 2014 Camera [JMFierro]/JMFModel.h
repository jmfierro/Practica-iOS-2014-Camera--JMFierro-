//
//  JMFModel.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 24/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMFCamera.h"
#import "JMFMetaData.h"
#import "FlickrPhoto.h"

@interface JMFModel : NSObject


// Camara
@property (nonatomic, strong) NSMutableArray *imagesCamera;
//@property (nonatomic, strong) NSMutableArray *photosCamera;

// Flick
@property(nonatomic, strong) NSMutableDictionary *imagesFlickr; //*photosSearchResultsFlickr;
@property(nonatomic, strong) NSMutableArray *termsSearchesFlickr;
//@property (nonatomic, strong) FlickrPhoto *modelFlickrPhoto;



-(id)initWith;
-(id)initWithImage:(JMFCamera *) imageCamera;
-(id)initWithFlickr:(FlickrPhoto *) imageFlickr;


//+(id)modelResultsFromFlickr:(NSArray *)results;

-(NSInteger) countTotal;
-(NSInteger) countSections;
-(NSInteger) countOfPhotosCamera;
-(NSInteger) countOfPhotosFlickrSearchResults:(NSString *)termSearchFlickr;

@end
