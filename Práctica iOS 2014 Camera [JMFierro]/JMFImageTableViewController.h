//
//  JMFTableImageViewController.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 08/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

/*
 Este código de TableView de celdas peronalizadas
 esta basado en el codigo de Tibolte/TGFoursquareLocationDetail-Demo:
 https://github.com/Tibolte/TGFoursquareLocationDetail-Demo
 */

/*
 
 *************
 ** TableView
 *************
 
 Muestra la imagen seleccionada con sus metadatos, la localización y el rectángulo de las caras.
 
 Redimensiona la imagen al tamaño de la imagenView, conservando las proporciones. *(Lo hice porque sino acababa dando un **didReceiveMemoryWarning** al aplicar los filtros.)*
 
 Utiliza celdas personalizadas utilizando ficheros **'xib'**. Se registran en **viewDidLoad**.
 
 El orden de las celdas es gestiona mediante atributos privados dandoles valores tras el registro de las celdas:
 
 @interface JMFPhotoTableViewController () {
 
 // Posicion de las celdas
 NSInteger row_CellImage;
 NSInteger row_CellFilters;
 NSInteger row_CellDetalle;
 NSInteger row_CellAddress;
 NSInteger row_CellUser;
 }
 
 ...
 
 // Establece orden de las celdas
 NSInteger numCell = 0;
 row_CellImage = numCell++;
 row_CellFilters = numCell++;
 row_CellDetalle =numCell++;
 row_CellAddress = numCell++;
 row_CellUser = numCell++;
 
 Para la altura de las celdas utiliza el delegado **heightForRowAtIndexPath**.
 
 La instrucción: **UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];** en **heightForRowAtIndexPath** me daba el error:EXC_BAD_ACCESS(code=2. *La razón es que 'heightForRowAtIndexPath' es llamado antes que  'cellForRowAtIndexPath', antes de que la celda se muestre. La altura se necesita calcular y guardar primero.*
 
 En **viewDidLoad** accede a la altura de cada celda tras su registro y se guarda en una propiedad privada.
 
 // Guarda altura de las celdas personalizadas
 UITableViewCell *cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kImageCell];
 height_CellImage = cell.frame.size.height;
 cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kDetalleCell];
 height_CellDetalle = cell.frame.size.height;
 cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kAddressCell];
 height_CellAddress = cell.frame.size.height;
 cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kUserCell];
 height_CellUser = cell.frame.size.height;
 
 *De esta forma cualquier reediseño del fichero 'xib' se recogerá automáticamente.*
 
 La tableView puede ser llamada con **initWithNibName**, para imágenes ya disponibles, o con **initWithFlickrPhoto**, que recibe el objeto *FlickrPhoto* con los datos de la imagen Flickr, en este caso comprueba si ya esta descarga la imagen completa y si no la descarga de forma asíncrona y a su término actualiza la *TableView*.
 
 Para que los datos se muestren correctamente se anula la seleccionen de las celdas y se quitan las divisiones entre celdas *(las divisiones que se ven son líneas contenidas en los ficheros 'xib').*
 
 ********
 ## Share
 ********
 
 La imagen seleccionada se puede compartir desde la vista de **JMFImageTableViewController**.Hay un botón habilitado en la barra del *'Navigation'* a la derecha.
 
 Se crea en el método *'viewWillAppear'* y llama al método *'share'* que hace uso de **UIActivityViewController**. *No excluye ninguna actividad (salvar, mail, imprimir,...).*
 
 **********************
 ## Detección de caras
 **********************
 
 Se pueden detectar desde la **'TableView'**, mediante un botón habilitado junto a la imagen mostrada. La ***busqueda se realiza en segundo plano*** desde el método **btnDetectFacialFeatures** llamando a la clase **FaceDetection**. *Al lado del botón se muestra el número de caras encontradas.*
 
 El resultado se guarda en el modelo enviando una notificación desde la clase **CellImage** con la información contenida en el atributo **facesRects** de la clase **FaceDetection** *(un array de cadenas obtenidas desde **NSStringFromCGRect** por cada cara detectada)*. La clase **CellImage** es la que contiene el botón de busqueda de caras.
 
 Luego, en la clase **JMFImageTableViewController** la notificación es  escuchada por el método **onFacesRects**, este a su vez envia una nueva notificación.
 
 Finalmente la clase **JMFCollectionView** recibe esta última notificación en un método llamado tambien **onFacesRects** y guarda en el modelo el array de cadenas con las caras detectadas.
 
 
 
 ***********
 ## Filtros
 ***********
 
 Los filtros se aplican por medio de dos métodos de clase de **Utils.m**:
 
 filterOverImage:(UIImage *)aImage namesFilter:(NSArray *)namesFilter
 
 f-(UIImage *) filterOverImage:(UIImage *)aImage nameFilter:(NSString *)nameFilter
 
 En el método *cellImage* de la clase **JMFImageTableViewController** se le aplican los filtros activos contenidos en el atributo privado *'filtersActive'*. Esta variable se mantiene actualizada por el método *onFilter* que escucha las notificaciones enviadas desde la clase **CellFilters** *(celda personalizada que lista los filtros a seleccionar).*
 Utiliza **'CIContext'** para aumentar el rendimiento:
 
 CIContext *context = [CIContext contextWithOptions:nil];
 CGImageRef cgImage =
 [context createCGImage:outputImage fromRect:[outputImage extent]];
 
 El uso del método 'UIImage' con 'imageWithCIImage' sería más simple pero crea un nuevo *CIContext* cada vez, y si se usa un *'slider'* para actualizar los valores del filtro lo haría demasiado lento. *(nota: en este caso no uso slider)*
 
 *****************************
 ## Localización y Geocoding
 *****************************
 
 La celda **CellAddressLocation.xib** muestra las coordenadas y dirección de la imagen o de la posición actual.
 
 En **JMFImageTableViewController** toma las coordenadas de los metadatos si los tiene, en caso contrario obtiene la localización con el framework de **'CoreLocation'*.
 
 El método **startLocation** inicia la localización del usuario, una vez obtenida en **locationManager:didUpdateLocations:** se para la localización.
 
 Para el geocoding usa el framework **MapKit**. El método **cellAddressLocation:cellForRowAtIndexPath:
 ** instancia *CLGeocoder* y hace *reverseGeocodeLocation* . Un **mapView** en la celda se actualiza con una *chincheta* y una *etiqueta*.
 
 En el método **cellForRowAtIndexPath**, en segundo plano se hace un
 
 [geocoder reverseGeocodeLocation:userCLLocation completionHandler:^(NSArray *placemarks, NSError *error) { ...
 Finalmente establece los parametros del mapa:
 
 cell.mapView.rotateEnabled = YES;
 cell.mapView.zoomEnabled = YES;
 cell.mapView.pitchEnabled = YES;
 cell.mapView.showsBuildings = YES;
 cell.mapView.showsUserLocation = NO;
 cell.mapView.delegate = self;
 cell.mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
 
 *******************
 #### Eliminar foto
 *******************
 
 Hay un botón habilitado en el **'Navigator'**. Envía  una notificación que escucha la clase **'JMFCollectionView'** en el método **onRemove**. La clase guarda con antelación un objeto **'NSIndexPath'**
 que apunta a la imagen actual. *El modelo tiene un método de borrado que recibe un objeto **'NSIndexPath'** y elimina el objeto correspondiente.*

 */

@import CoreLocation;

#import <UIKit/UIKit.h>

#import "JMFModel.h"
#import "JMFImage.h"
#import "ImageFlickr.h"

#define kJMFTableImageViewControlleFacesRects @"kJMFTableImageViewControlleFacesRects"
#define kJMFTableImageViewControlleRemove @"kJMFTableImageViewControlleRemove"


@interface JMFImageTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>


//@property (nonatomic, strong) JMFMetaData *metaData;
//@property (nonatomic,strong) JMFImage *imageCamera;
//@property (nonatomic, strong) ImageFlickr *imageFlickr;
//@property (nonatomic, strong) UIImage *image, *imageThumbnail;


-(id) initWithImage:(JMFImage *) image;
-(id) initWithImageCamera:(JMFImage *) imageCamera;
-(id) initWithFlickrPhoto:(ImageFlickr *)flickrPhoto;


@end
