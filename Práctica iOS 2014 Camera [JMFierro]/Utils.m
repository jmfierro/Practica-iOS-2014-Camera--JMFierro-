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


@end
