//
//  JMFModel.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 24/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//
/*
 La clase **JMFModel** contiene un *array* (**imagesCamera**) con objetos **JMFImageCamera** para imagenes tomadas con la cámara. Un *diccionario* (**imagesFlickr**) con objetos **imageFlickr**, para imagenes bajadas de Flickr y un *array* (**termsSearchesFlickr**) con objetos , **NSString**, para lo términos de busqueda empleados en la busquedas de Flickr. Estos últimos se usarán como las *'keys'* en el *dicionario* (**imagesFlickr**).
 
 La clase **JMFImageCamera** ubicada en el grupo *'Camera'* contiene la información relativa a las imágenes de la camara: *imagen, metadatos, latitud, longitud, rectangulos de las caras.*
 
 La clase **imageFlickr** en el grupo *'Flickr'*, aglutina la información de las imaganes devuletas desde el sitio Flickr: *imageThumbnail, imageLarge y facesRects* junto con un conjunto de datos extra proporcionados por Flickr: *ID, farm, server,secret,isfamily,...* )
 
 Tiene algúnos método para *inicilizar, conocer el número de elementos almacenados, acceder a una imagen de la cácamra*.
 */

#import "JMFModel.h"

@implementation JMFModel

-(id) initWith {
    
    if (self = [self init]) {
        
        // Flickr
        _imagesFlickr = [[NSMutableDictionary alloc] init];
        _termsSearchesFlickr = [[NSMutableArray alloc] init];
        
        // Camara
        _imagesCamera = [[NSMutableArray alloc] init];
    }
    
    
    return self;
}


/*
-(id)initWithImage:(JMFImageCamera *) imageCamera {
    
    if (self = [self init]) {
        
        _imagesCamera = (id)imageCamera;
    }
    
    
    return self;
    
}
*/

/*
-(id)initWithFlickr:(FlickrPhoto *)imageFlickr {
    
    if (self = [self init]) {
        
         _imagesFlickr = (id)imageFlickr;
    }
    
    
    return self;
    
}
*/



-(NSInteger) countTotal {
    
    NSInteger numImagesFlickr = 0;
    for (NSString *termSearch in self.termsSearchesFlickr) {
        numImagesFlickr += [[self.imagesFlickr objectForKey:termSearch] count];
    }
    
    return [self.imagesCamera count] + numImagesFlickr;

}


-(NSInteger) countSections{
    
   
    return [self.termsSearchesFlickr count] + 1;

}



/*...........................................
 *
 * Número de imagenes tomadas con la cacara.
 *
 ............................................*/
-(NSInteger) countOfImagesCamera {
    
    return [self.imagesCamera count];
}


/*...........................................
 *
 * Número de imagenes bajadas de Flickr.
 *
 ............................................*/
-(NSInteger) countOfTermSearchFlickr:(NSString *)termSearchFlickr {
 
    return [self.imagesFlickr[termSearchFlickr] count];
}


/*...................................................
 *
 * Devuelve la imagen correspondiente a una posicion.
 *
 .....................................................*/
-(UIImage *) imageCamera:(NSInteger *) item {
    
    JMFImageCamera *imageCamera = [self.imagesCamera objectAtIndex:(int)item];
    
    return imageCamera.image;
}

@end


