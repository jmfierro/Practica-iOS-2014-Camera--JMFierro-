//
//  Flickr.m
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

#import "Flickr.h"
#import "ImageFlickr.h"

//#define kFlickrAPIKey @"d02c877c0a4220890f14fc95f8b16983"
#define kFlickrAPIKey @"a5dc780c8fd28cfef0b50cefd39c9d8d"


@implementation Flickr

+ (NSString *)flickrSearchURLForSearchTerm:(NSString *) searchTerm
{
    searchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=20&format=json&nojsoncallback=1",kFlickrAPIKey,searchTerm];
}

+ (NSString *)flickrPhotoURLForFlickrPhoto:(ImageFlickr *) flickrPhoto size:(NSString *) size
{
    if(!size)
    {
        size = @"m";
    }
    return [NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg",flickrPhoto.farm,flickrPhoto.server,flickrPhoto.ID,flickrPhoto.secret,size];
}

- (void)searchFlickrForTerm:(NSString *) term completionBlock:(FlickrSearchCompletionBlock) completionBlock
{
    NSString *searchURL = [Flickr flickrSearchURLForSearchTerm:term];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSString *searchResultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                           encoding:NSUTF8StringEncoding
                                                              error:&error];
        if (error != nil) {
            completionBlock(term,nil,error);
        }
        else
        {
            // Parse the JSON Response
            NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                              options:kNilOptions
                                                                                error:&error];
            if(error != nil)
            {
                completionBlock(term,nil,error);
            }
            else
            {
                NSString * status = searchResultsDict[@"stat"];
                if ([status isEqualToString:@"fail"]) {
                    NSError * error = [[NSError alloc] initWithDomain:@"FlickrSearch" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: searchResultsDict[@"message"]}];
                    completionBlock(term, nil, error);
                } else {
                
                    NSArray *objPhotos = searchResultsDict[@"photos"][@"photo"];
                    NSMutableArray *flickrPhotos = [@[] mutableCopy];
                    for(NSMutableDictionary *objPhoto in objPhotos)
                    {
                        /* 
                         * Obtención de datos de las imagenes flickr.
                         */
                        
                        ImageFlickr *modelPhoto = [[ImageFlickr alloc] init];
                        modelPhoto.farm = [objPhoto[@"farm"] intValue];
                        modelPhoto.server = [objPhoto[@"server"] intValue];
                        modelPhoto.secret = objPhoto[@"secret"];
                        modelPhoto.ID = [objPhoto[@"id"] longLongValue];
                        
                        modelPhoto.isfamily = [objPhoto[@"isfamily"] intValue] == 0 ? @"No" : @"Familia";
                        modelPhoto.isfriend = [objPhoto[@"isfriend"] intValue] == 0 ? @"No" : @"Si";
                        modelPhoto.ispublic = [objPhoto[@"ispublic"] intValue] == 0 ? @"Privada" : @"Pública";
                        modelPhoto.owner = objPhoto[@"owner"];
                        modelPhoto.title = objPhoto[@"title"];
                        
                        NSString *searchURL = [Flickr flickrPhotoURLForFlickrPhoto:modelPhoto size:@"m"];
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                                  options:0
                                                                    error:&error];
                        UIImage *image = [UIImage imageWithData:imageData];
                        modelPhoto.imageThumbnail = image;
                        
                        [flickrPhotos addObject:modelPhoto];
                    }
                    
                    completionBlock(term,flickrPhotos,nil);
                }
            }
        }
    });
}

+ (void)loadImageForPhoto:(ImageFlickr *)flickrPhoto thumbnail:(BOOL)thumbnail completionBlock:(FlickrPhotoCompletionBlock) completionBlock
{
    
    NSString *size = thumbnail ? @"m" : @"b";
    
    // Obtiene la url con la API personal.
    NSString *searchURL = [Flickr flickrPhotoURLForFlickrPhoto:flickrPhoto size:size];
    
    // Hilo para descargar la imagen de Flickr.
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSError *error = nil;
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                  options:0
                                                    error:&error];
        if(error)
        {
            completionBlock(nil,error);
        }
        else
        {
            UIImage *image = [UIImage imageWithData:imageData];
            if([size isEqualToString:@"m"])
            {
                flickrPhoto.imageThumbnail = image;
            }
            else
            {
                flickrPhoto.imageLarge = image;
            }
            completionBlock(image,nil);
        }
        
    });
}



@end
