//
//  JMFModel.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 24/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "JMFModel.h"

@implementation JMFModel

-(id) initWith {
    
    if (self = [self init]) {
        
        // Flickr
        self.imagesFlickr = [[NSMutableDictionary alloc] init];
        self.termsSearchesFlickr = [[NSMutableArray alloc] init];
        
        // Camara
        self.imagesCamera = [[NSMutableArray alloc] init];
    }
    
    
    return self;
}



-(id)initWithImage:(JMFCamera *) imageCamera {
    
    if (self = [self init]) {
        
        //        _flickrPhoto = flickr;
        _imagesCamera = (id)imageCamera;
    }
    
    
    return self;
    
}


-(id)initWithFlickr:(FlickrPhoto *)imageFlickr {
    
    if (self = [self init]) {
        
         _imagesFlickr = (id)imageFlickr;
    }
    
    
    return self;
    
}




-(NSInteger) countTotal {
    
    NSInteger numImagesFlickr = 0;
    for (NSString *termSearch in self.termsSearchesFlickr) {
        numImagesFlickr += [[self.imagesFlickr objectForKey:termSearch] count];
    }
    
    return [self.imagesCamera count] + numImagesFlickr;

}


-(NSInteger) countSections{
    
   
    return [self.termsSearchesFlickr count] + 1;

}



/*...........................................
 *
 * Número de imagenes tomadas con la cacara.
 *
 ............................................*/
-(NSInteger) countOfPhotosCamera {
    
    return [self.imagesCamera count];
}


/*...........................................
 *
 * Número de imagenes bajadas de Flickr.
 *
 ............................................*/
-(NSInteger) countOfPhotosFlickrSearchResults:(NSString *)termSearchFlickr {
 
    return [self.imagesFlickr[termSearchFlickr] count];
}

@end
