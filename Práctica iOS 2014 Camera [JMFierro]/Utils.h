//
//  Uitils.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 12/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject


/*..........................................................................
 *
 * Devuelve un thumbnail de la imagen, adaptando al tamaño de un contenedor.
 *
 ............................................................................*/
+(UIImage *) imageToThumbnail:(UIImage *)image Size:(CGSize )aDestinationSize;

+(CGSize) scaleFactor:(UIImage *)image widthNewFrame:(CGFloat)frame;

/*......................................................................
 *
 * Devuelve el tamaño de la imagen adaptada al tamaño de un contenedor.
 *
 .......................................................................*/
+(CGSize) imageAdapterSize:(UIImage *)image containerSize:(CGSize)contentSize;


@end
