//
//  JMFModel.h
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

#import <Foundation/Foundation.h>
#import "JMFMetaData.h"
#import "JMFImageCamera.h"
#import "ImageFlickr.h"

@interface JMFModel : NSObject


// Camara
@property (nonatomic, strong) NSMutableArray *imagesCamera;


// Flick
@property(nonatomic, strong) NSMutableDictionary *imagesFlickr;
@property(nonatomic, strong) NSMutableArray *termsSearchesFlickr;




-(id)initWith;

-(NSInteger) countTotal;
-(NSInteger) countSections;
-(NSInteger) countOfImagesCamera;
-(NSInteger) countOfTermSearchFlickr:(NSString *)termSearchFlickr;

// Devuelve la imagen correspondiente a una posicion.
-(UIImage *) imageCamera:(NSInteger *) item;

@end
