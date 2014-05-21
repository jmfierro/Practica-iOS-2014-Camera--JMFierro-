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
        _imagesFlickr = [[NSMutableDictionary alloc] init];
        _termsSearchesFlickr = [[NSMutableArray alloc] init];
        
        // Camara
        _imagesCamera = [[NSMutableArray alloc] init];
    }
    
    
    return self;
}


/*
-(id)initWithImage:(JMFImageCamera *) imageCamera {
    
    if (self = [self init]) {
        
        _imagesCamera = (id)imageCamera;
    }
    
    
    return self;
    
}
*/

/*
-(id)initWithFlickr:(FlickrPhoto *)imageFlickr {
    
    if (self = [self init]) {
        
         _imagesFlickr = (id)imageFlickr;
    }
    
    
    return self;
    
}
*/



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



-(UIImage *) imageCamera:(NSInteger *) item {
    
    JMFImageCamera *imageCamera = [self.imagesCamera objectAtIndex:(int)item];
    
    return imageCamera.image;
}

@end


