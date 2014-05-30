# Práctica iOS 2014: Camera

###Asígnatura: iOS, U-Tad
###Alumno: Jose Manuel Fierro Conchouso

## Descripción

Aplicación para **miniIPad ** que consiste en una *'CollectionView'* con imágenes de busquedas obtenidas de **Flickr** y fotos tomadas de la cámara.

 Seleccionando un imagen muestra sus metadatos en una *'TableView'* con celdas personalizadas, donde además se le pude detectar caras y aplicar 5 filtros.
 
## Modelo

El modelo esta ubicado en el grupo *'Collection'*. La clase **JMFModel** contiene un *array* (**imagesCamera**) con objetos **JMFImage** para imágenes tomadas con la cámara. Un *diccionario* (**imagesFlickr**) con objetos **imageFlickr**, para imágenes bajadas de Flickr y un *array* (**termsSearchesFlickr**) con objetos , **NSString**, para lo términos de busqueda empleados en la busquedas de Flickr. Estos últimos se usarán como las *'keys'* en el *diccionario* (**imagesFlickr**).

La clase **JMFImage** ubicada en el grupo *Camera* contiene la información relativa a las imágenes de la cámara: *imagen, metadatos, latitud, longitud, rectángulos de las caras.*

La clase **imageFlickr** en el grupo *'Flickr'*, aglutina la información de las imágenes devueltas desde el sitio Flickr: *imageThumbnail, imageLarge y facesRects* junto con un conjunto de datos extra proporcionados por Flickr: *ID, farm, server,secret,isfamily,...* )

Tiene algunos método para *inicializar, conocer el número de elementos almacenados, acceder a una imagen de la cámara*.

	-(id)initWith;

	-(NSInteger) countTotal;
	-(NSInteger) countSections;
	-(NSInteger) countOfImagesCamera;
	-(NSInteger) countOfTermSearchFlickr:(NSString *)termSearchFlickr;

	// Devuelve la imagen correspondiente a una posicion.
	-(UIImage *) imageCamera:(NSInteger *) item;

 
El modelo tiene un método de borrado que recibe un objeto **'NSIndexPath'** y elimina el objeto correspondiente.

Tambien tiene métodos de acceso a los objetos **JMFImage** y **ImageFlickr**, alo que se accede enviando con el objeto **'NSIndexPath'**

	// Acceso a objetos.
	-(UIImage *) imageCameraImage:(NSInteger *) item;
	-(JMFImage *)imageCamera:(NSIndexPath *)indexPath;
	-(ImageFlickr *)imageFlickr:(NSIndexPath *)indexPath;


## CollectionView

En una **collectionView** se muestran las imágenes que se saquen con la cámara, se seleccionen de la galería o se busquen en Flickr.

El **diseño** es sencillo y consta de dos partes, una blanca y otra negra, con una líneas de transición de una parte a la otra. En la parte superior blanca esta la busqueda, selección y cámara. En la parte de abajo negra se muestran las imágenes. *Es de mi creación, no me he inspirado en nada, segui mi intuición.*

Se gestiona por la clase **JMFCollectionView**. Crea una *'CollectionView'*, registra una vista personalizada de las celdas (**'JMFPushpinCell.xib'**) y las cabeceras de las secciones (clase **'JMFHeaderView'**). 

Se hace desde **viewWillLayoutSubviews**, para que se redimensione si la orientación cambia, llamando al método de instancia **createCollectionView**. 
    
    -(void) createCollectionView {
    
    // Creación 'collection'
    CGRect rect = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height);
    collectionViewPhotos = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    
    // Registro Celdas
    [collectionViewPhotos registerNib:[UINib nibWithNibName:kJMFPushpinCell bundle:nil] forCellWithReuseIdentifier:kJMFPushpinCell];

    // Registro Cabecera
    [collectionViewPhotos registerClass:[JMFHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kJMFHeaderView];

 Se hace uso de **UICollectionViewFlowLayout** para configurar la colección.

     // Configuración 'collection'
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 4.f;
    flowLayout.minimumLineSpacing = 4;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 0, 100, 0); // ** Margenes para cabeceras y pies. **

    
     
Las **dimensiones de las celdas** se calculan diferenciando las imágenes de de la cámara y de Flickr. Se calcula un tamaño para que el thumbnail conserve las proporciones de la imagen original.

	-(CGSize) scaleFactor:(UIImage *)image widthNewFrame:(CGFloat)width {
    /*
     * Escala thumbail.
     */
    float scaleFactor = image.size.height / image.size.width;
    
    CGSize size;
    size.width = width;
    size.height = width * scaleFactor;
    
    return size;
	}	

*Para las imágenes de **Flickr** se utiliza el Thumbnail proporcionado por el sitio.*

El modelo implementa varios métodos de count. el método **countTotal** da la suma total de imágenes que contienen la colección
 
Implementa el *protocolo* **sizeForItemAtIndexPath** de **UICollectionViewFlowLayout**, en donde se diferencia una sección para las imágenes de las cámara y una sección para cada busqueda en Flickr.

###### UICollectionView Delegates:

* Metodos para la CABECERA
1. collectionView **referenceSizeForHeaderInSection**
2. collectionView **viewForSupplementaryElementOfKind**.


* Metodos para la SELECCIÓN de un item de la colección:
1. collectionView **didSelectItemAtIndexPath**


###### UICollectionViewDelegateFlowLayout Delegates:

* collectionView...**sizeForItemAtIndexPath** - *donde se establece el tamaño de los 'thumbnails'*.

###### UICollectionView Data Source:

1. collectionView **numberOfItemsInSection**
2. **numberOfSectionsInCollectionView**
3. collectionView **cellForItemAtIndexPath** - *donde se rellena la celda con los datos*.


##### Flickr

Para la busqueda de imágenes en flickr, se establece la clase **'JMFCollectionView'** como delegado de un  *'TextField'* que recogerá el término para las búsquedas en Flickr.

self.searchTextField.delegate = self;

en el método **textFieldShouldReturn** utiliza la *clase	de Flickr* para hacer una busqueda asincrónica en el sitio Flickr.

Cuando finaliza la busqueda actualiza la *'Interface'* del usuario en el **hilo principal de ejecución** haciendo uso de la *'propiedad privada'  **collectionViewPhotos***

## TableView

Muestra la imagen seleccionada con sus metadatos, la localización y el rectángulo de las caras.

Redimensiona la imagen al tamaño de la imagenView, conservando las proporciones. *(Lo hice porque sino acababa dando un **didReceiveMemoryWarning** al aplicar los filtros.)*

Utiliza celdas personalizadas utilizando ficheros **'xib'**. Se registran en **viewDidLoad**.

    /*-------------------------------------------------------------------------------
     *
     * Registro celdas
     *
     --------------------------------------------------------------------------------*/
    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kImageCell bundle:nil] forCellReuseIdentifier:kImageCell];
    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kDetalleCell bundle:nil] forCellReuseIdentifier:kDetalleCell];
    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kAddressCell bundle:nil] forCellReuseIdentifier:kAddressCell];
    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kUserCell bundle:nil] forCellReuseIdentifier:kUserCell];
    
    
    // Añade la tabla a la vista del controlador
    [self.view addSubview:tableViewPhotoSelectMetaData];

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

#### Eliminar foto

Hay un botón habilitado en el **'Navigator'**. Envía  una notificación que escucha la clase **'JMFCollectionView'** en el método **onRemove**. La clase guarda con antelación un objeto **'NSIndexPath'** 
que apunta a la imagen actual. *El modelo tiene un método de borrado que recibe un objeto **'NSIndexPath'** y elimina el objeto correspondiente.*

*El **diseño** de la tableView ha sido tomafo de una ejemplo de Github.*

# Cámara

La clase **'JMFCameraViewController'** comprueba que el dispositivo cuenta con una cámara, instancia *'UIImagePickerController'*, asigna el delegado y configura (la cámara de fotos, sin vídeo).

**imagePickerController:(UIImagePickerController *)picker** se encarga de guardar la fotografía tomada.

Si se acepta la fotografía se guarda en el dispositivo:

   	if (_newMedia)
     UIImageWriteToSavedPhotosAlbum(image,
                     self,                     @selector(image:finishedSavingWithError:contextInfo:),
                     nil);
                                                          




## Detección de caras

Se pueden detectar desde la **'TableView'**, mediante un botón habilitado junto a la imagen mostrada. La ***busqueda se realiza en segundo plano*** desde el método **btnDetectFacialFeatures** llamando a la clase **FaceDetection**. *Al lado del botón se muestra el número de caras encontradas.*
 
     
    /*...................................
     *
     * ** Detecta caras en una imagen **
     *
    ....................................*/
     - (IBAction)btnDetectFacialFeatures:(id)sender {

      [self.indicatorFaceDetection hidesWhenStopped];
      [self.indicatorFaceDetection startAnimating];
  
      /* -------------------------------------
       *
       * Busqueda de caras en segundo plano.
       *
       ---------------------------------------*/
      dispatch_queue_t queue =    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);    dispatch_async(queue, ^{
        // Añade marcos de la/s cara/s al 'view'.
        FaceDetection *faceDetection = [[FaceDetection alloc] initWithImagenView:self.photoView];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCellImage object:faceDetection.facesRects];
   
        
        /* --------------------
         *
         * Actualización de UI.
         *
         ----------------------*/
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.photoView addSubview:faceDetection.imageView];
            self.lblNumFaces.text = [NSString stringWithFormat:@"%d",faceDetection.facesNum];
            
            [self.indicatorFaceDetection stopAnimating];
  
        });
     });
    }

 

 El resultado se guarda en el modelo enviando una notificación desde la clase **CellImage** con la información contenida en el atributo **facesRects** de la clase **FaceDetection** *(un array de cadenas obtenidas desde **NSStringFromCGRect** por cada cara detectada)*. La clase **CellImage** es la que contiene el botón de busqueda de caras. 
 
 Luego, en la clase **JMFImageTableViewController** la notificación es  escuchada por el método **onFacesRects**, este a su vez envia una nueva notificación. 
 
 Finalmente la clase **JMFCollectionView** recibe esta última notificación en un método llamado tambien **onFacesRects** y guarda en el modelo el array de cadenas con las caras detectadas.
 
 
 ´´´
       
    /*...........................................
    *
    *  NOTIFICACION DE: JMFPhotoTableViewController.m
    *
    *
    *  Recibe notificaciones de 
    *  MFPhotoTableViewController.m
    *  Recibe los 'CGRect' de las caras detectadas.
    *
    ...........................................*/
	-(void)onFacesRects: (NSNotification *) note {
    
    
    /*---------------------------------------------- __________ -
     *                                              |    _   |_|
     * Sección para fotos tomadas con la camara.    |   |_|    |
     *                                              |__________|
     ------------------------------------------------- CAMARA --*/
    if (indexPatchSelect.section == 0) {
        [[self.model.imagesCamera objectAtIndex:indexPatchSelect.row] setFacesRect:note.object];
        
    } else {
        /*----------------------------------------------
         *
         * Sección para imagenes descargadas de Flickr.
         *
         -----------------------------------------------*/
        NSString *searchTerm = self.model.termsSearchesFlickr[indexPatchSelect.section -1];
        ImageFlickr *flickrPhoto = self.model.imagesFlickr[searchTerm][indexPatchSelect.row];
 
        [self.model.imagesFlickr[searchTerm][indexPatchSelect.row] setFacesRects:note.object];
     }
    
}

 ´´´
 
 
#### *Procedimiento de detección de caras*
 
 La clase **'FaceDetection'** recibe el UIImageView que contiene la imagen en la que detectar las caras y devuelve:
 
           - UIView *imageView  : contiene la imagen con las caras detectadas mediante un cuadrado
           - NSInteger numFaces : número de caras detectadas


 Calcula la escala a la que se muestra la foto en el *'contentView'*, para reposionar en su lugar las coordenadas de las caras encontradas en la imagen de tamaño original.
     
 Calcula los MARGENES que hay entre el 'content view' y la imagen que ajusta en el modo 'Aspect Fit'.
 
 Utiliza el *'framework de Coreimagen'*. Una vez detectadas las caras ubica las coordenadas de la imagen en las del *UIView*. Finalmente al ir obteniendo las coordenadas de los marcos de las caras, se escalan y se añaden al *'view'*.
 
 En *NSINteger numFaces* recoge el número de caras detectadas.
 

## Filtros

Los filtros se aplican por medio de dos métodos de clase de **Utils.m**:

filterOverImage:(UIImage *)aImage namesFilter:(NSArray *)namesFilter 

f-(UIImage *) filterOverImage:(UIImage *)aImage nameFilter:(NSString *)nameFilter

En el método *cellImage* de la clase **JMFImageTableViewController** se le aplican los filtros activos contenidos en el atributo privado *'filtersActive'*. Esta variable se mantiene actualizada por el método *onFilter* que escucha las notificaciones enviadas desde la clase **CellFilters** *(celda personalizada que lista los filtros a seleccionar).*	
Utiliza **'CIContext'** para aumentar el rendimiento:

   CIContext *context = [CIContext contextWithOptions:nil];
 CGImageRef cgImage =
 [context createCGImage:outputImage fromRect:[outputImage extent]];

El uso del método 'UIImage' con 'imageWithCIImage' sería más simple pero crea un nuevo *CIContext* cada vez, y si se usa un *'slider'* para actualizar los valores del filtro lo haría demasiado lento. *(nota: en este caso no uso slider)*

 
## Localización y Geocoding

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
      
 Muestra un *'bocadillo de Annotation'* con el país y la ciudad de la localización, bine de la foto si tiene metadatos o bien del usuario. Incluye la foto utilizando para ello el método **viewForAnnotation**. Y también al pinchar en la *'Annotation'* una alerta información sobre el origen de la información refente a la localización.

## Share

 La imagen seleccionada se puede compartir desde la vista de **JMFImageTableViewController**.Hay un botón habilitado en la barra del *'Navigation'* a la derecha.
 
 Se crea en el método *'viewWillAppear'* y llama al método *'share'* que hace uso de **UIActivityViewController**. *No excluye ninguna actividad (salvar, mail, imprimir,...).*
 
## UTILS.M

 La clase **Utils** contiene *métodos de clase*. En ella reuno todos aquellos métodos susceptibles de ser usados en otros proyectos.



## Flickr

Con una cuenta obtuve una APIkey. La clase **Flickr** hace lo siguiente:

Crea una url para la busqueda en Flickr que continene la API personal y el término de busqueda.

De forma 'asincrona' obtinene en formato 'JSON' los datos de las fotos encontradas. Una vez parseado los guarda en un array junto a una 'thumbail' de la imagen, y una url **(flickrPhotoURLForFlickrPhoto)** a la imagen para descargarsela asíncronamente desde el método **loadImageForPhoto**.

                       /* 
                         * Obtención de datos de las imagenes flickr.
                         */
                        
                        FlickrPhoto *photo = [[FlickrPhoto alloc] init];
                        photo.farm = [objPhoto[@"farm"] intValue];
                        photo.server = [objPhoto[@"server"] intValue];
                        photo.secret = objPhoto[@"secret"];
                        photo.photoID = [objPhoto[@"id"] longLongValue];
                        
                        photo.isfamily = [objPhoto[@"isfamily"] intValue] == 0 ? @"No familia" : @"Familia";
                        photo.isfriend = [objPhoto[@"isfriend"] intValue] == 0 ? @"Desconocido" : @"Amigos";
                        photo.ispublic = [objPhoto[@"ispublic"] intValue] == 0 ? @"Privada" : @"Pública";
                        photo.owner = objPhoto[@"owner"];
                        photo.title = objPhoto[@"title"];
                        
                        NSString *searchURL = [Flickr flickrPhotoURLForFlickrPhoto:photo size:@"m"];
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                                  options:0
                                                                    error:&error];
                        UIImage *image = [UIImage imageWithData:imageData];
                        photo.thumbnail = image;
                        
                        [flickrPhotos addObject:photo];


Utiliza la clase Flickr para hacer una busqueda sincrónica en el sitio Flickr. Cuando la búsqueda finaliza, el *bloque de terminación* será llamado con una referencia al término buscado, el resultado es un *conjunto de objetos* de FlickrPhoto, y un error si lo hay.

