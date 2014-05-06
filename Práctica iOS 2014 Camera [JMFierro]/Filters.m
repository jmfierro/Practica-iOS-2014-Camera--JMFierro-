//
//  Filters.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "Filters.h"
#import <CoreImage/CoreImage.h>

@implementation Filters

@synthesize delegate;

-(UIImage *) setFilter:(UIImage *) image nameFilter:(NSString *)nameFilter {
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    CIFilter *ciFilter = [CIFilter filterWithName:nameFilter
                                    keysAndValues: kCIInputImageKey, ciImage,
                          @"inputIntensity", @0.8, nil];
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

@end
