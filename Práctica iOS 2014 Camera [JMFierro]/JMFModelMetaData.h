//
//  JMFMetaDataModel.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 09/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMFModelMetaData : NSObject

@property (nonatomic, strong) NSDictionary *metaDataAll;

@property (nonatomic,strong) NSDictionary *EXIFDictionary;
@property (nonatomic,strong) NSDictionary *GPSDictionary;
@property (nonatomic,strong) NSDictionary *TIFFDictionary;
@property (nonatomic,strong) NSDictionary *RAWDictionary;
@property (nonatomic,strong) NSDictionary *JPEGDictionary;
@property (nonatomic,strong) NSDictionary *GIFDictionary;

/* ** SALIDA DE METADATOS **
{
    ColorModel = RGB;
    Depth = 8;
    Orientation = 1;
    PixelHeight = 655;
    PixelWidth = 1089;
    "{Exif}" =     {
        ColorSpace = 1;
        PixelXDimension = 1089;
        PixelYDimension = 655;
    };
    "{GIF}" =     {
    };
    "{GPS}" =     {
    };
    "{JFIF}" =     {
        DensityUnit = 0;
        JFIFVersion =         (
                               1,
                               1
                               );
        XDensity = 1;
        YDensity = 1;
    };
    "{Raw}" =     {
    };
    "{TIFF}" =     {
        Orientation = 1;
    };
}
 
*/

/*
Printing description of metadata:
{
    ColorModel = RGB;
    Depth = 8;
    Orientation = 6;
    PixelHeight = 1936;
    PixelWidth = 2592;
    "{Exif}" =     {
        ColorSpace = 1;
        PixelXDimension = 2592;
        PixelYDimension = 1936;
    };
    "{JFIF}" =     {
        DensityUnit = 0;
        JFIFVersion =         (
                               1,
                               1
                               );
        XDensity = 1;
        YDensity = 1;
    };
    "{TIFF}" =     {
        Orientation = 6;
    };
}
 */

-(id) init;
-(id) initWithImage:(UIImage *)image;

-(NSDictionary *) metaDataImage:(UIImage *) image;

@end
