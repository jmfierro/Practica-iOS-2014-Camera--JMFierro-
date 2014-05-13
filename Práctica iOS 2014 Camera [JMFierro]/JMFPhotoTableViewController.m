//
//  JMFTablePhotoViewController.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 08/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

//#import <ImageIO/ImageIO.h>

#import <AssetsLibrary/AssetsLibrary.h>

#import "JMFPhotoTableViewController.h"

//#import "JMFLocationViewController.h"
#import "JMFLocation.h"
#import "Flickr.h"

#import "JMFMetaData.h"

// Celdas
#import "CellFilters.h"
#import "CellImage.h"
#import "CellDetail.h"
#import "CellAddressLocation.h"
#import "CellUser.h"

#import "UIImageView+Curled.h"
#import "Utils.h"



@interface JMFPhotoTableViewController () {
    

    UITableView *tableViewPhotoSelectMetaData;
    CellImage *cellImage;
    
    // Localización
//    JMFLocationViewController *location;
//    CLLocationManager *manager;
    CLLocation *location;
    CGFloat latitude;
    CGFloat longitude;
    CLPlacemark *infoGeocoder;
    BOOL isNewLocalization;
    
    // Dimensiones de las celdas
    CGFloat cellImage_height;
    CGFloat cellImage_width;
    CGFloat cellFilters_height;
    CGFloat cellDetalle_height;
    CGFloat cellAddress_height;
    CGFloat cellUser_height;
    
    // Posicion de las celdas
    NSInteger row_CellImage;
    NSInteger row_CellFilters;
    NSInteger row_CellDetalle;
    NSInteger row_CellAddress;
    NSInteger row_CellUser;
    
//    // Dimensiones ImagenView para mostrar la imagen
//    CGFloat cellImage_ImageViewHeight;
//    CGFloat cellImage_ImageViewWidth;
    
    // Filtros
    NSMutableDictionary *filtersActive;
    
    // Metadatos
    NSInteger segment;
    
}

@property (nonatomic, strong) CLLocationManager *manager;

@end


@implementation JMFPhotoTableViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Registros
        [self registers];
        
    }
    return self;
}




/*..................................
 *
 *  ** Imagen bajada de Flickr.  **
 *
 ...................................*/
-(id) initWithFlickrPhoto:(ModelFlickrPhoto *)flickrPhoto {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _modelFlickrPhoto = flickrPhoto;
        
        /*
         *  Imagen de Flickr.
         */
        if(self.modelFlickrPhoto.largeImage)
        {
            //            [spinner stopAnimating];
            //                [spinner setHidden:YES];
            _image = self.modelFlickrPhoto.largeImage;
            //                [tableViewPhotoSelectMetaData reloadData];
            
            //            cell.imagePhotoFlickr.image = [UIImage imageNamed:@"famous-face-dementia-617x416.jpg"];
        }
        else
        {
            //        cell.photo.image = self.flickrPhoto.thumbnail;
            [Flickr loadImageForPhoto:self.modelFlickrPhoto thumbnail:NO completionBlock:^(UIImage *photoImage, NSError *error) {
                
                //                [spinner stopAnimating];
                //                    [spinner setHidden:YES];
                
                if(!error)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        /*-----------------------------------------------------------------------
                         *
                         * Cuando la imagen es descargada se actualiza los datos de la TableView
                         *
                         ------------------------------------------------------------------------*/
                        _image = self.modelFlickrPhoto.largeImage;
                        [self initWithImage:_image];
                        [tableViewPhotoSelectMetaData reloadData];
                    });
                }
                
            }];
        }
        
    }
    
    return self;
}


/*...........................
 *
 *  ** Imagen a mostrar.  **
 *
 ...........................*/
-(id) initWithImage:(UIImage *) image {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        [self registers];
        
        /*-------------------------------------------------
         *
         * Redimensiona la imagen al tamaño del imageView
         *
         --------------------------------------------------*/
        if (image.size.height > cellImage_height || image.size.width > cellImage_width) {
            
            
            _image = [Utils imageToThumbnail:image Size:CGSizeMake(cellImage_width, cellImage_height)];
            

            /*-------------------------------------------------
             *
             * Conserva tamaño original de la Imagen.
             *
             --------------------------------------------------*/
        } else {
            _image = image;
        }
        
        _imageThumbnail = [Utils imageToThumbnail:image Size:CGSizeMake(100, 100)];
        _modelMetaData = [[JMFModelMetaData alloc] initWithImage:image];

    }
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    filtersActive = [[NSMutableDictionary alloc] init];
    
    /*
     * Localizacion.
     */
//    locationVC = [[JMFLocationViewController alloc] init];
//    locationVC.delegate = self;
    isNewLocalization = YES;
    
    [self registers];
    
//    /*----------------------------
//     *
//     * Creación de la Tableview.
//     *
//     -----------------------------*/
//    tableViewPhotoSelectMetaData = [[UITableView alloc] initWithFrame:CGRectMake(0,
//                                                                   0,
//                                                                   self.view.frame.size.width,
//                                                                   self.view.frame.size.height)
//                                                  style:UITableViewStylePlain];
//    tableViewPhotoSelectMetaData.delegate = self;
//    tableViewPhotoSelectMetaData.dataSource = self;
//    
//    // Quita separador
//    [tableViewPhotoSelectMetaData setSeparatorColor:[UIColor clearColor]];
//    [tableViewPhotoSelectMetaData setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    
//    
//    /*-------------------------------------------------------------------------------
//     *
//     * Registro celdas
//     *
//     --------------------------------------------------------------------------------*/
//    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kCellImage bundle:nil] forCellReuseIdentifier:kCellImage];
//    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kCellFilters bundle:nil] forCellReuseIdentifier:kCellFilters];
//    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kCellDetail bundle:nil] forCellReuseIdentifier:kCellDetail];
//    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kCellAddress bundle:nil] forCellReuseIdentifier:kCellAddress];
//    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kCellUser bundle:nil] forCellReuseIdentifier:kCellUser];
//    
//    
//    // Añade la tabla a la vista del controlador
//    [self.view addSubview:tableViewPhotoSelectMetaData];
//    
//    // Establece orden de las celdas
//    NSInteger numCell = 0;
//    row_CellImage = numCell++;
//    row_CellFilters = numCell++;
//    row_CellDetalle =numCell++;
//    row_CellAddress = numCell++;
//    row_CellUser = numCell++;
//    
//    // Guarda altura de las celdas personalizadas
//    UITableViewCell *cell = [UITableViewCell new];
//    cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellImage];
//    cellImage_height = cell.frame.size.height;
//    cellImage_ImageViewHeight = cell.imageView.frame.size.height;
//    cellImage_ImageViewWidth = cell.imageView.frame.size.width;
//    
//    cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellFilters];
//    cellFilters_height = cell.frame.size.height;
//    cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellDetail];
//    cellDetalle_height = cell.frame.size.height;
//    cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellAddress];
//    cellAddress_height = cell.frame.size.height;
//    cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellUser];
//    cellUser_height = cell.frame.size.height;
    
//    // Configuración de bordes
//    cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellImage];
//    [cell.imageView setContentMode:UIViewContentModeScaleToFill];
//    [cell.imageView setImage:[UIImage imageNamed:@"famous-face-dementia-617x416.jpg"] borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0];
   
    
//    // Scroll horizontal
//    CGRect frame = tableViewPhotoSelectMetaData.frame;
//    tableViewPhotoSelectMetaData.transform = CGAffineTransformRotate(tableViewPhotoSelectMetaData.transform, M_PI / 2);
//    tableViewPhotoSelectMetaData.frame = frame;
    
//    // Listado de filtros
//    NSArray *properties = [CIFilter filterNamesInCategory:
//                           kCICategoryBuiltIn];
//    NSLog(@"%@", properties);
//    for (NSString *filterName in properties) {
//        CIFilter *fltr = [CIFilter filterWithName:filterName];
//        NSLog(@"%@", [fltr attributes]);
//    }
    
}


-(void)viewWillDisappear:(BOOL)animated {
    /*---------------------------
     *
     * Baja en Notificaciones.
     *
     ---------------------------*/
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*..................................
 *
 * ** Protocolos de la TableView **
 *
 ...................................*/

#pragma mark - Tableview Data Sourde

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    /*
     * Para cada celda muestra una información diferente.
     */
    
    if (indexPath.row == row_CellImage) {
        
        /** ------------------------------------------------------------------
         *
         *  CELDA:
         *
         *      - Imagen
         *
         ---------------------------------------------------------------------*/
        return [self cellImage:tableView cellForRowAtIndexPath:indexPath];
        
    } else if (indexPath.row == row_CellFilters) {
        
        /** ------------------------------------------------------------------
         *
         *  CELDA:
         *
         *      - Filter1    Filter2    Filtert3    Filter4    Filter5
         *
         ---------------------------------------------------------------------*/
        return [self cellFilters:tableView cellForRowAtIndexPath:indexPath];
        
        
    } else if (indexPath.row == row_CellDetalle) {
        /** ------------------------------------------------------------------
         *
         *  CELDA:
         *
         *       - Titulo
         *       - Descripción
         *
         ---------------------------------------------------------------------*/
        return [self cellDetail:tableView cellForRowAtIndexPath:indexPath];
        
        
        
    } else if (indexPath.row == row_CellAddress) {
        
        /** ------------------------------------------------------------------
         *
         *  CELDA:
         *
         *       - Geolocalización (dirección)
         *       - Latitud
         *       - Longitud
         *
         ---------------------------------------------------------------------*/
        return [self cellAddressLocation:tableView cellForRowAtIndexPath:indexPath];
        
    } else if (indexPath.row == row_CellUser) {
        
        CellUser * cell = (CellUser *)[tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellUser];
        
        return cell;
        
        
        
    }
    
    else {
        
        return nil;
    }

}



#pragma mark - TableviewDelegate

/*............................................
 *
 * ** Desactivacion de la seleccion de los **
 * ** elementos de la 'TableView'          **
 *
 .............................................*/
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}



/*.................................................
 *
 * ** Alto de las celdas segun el fichero 'xib' **
 *
 ...................................................*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger numCell = 0;
    
    if (indexPath.row == row_CellImage)
        return cellImage_height;   // 600;
    else if (indexPath.row == row_CellFilters)
        return cellFilters_height;
    else if (indexPath.row == row_CellDetalle)
        return cellDetalle_height;  // 249.f;
    else if (indexPath.row == row_CellAddress)
        return cellAddress_height;    // 400.f;
    else if (indexPath.row == row_CellUser)
        return cellUser_height;   // 234.f;
    else
        return 0;

}


#pragma mark - ?

/*..............................
 *
 * ** Cambios de orientacion **
 *
 ...............................*/
-(BOOL)shouldAutorotate {
    return NO;
}

/*
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // grab the window frame and adjust it for orientation
    UIView *rootView = [[[UIApplication sharedApplication] keyWindow]
                        rootViewController].view;
    CGRect originalFrame = [[UIScreen mainScreen] bounds];
    CGRect adjustedFrame = [rootView convertRect:originalFrame :nil];
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    //    CGRect screen = [[UIScreen mainScreen] bounds];
    //    CGFloat width = CGRectGetWidth(screen);
    //    //Bonus height.
    //    CGFloat height = CGRectGetHeight(screen);
    
    
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        //Make labels smaller
    }
    else {
        //Make them bigger
    }
 
//    [tableViewPhotoSelectMetaData frameForAlignmentRect:CGRectMake(0,
//                                                                   0,
//                                                                   self.view.frame.size.height,
//                                                                   self.view.frame.size.width)];
    
    
}

*/


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
//        self.view = self.portraitView;
//    else
//        self.view = self.landscapeView;
//    [tblScore reloadData];
//    return YES;
//}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    //self.tableView is the table containing your data
//    //You can animate this with the duration passed as well.
//    [tableViewPhotoSelectMetaData reloadData];
//}


/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 //    if( interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
 //        CGRect f = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 2);
 //        self.mTextView.frame = f;
 //        f = CGRectMake(0, self.view.frame.size.height / 2, self.view.frame.size.width, self.view.frame.size.height / 2);
 //        self.mTableView.frame = f;
 //    }
 //    if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
 //        CGRect f = CGRectMake(0, 0, self.view.frame.size.width / 2, self.view.frame.size.height);
 //        self.mTextView.frame = f;
 //        f = CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, self.view.frame.size.height);
 //        self.mTableView.frame = f;
 //    }
 return UIInterfaceOrientationIsLandscape(interfaceOrientation);;
 }
 
 
 
 // this permit autorotate
 - (BOOL) shouldAutorotate
 {
 // this lines permit rotate if viewController is not portrait
 UIInterfaceOrientation orientationStatusBar =[[UIApplication sharedApplication] statusBarOrientation];
 if (orientationStatusBar != UIInterfaceOrientationPortrait) {
 return YES;
 }
 //this line not permit rotate is the viewController is portrait
 return NO;
 }
 */





/*...................................................
 *
 * ** Métodos privados para celdas personalizadas **
 *
 ....................................................*/

#pragma mark - Métodos privados para celdas personalizadas

-(void)face:(UITableViewCell *)cell {
    
    // draw a CI image with the previously loaded face detection picture
    
    CIImage* ciImage = [[CIImage alloc] initWithImage:self.image];
    
    // create a face detector - since speed is not an issue we'll use a high accuracy
    // detector
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    // create an array containing all the detected faces from the detector
    NSArray* features = [detector featuresInImage:ciImage];
    
    // we'll iterate through every detected face. CIFaceFeature provides us
    // with the width for the entire face, and the coordinates of each eye
    // and the mouth if detected. Also provided are BOOL's for the eye's and
    // mouth so we can check if they already exist.
    for(CIFaceFeature* faceFeature in features)
    {
        // get the width of the face
        CGFloat faceWidth = faceFeature.bounds.size.width;
        
        // create a UIView using the bounds of the face
        UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
        
        // add a border around the newly created UIView
        faceView.layer.borderWidth = 4;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        
        // add the new view to create a box around the face
//        [self.window addSubview:faceView];
//        cell.imageView.image = [UIImage alloc] im
//        [cell.imageView addSubview:faceView];
    }
    
    
}


-(UITableViewCell *) cellImage:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /** ------------------------------------------------------------------
     *
     *  CELDA:
     *
     *      - Imagen
     *
     ---------------------------------------------------------------------*/
//    CellImage *cell = (CellImage *) [tableView dequeueReusableCellWithIdentifier:kCellImage];
    cellImage = (CellImage *) [tableView dequeueReusableCellWithIdentifier:kCellImage];
    
    UIActivityIndicatorView *indicatorLoadImagen = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    /*
     * Si la imagen todavia no esta descargada, se muestra un spinner.
     */
    if (self.image == nil) {
        // Centrar spinner.
        [indicatorLoadImagen setFrame:CGRectMake(768/2, 261, 0, 0)];
//        [[cell contentView] addSubview:indicatorLoadImagen];
        [[cellImage contentView] addSubview:indicatorLoadImagen];
        
        [indicatorLoadImagen startAnimating];
        [indicatorLoadImagen setHidesWhenStopped:YES];
    }
    else {
        [indicatorLoadImagen stopAnimating];
        
//        cell.photo.image = self.image;
        //    self.detectingView.hidden = NO;
        //	self.scrollView.scrollEnabled = NO;
        
//        __block UIImage *image = self.image;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            CIImage *ciImage = [[CIImage alloc] initWithImage:self.image];;   // [[CIImage alloc] initWithImage:[FACE_IMAGES objectAtIndex:self.currentIndex]];
//            
//            NSString *accuracy = CIDetectorAccuracyHigh;
//            //        NSString *accuracy = CIDetectorAccuracyLow;
//            NSDictionary *options = [NSDictionary dictionaryWithObject:accuracy forKey:CIDetectorAccuracy];
//            CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
//            
//            NSArray *features = [detector featuresInImage:ciImage];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self drawImageAnnotatedWithFeatures:features];
//                [self ]
////                cell.photo.image = image;
//            });
//            
//        });
        
//        [self face:cell];

    }
    
    
//    cell.photoView.image = self.image;
    if (self.imageAplyFilters) {
        cellImage.photoView.image = self.imageAplyFilters;
    } else {
        cellImage.photoView.image = self.image;
    }
    
    

//    /*
//     *  Imagen de la cámara.
//     */
//    if (self.image) {
//        
//        [spinner stopAnimating];
//        
//        cell.photo.image = [self filter:self.image];
//    }
//    
//    /*
//     *  Imagen de Flickr.
//     */
//    else {
//        if(self.flickrPhoto.largeImage)
//        {
//            [spinner stopAnimating];
//            //                [spinner setHidden:YES];
//            cell.photo.image = self.flickrPhoto.largeImage;
//            //                [tableViewPhotoSelectMetaData reloadData];
//            
//            //            cell.imagePhotoFlickr.image = [UIImage imageNamed:@"famous-face-dementia-617x416.jpg"];
//        }
//        else
//        {
//            //        cell.photo.image = self.flickrPhoto.thumbnail;
//            [Flickr loadImageForPhoto:self.flickrPhoto thumbnail:NO completionBlock:^(UIImage *photoImage, NSError *error) {
//                
//                [spinner stopAnimating];
//                //                    [spinner setHidden:YES];
//                
//                if(!error)
//                {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        cell.photo.image = self.flickrPhoto.largeImage;
//                        //                        cell.imagePhotoFlickr.image = [UIImage imageNamed:@"famous-face-dementia-617x416.jpg"];
//                        
//                        [tableViewPhotoSelectMetaData reloadData];
//                    });
//                }
//                
//            }];
//        }
//    }
//    
    
//    return cell;
    return cellImage;
    
}


-(UIImage *) filterOverImage:(UIImage *)aImage nameFilter:(NSString *)nameFilter {
    
    UIImage *image = aImage;
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
//    CIFilter *ciFilter = [CIFilter filterWithName:nameFilter
//                                  keysAndValues: kCIInputImageKey, ciImage,
//                        @"inputIntensity", @0.8, nil];
//    CIFilter *ciFilter = [CIFilter filterWithName:nameFilter];
//    [ciFilter setDefaults];

    
    // 3
    CIFilter *ciFilter = [CIFilter filterWithName:nameFilter];
    [ciFilter setValue:ciImage forKey:kCIInputImageKey];
//    [ciFilter setValue:@(1) forKey:@"inputIntensity"];
    
     [ciFilter setDefaults];
    
    CIImage *outputCiImage = [ciFilter outputImage];

    
    
 /*
    // 1
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];
    [sepia setValue:ciImage forKey:kCIInputImageKey];
    [sepia setValue:@(0) forKey:@"inputIntensity"];
    
    // 2
    CIFilter *random = [CIFilter filterWithName:@"CIRandomGenerator"];
    
    // 3
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:random.outputImage forKey:kCIInputImageKey];
    [lighten setValue:@(1 - 0.8) forKey:@"inputBrightness"];
    [lighten setValue:@0.0 forKey:@"inputSaturation"];
    
    // 4
    CIImage *beginImage;
    CIImage *croppedImage = [lighten.outputImage imageByCroppingToRect:[beginImage extent]];
    
    // 5
    CIFilter *composite = [CIFilter filterWithName:@"CIHardLightBlendMode"];
    [composite setValue:sepia.outputImage forKey:kCIInputImageKey];
    [composite setValue:croppedImage forKey:kCIInputBackgroundImageKey];
    
    // 6
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignette"];
    [vignette setValue:composite.outputImage forKey:kCIInputImageKey];
    [vignette setValue:@(0.8 * 2) forKey:@"inputIntensity"];
    [vignette setValue:@(0.8 * 30) forKey:@"inputRadius"];
    
    CIImage *outputCiImage = [vignette outputImage];
  */
    
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


-(UITableViewCell *) cellFilters:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /** ------------------------------------------------------------------
     *
     *  CELDA:
     *
     *      - Filter1    Filter2    Filtert3    Filter4    Filter5
     *
     ---------------------------------------------------------------------*/
    CellFilters *cell = (CellFilters *) [tableView dequeueReusableCellWithIdentifier:kCellFilters];
    
//    cell.imgFilter1.image = [self filterOverImage:self.image nameFilter:@"CISepiaTone"];
////    cell.imgFilter1.image = [self filterOverImage:self.image nameFilter:@"CITorusLensDistortion"];
//    cell.imgFilter2.image = [self filterOverImage:self.image nameFilter:@"CIPhotoEffectProcess"];
//    cell.imgFilter3.image = [self filterOverImage:self.image nameFilter:@"CIPixellate"];
//    cell.imgFilter4.image = [self filterOverImage:self.image nameFilter:@"CIPinchDistortion"];
//    cell.imgFilter5.image = [self filterOverImage:self.image nameFilter:@"CIPerspectiveTransform"];
//    //    cell.imgFilter5.image = [self filterOverImage:self.image nameFilter:@"CISharpenLuminance"];

//    UIImage *img = [UIImage imageNamed:@"famous-face-dementia-617x416.jpg"];

    cell.imgFilter1.image = [self filterOverImage:self.imageThumbnail nameFilter:@"CISepiaTone"];
    //    cell.imgFilter1.image = [self filterOverImage:self.image nameFilter:@"CITorusLensDistortion"];
    cell.imgFilter2.image = [self filterOverImage:self.imageThumbnail nameFilter:@"CIPhotoEffectProcess"];
    cell.imgFilter3.image = [self filterOverImage:self.imageThumbnail nameFilter:@"CIPixellate"];
    cell.imgFilter4.image = [self filterOverImage:self.imageThumbnail nameFilter:@"CIPinchDistortion"];
    cell.imgFilter5.image = [self filterOverImage:self.imageThumbnail nameFilter:@"CIPerspectiveTransform"];
    //    cell.imgFilter5.image = [self filterOverImage:self.image nameFilter:@"CISharpenLuminance"];
    
    return cell;
}


-(UITableViewCell *) cellDetail: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /** ------------------------------------------------------------------
     *
     *  CELDA:
     *
     *       - Titulo
     *       - Descripción
     *
     *       - Metadatos
     *
     ---------------------------------------------------------------------*/
    CellDetail * cell = (CellDetail *)[tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellDetail];
    

    // Titulo
    if (self.modelFlickrPhoto.title)
        cell.lblTitle.text = self.modelFlickrPhoto.title;
    if (self.modelFlickrPhoto.description)
        cell.lblDescription.text = self.modelFlickrPhoto.description;
    

    
    //        self.flickrPhoto.description;
    
//    if (self.flickrPhotoModel) {
    if (segment == kCellDetailSegmentFlickr) {
      cell = [self writerDatosFlickr:cell];
    } else if (segment == kCellDetailSegmentGeneralMetaData){
        cell = [self writerGeneralMetaDatos:cell];
    }
    
    
    return cell;
    
}

-(CellDetail *) writerDatosFlickr:(CellDetail *) cell {
    

    cell.lbl1.text = @"ID:";
    if (self.modelFlickrPhoto.photoID)
        cell.lbl1content.text = [[NSString alloc] initWithFormat:@"%lld", self.modelFlickrPhoto.photoID];
    
    cell.lbl2.text = @"Farm:";
    if (self.modelFlickrPhoto.farm)
        cell.lbl2content.text = [[NSString alloc] initWithFormat:@"%d", self.modelFlickrPhoto.farm];
    
    cell.lbl3.text = @"Servidor:";
    if (self.modelFlickrPhoto.server)
        cell.lbl3content.text = [[NSString alloc] initWithFormat:@"%d", self.modelFlickrPhoto.server];
    
    cell.lbl4.text = @"Secreto:";
    if (self.modelFlickrPhoto.secret)
        cell.lbl4content.text = self.modelFlickrPhoto.secret;
    
    cell.lbl5.text = @"Familia:";
    if (self.modelFlickrPhoto.isfamily)
        cell.lbl5content.text = self.modelFlickrPhoto.isfamily;
    
    cell.lbl6.text = @"Amigo:";
    if (self.modelFlickrPhoto.isfriend)
        cell.lbl6content.text = self.modelFlickrPhoto.isfriend;
    
    cell.lbl7.text = @"Publico:";
    if (self.modelFlickrPhoto.ispublic)
        cell.lbl7content.text = self.modelFlickrPhoto.ispublic;
    
    cell.lbl8.text = @"Propietario:";
    if (self.modelFlickrPhoto.owner)
        cell.lbl8content.text = self.modelFlickrPhoto.owner;

    return cell;
}


-(CellDetail *) writerGeneralMetaDatos:(CellDetail *) cell {
    
    NSArray *keys = [self.modelMetaData.metaDataAll allKeys];
    
    
    cell.lbl1.text = @"Color";
    cell.lbl1content.text = [self.modelMetaData.metaDataAll objectForKey:@"ColorModel"];
    
    cell.lbl2.text = @"Profundidad";
    cell.lbl2content.text = [NSString stringWithFormat:@"%@",[self.modelMetaData.metaDataAll objectForKey:@"Depth"]];
    
    cell.lbl3.text = @"Orientacion";
    cell.lbl3content.text = [NSString stringWithFormat:@"%@",[self.modelMetaData.metaDataAll objectForKey:@"Orientation"]];

    cell.lbl5.text = @"Alto";
    cell.lbl5content.text = [NSString stringWithFormat:@"%@",[self.modelMetaData.metaDataAll objectForKey:@"PixelHeight"]];

    cell.lbl6.text = @"Ancho";
    cell.lbl6content.text = [NSString stringWithFormat:@"%@",[self.modelMetaData.metaDataAll objectForKey:@"PixelWidth"]];

    cell.lbl4.text = @"";
    cell.lbl4content.text = @"";
    
    cell.lbl7.text = @"";
    cell.lbl7content.text = @"";
    
    cell.lbl8.text = @"";
    cell.lbl8content.text = @"";

    return cell;
}



-(UITableViewCell *) cellAddressLocation:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /** ------------------------------------------------------------------
     *
     *  CELDA:
     *
     *       - Geolocalización (dirección)
     *       - Latitud
     *       - Longitud
     *
     ---------------------------------------------------------------------*/
    CellAddressLocation * cell = (CellAddressLocation *)[tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellAddress];
    
//    JMFLocation *location = [[JMFLocation alloc] init];
    
    
    if (!latitude & !longitude) {
        latitude = location.coordinate.latitude;
        longitude = location.coordinate.longitude;
    }
    
//    CLLocation *lastLocation = [CLLocation alloc  ini]CLLocationCoordinate2DMake(30.0f, -3.0f);
//    
//    [location.coordinate setLatitude:30];
//    location.coordinate = CLLocationCoordinate2DMake(43.0f, -3.0f);
    
//            JMFLocationViewController *lVC = [[JMFLocationViewController alloc] initWithMapView:cell.mapkit];
    //        lVC.delegate = self;
    
    if (isNewLocalization) {
        isNewLocalization = NO;
        
        //    dispatch_async(dispatch_queue_t queue, ^{
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CLGeocoder *geocoder = [[CLGeocoder alloc]init];
//            CLLocation *userCLLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        CLLocation *clLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            //    [geocoder reverseGeocodeLocation:userCLLocation completionHandler:^(NSArray *placemarks. NSError )];
            
            //    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            //    CLLocation *userCLLocation = [[CLLocation alloc] itWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
//             __block JMFLocationViewController *weakSelf = self;
//        __block CLLocation *weakLocation = location;
        [geocoder reverseGeocodeLocation:clLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                if (placemarks.count > 0) {
                    
                    //            dispatch_sync(dispatch_get_main_queue(), ^{
                    //                CLPlacemark *info = [placemarks lastObject];
                    //                [self.delegate setInfoGeocoder:info];
                    //            });
                    
                    
                    infoGeocoder = [placemarks lastObject];
                    NSLog(@"%@/n%@, %@/n%@",
                          [[infoGeocoder addressDictionary] objectForKey:@"Street"],
                          [[infoGeocoder addressDictionary] objectForKey:@"City"],
                          [[infoGeocoder addressDictionary] objectForKey:@"ZIP"],
                          [[infoGeocoder addressDictionary] objectForKey:@"Country"]);
                    
                     NSLog(@"FormattedAddressLines: %@", [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"FormattedAddressLines"]);
                     NSLog(@"Street: %@", [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"Street"]);
                     NSLog(@"SubAdministrativeArea: %@", [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"Thoroughfare"]);
                     NSLog(@"Thoroughfare: %@", [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"Country"]);
                     NSLog(@"ZIP: %@", [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"ZIP"]);
                     NSLog(@"Name: %@", [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"Name"]);
                     NSLog(@"City: %@", [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"City"]);
                     NSLog(@"Country: %@", [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"Country"]);
                     NSLog(@"State: %@", [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"State"]);
                     NSLog(@"SubThoroughfare: %@", [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"SubThoroughfare"]);
                     NSLog(@"CountryCode: %@", [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"CountryCode"]);
                    
                    
//                    [cell.mapView setMapType:MKMapTypeHybrid];
                    cell.mapView.rotateEnabled = YES;
                    cell.mapView.zoomEnabled = YES;
                    cell.mapView.pitchEnabled = YES;
                    cell.mapView.showsBuildings = YES;
                    cell.mapView.showsUserLocation = NO;
                    cell.mapView.delegate = self;
                    cell.mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
                    
                    double delayInSeconds = 2.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        // Geocoding
                        cell.lblCountry.text = [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"Country"];
                        cell.lblState.text = [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"State"];
                        cell.lblCity.text = [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"City"];
                        cell.lblName.text = [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"Name"];
                        cell.lblStreet.text = [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"Street"];

                        // Mapa
                        MKPointAnnotation *chincheta = [[MKPointAnnotation alloc] init];
                        chincheta.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                        chincheta.title = [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"Country"];
                        chincheta.subtitle = [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"State"];
                        
                        [cell.mapView addAnnotation:chincheta];
                    });
                    
                   
                    [tableView reloadData];
                }
            }];  // ** Fin Geocoding **
            
//        }); // ** Fin dispach **
        
    }

    
    
    
    // Localizacion
    cell.lblLatitud.text = [[NSString alloc] initWithFormat:@"%.6f %@",latitude, @"lat"];
    cell.lblLongitud.text = [[NSString alloc] initWithFormat:@"%.6f %@", longitude, @"long"];
    
    NSString *direccion = [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"Street"];
    
//    cell.lblGeolocalizacion.text = direccion;
    
//    cell.lblOwer.text = self.flickrPhotoModel.owner;
    
//    cell.lblSecret.Text = [[NSString alloc] initWithFormat:@"%@ %@", self.flickrPhotoModel.secret, @"secret"];
    
    
    return cell;
    
}





/*..................
 *
 * ** Delegados **
 *
 ..................*/

#pragma mark - Delegates
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // Localización
    location = [locations lastObject];
    [manager stopUpdatingLocation];
    
    // Actualiza tabla.
    [tableViewPhotoSelectMetaData reloadData];
}


-(void) onLastLocation:(CLLocation *)aLastLocation {
    location = aLastLocation;
}


-(void) setInfoGeocoder:(CLPlacemark *)aInfo {
    infoGeocoder = aInfo;
}



#pragma mark - Notificacions


/*...........................................
 *
 *  NOTIFICACION DE: CellFilters.m
 *
 *
 *  Recibe notificaciones de CellFilters.m
 *  Aplica todos los filtros activos.
 *
 ...........................................*/
-(void)onFilters: (NSNotification *) note {
    
  
    // Actulización de todos los filtros.
    if ([filtersActive objectForKey:note.object])
        [filtersActive removeObjectForKey:note.object];
    else
        [filtersActive setObject:@YES forKey:note.object];

    // Recorrido y aplicación de todos los filtros activos
    self.imageAplyFilters = self.image;    // self.image;
    NSArray *keys = [filtersActive allKeys];
    for (id key in keys)
        self.imageAplyFilters = [self filterOverImage:self.imageAplyFilters nameFilter:key];
    
    [tableViewPhotoSelectMetaData reloadData];
}

/*...........................................
 *
 *  NOTIFICACION DE: CellDetatil.m
 *
 *
 *  Recibe notificaciones de CellFilters.m
 *  Aplica todos los filtros activos.
 *
 ...........................................*/
-(void)onMetaData: (NSNotification *) note {
    segment = [note.object integerValue];
    
//    if ([note.object integerValue] == kCellDetailSegementFlickr) {
//
//    }
    
    
    [tableViewPhotoSelectMetaData reloadData];
}

#pragma mark - Metodos privados

-(void) startLocation {
    /*----------------------------
     *
     * Localización.
     *
     -----------------------------*/
    
    //    JMFLocation *loc = [[JMFLocation alloc] init];
    //    JMFLocationViewController *loc2 = [[JMFLocationViewController alloc] init];
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.pausesLocationUpdatesAutomatically=YES;
        
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        self.manager.delegate = self;
        
        [self.manager startUpdatingLocation];
    }
    
}

-(void) registers {
    
  
    /*----------------------------
     *
     * Localización.
     *
     -----------------------------*/
    [self startLocation];
    
    
    
    /*----------------------------
     *
     * Creación de la Tableview.
     *
     -----------------------------*/
    tableViewPhotoSelectMetaData = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                                 0,
                                                                                 self.view.frame.size.width,
                                                                                 self.view.frame.size.height)
                                                                style:UITableViewStylePlain];
    tableViewPhotoSelectMetaData.delegate = self;
    tableViewPhotoSelectMetaData.dataSource = self;
    
    // Quita separador
    [tableViewPhotoSelectMetaData setSeparatorColor:[UIColor clearColor]];
    [tableViewPhotoSelectMetaData setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    /*-------------------------------------------------------------------------------
     *
     * Registro celdas
     *
     --------------------------------------------------------------------------------*/
    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kCellImage bundle:nil] forCellReuseIdentifier:kCellImage];
    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kCellFilters bundle:nil] forCellReuseIdentifier:kCellFilters];
    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kCellDetail bundle:nil] forCellReuseIdentifier:kCellDetail];
    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kCellAddress bundle:nil] forCellReuseIdentifier:kCellAddress];
    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kCellUser bundle:nil] forCellReuseIdentifier:kCellUser];
    
    
    // Añade la tabla a la vista del controlador
    [self.view addSubview:tableViewPhotoSelectMetaData];
    
    // Establece orden de las celdas
    NSInteger numCell = 0;
    row_CellImage = numCell++;
    row_CellFilters = numCell++;
    row_CellDetalle =numCell++;
    row_CellAddress = numCell++;
    row_CellUser = numCell++;
    
    // Guarda altura de las celdas personalizadas
    UITableViewCell *cell = [UITableViewCell new];
    cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellImage];
    cellImage_height = cell.frame.size.height;
    cellImage_width = cell.frame.size.width;
    
//    cellImage_ImageViewHeight = cell.imageView.frame.size.height;
//    cellImage_ImageViewWidth = cell.imageView.frame.size.width;
    
    cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellFilters];
    cellFilters_height = cell.frame.size.height;
    cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellDetail];
    cellDetalle_height = cell.frame.size.height;
    cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellAddress];
    cellAddress_height = cell.frame.size.height;
    cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellUser];
    cellUser_height = cell.frame.size.height;
    
    
    /*-------------------------------------------------------------------------------
     *
     * Notificaciones
     *
     --------------------------------------------------------------------------------*/
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(onFilters:) name:kCellFilters object:nil];
    [center addObserver:self selector:@selector(onMetaData:) name:kCellDetail object:nil];

    
}


@end
