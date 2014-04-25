//
//  JMFImages.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 24/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMFImages : NSObject

// Flick
@property(nonatomic, strong) NSMutableDictionary *photosSearchResultsFlickr;
@property(nonatomic, strong) NSMutableArray *termsSearchesFlickr;

// Camara
@property (nonatomic, strong) NSMutableArray *photosCamera;

-(id)initWith;

-(NSInteger) countSections;
-(NSInteger) countOfPhotosCamera;
-(NSInteger) countOfPhotosFlickrSearchResults:(NSString *)termSearchFlickr;

@end
