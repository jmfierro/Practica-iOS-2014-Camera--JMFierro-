//
//  Flickr.h
//  Práctica iOS 2014 Camera [JMFierro]
//
// ************************************************
//  Modificado por Jose Manuel Fierro Conchouso
// ************************************************
//  Created by Brandon Trebitowski on 6/28/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

/*
 * Realiza búsquedas y devuelve un arreglo de FlickrPhotos.
 */

/*
 Crea una url para la busqueda en Flickr que continene la API personal y el término de busqueda.
 
 De forma 'asincrona' obtinene en formato 'JSON' los datos de las fotos encontradas. Una vez parseado los guarda en un array junto a una 'thumbail' de la imagen, y una url **(flickrPhotoURLForFlickrPhoto)** a la imagen para descargarsela asíncronamente desde el método **loadImageForPhoto**
 
 Hace una busqueda sincrónica en el sitio Flickr. Cuando la búsqueda finaliza, el *bloque de terminación* será llamado con una referencia al término buscado, el resultado es un *conjunto de objetos* de FlickrPhoto, y un error si lo hay.

 */

#import <Foundation/Foundation.h>

@class ImageFlickr;

typedef void (^FlickrSearchCompletionBlock)(NSString *searchTerm, NSArray *results, NSError *error);
typedef void (^FlickrPhotoCompletionBlock)(UIImage *photoImage, NSError *error);

@interface Flickr : NSObject

@property(strong) NSString *apiKey;

- (void)searchFlickrForTerm:(NSString *) term completionBlock:(FlickrSearchCompletionBlock) completionBlock;
+ (void)loadImageForPhoto:(ImageFlickr *)flickrPhoto thumbnail:(BOOL)thumbnail completionBlock:(FlickrPhotoCompletionBlock) completionBlock;
+ (NSString *)flickrPhotoURLForFlickrPhoto:(ImageFlickr *) flickrPhoto size:(NSString *) size;

@end
