//
//  Uitils.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 12/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "Utils.h"

@implementation Utils


/*..........................................................................
 *
 * Devuelve un thumbnail de la imagen, adaptando al tamaño de un contenedor.
 *
 ............................................................................*/
+(UIImage *) imageToThumbnail:(UIImage *)image Size:(CGSize )aDestinationSize {
    
    CGSize destinationSize = [self imageAdapterSize:image containerSize:aDestinationSize];
    
    UIImage *originalImage = image;
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *thumbanail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbanail;
}

+(CGSize) scaleFactor:(UIImage *)image widthNewFrame:(CGFloat)frame {
    /*
     * Escala thumbail.
     */
    float scaleFactor = image.size.height / image.size.width;
    
    CGSize size;
    size.width = frame;
    size.height = frame * scaleFactor;
    
    return size;
}

/*......................................................................
 *
 * Devuelve el tamaño de la imagen adaptada al tamaño de un contenedor.
 *
 .......................................................................*/
+(CGSize) imageAdapterSize:(UIImage *)image containerSize:(CGSize)contentSize {
    
    CGFloat scaleFactor = image.size.width/image.size.height;
    
    /*                  **
     *  Imagen Portrait.
     *                  **/
    if (image.size.height > image.size.width)
        //                _image = [self imageToThumbnail:image Size:CGSizeMake(cellImage_ImageViewHeight/scaleFactor, cellImage_ImageViewHeight)];
        return CGSizeMake(contentSize.height*scaleFactor, contentSize.height);
    
    /*                  **
     * Imagen Ladscape.
     *                  **/
    else
        return CGSizeMake(contentSize.width, contentSize.width/scaleFactor);
    
    
}


/*...........................................
 *
 * Aplica un filtro recibidos en nameFilter.
 *
 ............................................*/
+(UIImage *) filterOverImage:(UIImage *)aImage nameFilter:(NSString *)nameFilter {
    
    UIImage *image = aImage;
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    CIFilter *ciFilter = [CIFilter filterWithName:nameFilter];
    [ciFilter setValue:ciImage forKey:kCIInputImageKey];
    
    [ciFilter setDefaults];
    
    CIImage *outputCiImage = [ciFilter outputImage];
    
    
    
    /* ------------------------------------------------------------------------------------------
     *
     * Utiliza CIContext para aumentar el rendimiento:
     *
     *    El uso del método 'UIImage' con 'imageWithCIImage' crea un nuevo CIContext cada vez,
     * y si se usa un 'slider' para actualizar los valores del filtro lo haría demasiado lento.
     *
     -------------------------------------------------------------------------------------------*/
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage =
    [context createCGImage:outputCiImage fromRect:[outputCiImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
    return newImage;
    
}


/*...................................................................
 *
 * Aplica una lista de filtros contenidos en el array namesFilter.
 *
 ...................................................................*/
+(UIImage *) filterOverImage:(UIImage *)aImage namesFilter:(NSArray *)namesFilter {
    
    if ([namesFilter count] == 0)
        return aImage;
    
    
    UIImage *image = aImage;
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    CIFilter *ciFilterBefore; // = [[CIFilter alloc] init];
    CIFilter *ciFilter;
    
    for (id nameFilter in namesFilter) {
        
        if (!ciFilterBefore)
            ciImage = [[CIImage alloc] initWithImage:image];
        else
            ciImage = ciFilterBefore.outputImage;
        
        ciFilter = [CIFilter filterWithName:nameFilter];
        [ciFilter setValue:ciImage forKey:kCIInputImageKey];
        [ciFilter setDefaults];
        
        ciFilterBefore = ciFilter;
    }
    
    CIImage *outputCiImage = [ciFilter outputImage];
    
    
    
    /*
     // 1
     CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];
     [sepia setValue:ciImage forKey:kCIInputImageKey];
     [sepia setValue:@(0) forKey:@"inputIntensity"];
     
     // 2
     CIFilter *random = [CIFilter filterWithName:@"CIRandomGenerator"];
     
     // 3
     CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
     [lighten setValue:random.outputImage forKey:kCIInputImageKey];
     [lighten setValue:@(1 - 0.8) forKey:@"inputBrightness"];
     [lighten setValue:@0.0 forKey:@"inputSaturation"];
     
     // 4
     CIImage *beginImage;
     CIImage *croppedImage = [lighten.outputImage imageByCroppingToRect:[beginImage extent]];
     
     // 5
     CIFilter *composite = [CIFilter filterWithName:@"CIHardLightBlendMode"];
     [composite setValue:sepia.outputImage forKey:kCIInputImageKey];
     [composite setValue:croppedImage forKey:kCIInputBackgroundImageKey];
     
     // 6
     CIFilter *vignette = [CIFilter filterWithName:@"CIVignette"];
     [vignette setValue:composite.outputImage forKey:kCIInputImageKey];
     [vignette setValue:@(0.8 * 2) forKey:@"inputIntensity"];
     [vignette setValue:@(0.8 * 30) forKey:@"inputRadius"];
     
     CIImage *outputCiImage = [vignette outputImage];
     */
    
    /* ------------------------------------------------------------------------------------------
     *
     * Utiliza CIContext para aumentar el rendimiento:
     *
     *    El uso del método 'UIImage' con 'imageWithCIImage' crea un nuevo CIContext cada vez,
     * y si se usa un 'slider' para actualizar los valores del filtro lo haría demasiado lento.
     *
     -------------------------------------------------------------------------------------------*/
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage =
    [context createCGImage:outputCiImage fromRect:[outputCiImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
    return newImage;
    
}

@end
