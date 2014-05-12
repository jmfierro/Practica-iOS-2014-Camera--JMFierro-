//
//  JMFMetaData.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 09/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//



#import "JMFMetaData.h"



@implementation JMFMetaData

-(id) init {
    
    if (self = [super init]) {
//        _modelMetaData = [[JMFMetaDataModel alloc] init];
    }

    return self;
}


-(UIImage *)addMetaData:(UIImage *)aImage {
    
    UIImage *image = aImage;
    
    
    /*
     * Modelo
     */
    JMFMetaDataModel *modelMetadata = [[JMFMetaDataModel alloc] initWithImage:image];
    
    /*
     * Controlador
     */
    
    // Obtención de metadatos
    NSDictionary *metadataAsMutable = [modelMetadata.metaDataAll mutableCopy];
    
    // Añadir metadatos
    NSData *jpeg = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)jpeg, NULL);
    
    CFStringRef UTI = CGImageSourceGetType(source);
    
    NSMutableData *dest_data = [NSMutableData data];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)dest_data,UTI,1,NULL);
    
    //CGImageDestinationRef hello;
    
    CGImageDestinationAddImageFromSource(destination,source,0, (__bridge CFDictionaryRef) metadataAsMutable);
    
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);
    
    if(!success) {
    }
    
    //        dataToUpload_ = dest_data;
    
    CFRelease(destination);
    CFRelease(source);
    
    return image;
}


//-(UIImage *)addMetaData:(UIImage *)image {
//    
//    NSData *jpeg = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
//    
//    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)jpeg, NULL);
//    
//    NSDictionary* metadata = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source,0,NULL));
//    
//    //        NSData *jpeg = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
//    //
//    //        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)jpeg, NULL);
//    //
//    //        ALAsset *asset = [[ALAsset alloc] init];
//    //
//    //        NSDictionary *metadata = [[asset defaultRepresentation] metadata];
//    
//    
//    NSMutableDictionary *metadataAsMutable = [metadata mutableCopy];
//    
//    
////    NSMutableDictionary *EXIFDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyExifDictionary];
////    NSMutableDictionary *GPSDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
////    NSMutableDictionary *TIFFDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
////    NSMutableDictionary *RAWDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyRawDictionary];
////    NSMutableDictionary *JPEGDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyJFIFDictionary];
////    NSMutableDictionary *GIFDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
//
//    
//    NSDictionary *EXIFDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyExifDictionary];
//    NSDictionary *GPSDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
//    NSDictionary *TIFFDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
//    NSDictionary *RAWDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyRawDictionary];
//    NSDictionary *JPEGDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyJFIFDictionary];
//    NSDictionary *GIFDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
//
////    JMFMetaDataModel *modelMetaDatas = [[JMFMetaDataModel alloc] init];
//    
////    modelMetaDatas.EXIFDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyExifDictionary];
////    modelMetaDatas.GPSDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
////    modelMetaDatas.TIFFDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
////    modelMetaDatas.RAWDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyRawDictionary];
////    modelMetaDatas.JPEGDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyJFIFDictionary];
////    modelMetaDatas.GIFDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
//    
//    
//    
//    if(!EXIFDictionary) {
//        self.modelMetaData.EXIFDictionary = [NSMutableDictionary dictionary];
//    }
//    
//    if(!GPSDictionary) {
//        self.modelMetaData.GPSDictionary = [NSMutableDictionary dictionary];
//    }
//    
//    if (!TIFFDictionary) {
//        self.modelMetaData.TIFFDictionary = [NSMutableDictionary dictionary];
//    }
//    
//    if (!RAWDictionary) {
//        self.modelMetaData.RAWDictionary = [NSMutableDictionary dictionary];
//    }
//    
//    if (!JPEGDictionary) {
//        self.modelMetaData.JPEGDictionary = [NSMutableDictionary dictionary];
//    }
//    
//    if (!GIFDictionary) {
//        self.modelMetaData.GIFDictionary = [NSMutableDictionary dictionary];
//    }
//    
//    
//    [metadataAsMutable setObject:EXIFDictionary forKey:(NSString *)kCGImagePropertyExifDictionary];
//    [metadataAsMutable setObject:GPSDictionary forKey:(NSString *)kCGImagePropertyGPSDictionary];
//    [metadataAsMutable setObject:TIFFDictionary forKey:(NSString *)kCGImagePropertyTIFFDictionary];
//    [metadataAsMutable setObject:RAWDictionary forKey:(NSString *)kCGImagePropertyRawDictionary];
//    [metadataAsMutable setObject:JPEGDictionary forKey:(NSString *)kCGImagePropertyJFIFDictionary];
//    [metadataAsMutable setObject:GIFDictionary forKey:(NSString *)kCGImagePropertyGIFDictionary];
//    
//    CFStringRef UTI = CGImageSourceGetType(source);
//    
//    NSMutableData *dest_data = [NSMutableData data];
//    
//    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)dest_data,UTI,1,NULL);
//    
//    //CGImageDestinationRef hello;
//    
//    CGImageDestinationAddImageFromSource(destination,source,0, (__bridge CFDictionaryRef) metadataAsMutable);
//    
//    BOOL success = NO;
//    success = CGImageDestinationFinalize(destination);
//    
//    if(!success) {
//    }
//    
//    //        dataToUpload_ = dest_data;
//    
//    CFRelease(destination);
//    CFRelease(source);
//    
//    return image;
//}

@end
