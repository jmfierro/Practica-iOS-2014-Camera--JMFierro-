//
//  JMFMetaDataModel.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 09/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <ImageIO/ImageIO.h>

#import "JMFModelMetaData.h"


@implementation JMFModelMetaData

-(id) init {
    
    if (self = [super init]) {
        
        _metaDataAll = [[NSDictionary alloc] init];
 
        _EXIFDictionary = [[NSDictionary alloc] init];
        _JFIFDictionary = [[NSDictionary alloc] init];
        _GPSDictionary = [[NSDictionary alloc] init];
        _TIFFDictionary = [[NSDictionary alloc] init];
        _RAWDictionary = [[NSDictionary alloc] init];
        _JPEGDictionary = [[NSDictionary alloc] init];
        _GIFDictionary = [[NSDictionary alloc] init];
        
    }
    
    return self;
}



-(id) initWithImage:(UIImage *)image {
    
    if (self = [super init]) {
        
       
        self.metaDataAll = [self metaDataImage:image];
        
 
        self.EXIFDictionary = [self.metaDataAll objectForKey:(NSString *)kCGImagePropertyExifDictionary];
        self.JFIFDictionary = [self.metaDataAll objectForKey:(NSString *)kCGImagePropertyJFIFDictionary];
        self.GPSDictionary = [self.metaDataAll objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
        self.TIFFDictionary = [self.metaDataAll objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
        self.RAWDictionary = [self.metaDataAll objectForKey:(NSString *)kCGImagePropertyRawDictionary];
        self.JPEGDictionary = [self.metaDataAll objectForKey:(NSString *)kCGImagePropertyJFIFDictionary];
        self.GIFDictionary = [self.metaDataAll objectForKey:(NSString *)kCGImagePropertyGIFDictionary];

/*
        NSDictionary *EXIFDictionary = [self.metaDataAll objectForKey:(NSString *)kCGImagePropertyExifDictionary];
        NSDictionary *GPSDictionary = [self.metaDataAll objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
        NSDictionary *TIFFDictionary = [self.metaDataAll objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
        NSDictionary *RAWDictionary = [self.metaDataAll objectForKey:(NSString *)kCGImagePropertyRawDictionary];
        NSDictionary *JPEGDictionary = [self.metaDataAll objectForKey:(NSString *)kCGImagePropertyJFIFDictionary];
        NSDictionary *GIFDictionary = [self.metaDataAll objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
        

        // Rellena con datos el modelo.
        if(!EXIFDictionary)
            self.EXIFDictionary = [NSDictionary dictionary];
        else
            self.EXIFDictionary = EXIFDictionary;
        
        if(!GPSDictionary)
            self.GPSDictionary = [NSDictionary dictionary];
        else
            self.GPSDictionary = GPSDictionary;
        
        
        if (!TIFFDictionary)
            self.TIFFDictionary = [NSDictionary dictionary];
        else
            self.TIFFDictionary = TIFFDictionary;
        
        
        if (!RAWDictionary)
            self.RAWDictionary = [NSDictionary dictionary];
        else
            self.RAWDictionary = RAWDictionary;
        
        
        if (!JPEGDictionary)
            self.JPEGDictionary = [NSDictionary dictionary];
        else
            self.JPEGDictionary = JPEGDictionary;
        
        
        if (!GIFDictionary)
            self.GIFDictionary = [NSDictionary dictionary];
        else
            self.GIFDictionary = GIFDictionary;
 
 */
        
        
    }
    return self;
    
}


-(NSDictionary *) metaDataImage:(UIImage *) image {
    
    NSData *jpeg = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)jpeg, NULL);
    
    NSDictionary* metadata = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source,0,NULL));
    
    return metadata;
}


@end
