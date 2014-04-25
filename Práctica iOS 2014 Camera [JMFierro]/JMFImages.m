//
//  JMFImages.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 24/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "JMFImages.h"

@implementation JMFImages

-(id) initWith {
    
    if (self = [self init]) {
        
        // Flickr
        self.photosSearchResultsFlickr = [[NSMutableDictionary alloc] init]; //[@{} mutableCopy];
        self.termsSearchesFlickr = [[NSMutableArray alloc] init];  //[@[] mutableCopy];
        
        // Camara
        self.photosCamera = [[NSMutableArray alloc] init];
    }
    
    
    return self;
}


-(NSInteger) countSections{
    
//    NSInteger i = [self.photosCamera count]>0 ? 1:0;
    
    return [self.termsSearchesFlickr count] + 1;

}

-(NSInteger) countOfPhotosCamera {
    
    return [self.photosCamera count];
}

-(NSInteger) countOfPhotosFlickrSearchResults:(NSString *)termSearchFlickr {
 
    return [self.photosSearchResultsFlickr[termSearchFlickr] count];
}

@end
