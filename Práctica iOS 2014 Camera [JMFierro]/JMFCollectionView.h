//
//  JMFCollectionView.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

/*
 Este código de collectionView con celdas peronalizadas
 esta basado en el codigo de Brandon Trebitowski:
 http://www.raywenderlich.com/22324/beginning-uicollectionview-in-ios-6-part-12
 */

/*
 
 Aplicación para **miniIPad ** que consiste en una *'CollectionView'* con imágenes de busquedas obtenidas de **Flickr** y fotos tomadas de la cámara.
 
 El **diseño** de la 'collectionView' es sencillo y consta de dos partes, una blanca (parte de arriba) y otra negra(parte de abajo), con una líneas de transición entre ambas. En la parte superior blanca esta la busqueda, selección y cámara y en la de abajo negra se muestran las imágenes. *El diseño es mio, no me he inspirado en nigún otro, segui mi intuición.*
 
 
 **********
 ## Modelo
 **********
 
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
 
 
 
 ***************
 ** Controlador
 ***************
 
 Crea una *'CollectionView'*, registra una vista personalizada de las celdas (**'JMFPushpinCell.xib'**) y las cabeceras de las secciones (clase **'JMFHeaderView'**).
 
 Se hace desde **viewWillLayoutSubviews**, para que se redimensione si la orientación cambia, llamando al método de instancia **createCollectionView**.
 
 
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
 
 
 
 *************
 ##### Flickr
 **************
 
 Para la busqueda de imágenes en flickr, se establece la clase **'JMFCollectionView'** como delegado de un  *'TextField'* que recogerá el término para las búsquedas en Flickr.
 
 self.searchTextField.delegate = self;
 
 en el método **textFieldShouldReturn** utiliza la *clase	de Flickr* para hacer una busqueda asincrónica en el sitio Flickr.
 
 Cuando finaliza la busqueda actualiza la *'Interface'* del usuario en el **hilo principal de ejecución** haciendo uso de la *'propiedad privada'  **collectionViewPhotos***
 
 */

#import <UIKit/UIKit.h>
#import "ImageFlickr.h"
#import "JMFModel.h"




@interface JMFCollectionView : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) JMFModel *model;

@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activiyIndicator;

- (IBAction)btnTakePhoto:(id)sender;
- (IBAction)btnGelery:(id)sender;


- (IBAction)clickBackground:(id)sender;


@end
