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
        self.imagesFlickr = [[NSMutableDictionary alloc] init]; //[@{} mutableCopy];
        self.termsSearchesFlickr = [[NSMutableArray alloc] init];  //[@[] mutableCopy];
        
        // Camara
//        self.photosCamera = [[NSMutableArray alloc] init];
        self.imagesCamera = [[NSMutableArray alloc] init];
    }
    
    
    return self;
}

//+(id)modelResultsFromFlickr:(NSArray *)results {
//    
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    for (id result in results) {
//        JMFModel *imagenData = [[JMFModel alloc] init];
//        imagenData.flickrPhoto = result;
//        [array addObject:[[JMFModel alloc]initWithFlickr:result]];
//        //                    [model addObject:[JMFModel;
//    }
//    
//    return array;
//}


-(id)initWithImage:(JMFCamera *) imageCamera {
    
    if (self = [self init]) {
        
        //        _flickrPhoto = flickr;
        _imagesCamera = imageCamera;
    }
    
    
    return self;
    
}


-(id)initWithFlickr:(FlickrPhoto *)imageFlickr {
    
    if (self = [self init]) {
        
//        _flickrPhoto = flickr;
         _imagesFlickr = imageFlickr;
    }
    
    
    return self;
    
}




-(NSInteger) countTotal {
    
    NSInteger numImagesFlickr = 0;
    for (NSString *termSearch in self.termsSearchesFlickr) {
        numImagesFlickr += [[self.imagesFlickr objectForKey:termSearch] count];
    }
    
//    return [self.photosCamera count] + numImagesFlickr;
    return [self.imagesCamera count] + numImagesFlickr;

}


-(NSInteger) countSections{
    
//    NSInteger i = [self.photosCamera count]>0 ? 1:0;
    
    return [self.termsSearchesFlickr count] + 1;

}

/*...........................................
 *
 * Número de imagenes tomadas con la cacara.
 *
 ............................................*/
-(NSInteger) countOfPhotosCamera {
    
//    return [self.photosCamera count];
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
