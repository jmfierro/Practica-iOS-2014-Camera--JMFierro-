//
//  JMFMetaDataModel.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 09/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>


#import "JMFMetaData.h"
//#import <CoreLocation/CoreLocation.h>


@implementation JMFMetaData

-(id) init {
    
    if (self = [super init]) {
        
        _allMetaData = [[NSDictionary alloc] init];
 
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
        [self loadModel:image metaData:nil Location:nil];
    }
    
    return  self;
}


-(id) initWithImage:(UIImage *)image metaData:(NSDictionary *)metaData Location:(CLLocation *)location {
    
    if (self = [super init]) {
        [self loadModel:image metaData:metaData Location:location];
    }
    return self;
    
}


-(void) loadModel:(UIImage *)image metaData:(NSDictionary *)metaData Location:(CLLocation *)location {
    
    self.allMetaData = [JMFMetaData metaDataImage:image];
    
    // Actualiza modelo con los metadatos por item.
    self.EXIFDictionary = [self.allMetaData objectForKey:(NSString *)kCGImagePropertyExifDictionary];
    self.JFIFDictionary = [self.allMetaData objectForKey:(NSString *)kCGImagePropertyJFIFDictionary];
    self.GPSDictionary = [self.allMetaData objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
    self.TIFFDictionary = [self.allMetaData objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
    self.RAWDictionary = [self.allMetaData objectForKey:(NSString *)kCGImagePropertyRawDictionary];
    self.JPEGDictionary = [self.allMetaData objectForKey:(NSString *)kCGImagePropertyJFIFDictionary];
    self.GIFDictionary = [self.allMetaData objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    
    /* ------------------
     *  Añade datos GPS
     --------------------*/
    if (location) {
        [JMFMetaData addMetaData:image metaData:self.allMetaData location:location];
    }
    
    
    /*
     // Añade los items que faltan
     
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


/*..................................................
 *
 * Devuelve los 'MetaDatos' obtenidos de una imagen.
 *
 ...................................................*/
+(NSDictionary *) metaDataImage:(UIImage *) image {

    NSData *imgData = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imgData, NULL);
    
    NSDictionary* metadata = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source,0,NULL));
    
    return metadata;
}


+(UIImage *)addMetaData:(UIImage *)image metaData:(NSDictionary *)metaData location:(CLLocation *) location {
    

    NSMutableDictionary *imageMetaDataDestination = [[self metaDataImage:image] mutableCopy];
    
    for (id key in [metaData allKeys]) {
        [imageMetaDataDestination setValue:[metaData objectForKey:key] forKey:key];
    }

    
    /* ------------------
     *  Añade datos GPS
     --------------------*/
    if(location) {
        NSDictionary *GPSDictionary = [JMFMetaData gpsDictionaryForLocation:location];
        [imageMetaDataDestination setObject:GPSDictionary forKey:kCGImagePropertyGPSDictionary];
    }
    

    // Obtener metadatos.
    NSMutableDictionary *metadataAsMutable = [imageMetaDataDestination mutableCopy];
    
    
    // Añadir metadatos.
    NSData *imagenData = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imagenData, NULL);
    CFStringRef UTI = CGImageSourceGetType(source);
    NSMutableData *dest_data = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)dest_data,UTI,1,NULL);
    CGImageDestinationAddImageFromSource(destination,source,0, (__bridge CFDictionaryRef) metadataAsMutable);
    
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);
    if(!success) {
        NSLog(@"Error: No se puedo crear data desde imagen destino");
    }
    
//    [dest_data writeToFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"test.png"]
//           atomically:YES];
    
//    [dest_data writeToFile:file atomically:YES];
    
    CFRelease(destination);
    CFRelease(source);
    
    UIImage *imgWithNewMetaData = [UIImage imageWithData:dest_data];
    
    NSDictionary *modelMetadata = [self metaDataImage:imgWithNewMetaData];
    return imgWithNewMetaData;
    
}


+(NSDictionary *) gpsDictionaryForLocation:(CLLocation *)location {
    CLLocationDegrees exifLatitude  = location.coordinate.latitude;
    CLLocationDegrees exifLongitude = location.coordinate.longitude;
    
    NSString * latRef;
    NSString * longRef;
    if (exifLatitude < 0.0) {
        exifLatitude = exifLatitude * -1.0f;
        latRef = @"S";
    } else {
        latRef = @"N";
    }
    
    if (exifLongitude < 0.0) {
        exifLongitude = exifLongitude * -1.0f;
        longRef = @"W";
    } else {
        longRef = @"E";
    }
    
    NSMutableDictionary *locDict = [[NSMutableDictionary alloc] init];
    
    [locDict setObject:location.timestamp forKey:(NSString*)kCGImagePropertyGPSTimeStamp];
    [locDict setObject:latRef forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    [locDict setObject:[NSNumber numberWithFloat:exifLatitude] forKey:(NSString *)kCGImagePropertyGPSLatitude];
    [locDict setObject:longRef forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    [locDict setObject:[NSNumber numberWithFloat:exifLongitude] forKey:(NSString *)kCGImagePropertyGPSLongitude];
    [locDict setObject:[NSNumber numberWithFloat:location.horizontalAccuracy] forKey:(NSString*)kCGImagePropertyGPSDOP];
    [locDict setObject:[NSNumber numberWithFloat:location.altitude] forKey:(NSString*)kCGImagePropertyGPSAltitude];
    
    return locDict;
    
}

@end
