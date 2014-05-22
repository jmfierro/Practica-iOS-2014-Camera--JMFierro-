//
//  JMFCollectionView.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "JMFCollectionView.h"
#import "JMFHeaderView.h"
#import "JMFPushpinCell.h"

#import "JMFImageTableViewController.h"
#import "JMFCameraViewController.h"

#import "Flickr.h"
#import "ImageFlickr.h"
#import "Utils.h"



@interface JMFCollectionView () {
    
    NSMutableDictionary *modelDictionay;
    
    UICollectionView *collectionView;
    NSInteger sectionCamera;
    
    NSIndexPath *indexPatchSelect;
}


@end

@implementation JMFCollectionView


#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        /*------------------
         *
         * **   MODELO   **
         *
         -------------------*/
        self.model = [[JMFModel alloc] initWith];
    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    [self createCollectionView];
}



/*....................................
 *
 * Detectando cambio de orientación.
 *
 .....................................*/
-(void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    NSLog(@"viewWillLayoutSubviews");
    
    [self createCollectionView];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation) {
//    if (interfaceOrientation == UIInterfaceOrientationPortrait|| interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
//        //Code
//    }
//    else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight||interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
//        //Code
//    }
//}


//if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
//{
//    // code for landscape orientation
//}

//if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
//{
//    // code for Portrait orientation
//}


//if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
//    //DO Portrait
//}else{
//    //DO Landscape
//}

//typedef enum {
//    UIDeviceOrientationUnknown,
//    UIDeviceOrientationPortrait,
//    UIDeviceOrientationPortraitUpsideDown,
//    UIDeviceOrientationLandscapeLeft,
//    UIDeviceOrientationLandscapeRight,
//    UIDeviceOrientationFaceUp,
//    UIDeviceOrientationFaceDown
//} UIDeviceOrientation;

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}


//-(BOOL)shouldAutorotate {
//    return NO;
//}





/*....................................
 *
 ** Protocolos de UICollectionView **
 *
 ....................................*/

#pragma mark - UICollectionView Delegates

/**************************************
 ** Metodos para la CABECERA y PIES. **
 **************************************/

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    //    if (section == albumSection) {
    return CGSizeMake(0, 50);
    //    }
    
    return CGSizeZero;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    UICollectionReusableView *titleView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kJMFHeaderView forIndexPath:indexPath];
        
        if (indexPath.section == 0) {  // & [self.photosCamera count]>0) {
 
            /*---------------------------------------------- __________ -
             *                                              |    _   |_|
             * CABECERA para fotos tomadas con la camara.   |   |_|    |
             *                                              |__________|
             ------------------------------------------------- CAMARA --*/
 
            ((JMFHeaderView *)titleView).label.text = @"Camara";
            
            
        } else {
            /*----------------------------------------------------
             *
             * CABECERA para imagenes descargadas dde Flickr.
             *
             -----------------------------------------------------*/
            NSString *searchTerm = self.model.termsSearchesFlickr[indexPath.section -1]; //[self.photosCamera count]>0 ? 1:0];
            ((JMFHeaderView *)titleView).label.text = searchTerm;

        }
    }
    
     return titleView;
    
 }





/***************************************************************
 ** Metodos para la SELECCION de un item de la colección. **
 ***************************************************************/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JMFImageTableViewController *tablePhotoVC = [[JMFImageTableViewController alloc] init];
    
    indexPatchSelect = indexPath;
    
    if (indexPath.section == 0) {  // & [self.photosCamera count]>0) {
        /*---------------------------------------------- __________ -
         *                                              |    _   |_|
         * Sección para fotos tomadas con la camara.    |   |_|    |
         *                                              |__________|
         ------------------------------------------------- CAMARA --*/
        
        /*
         * Evita que la imagen inicial de "void" en la seccion de 'Camara' se seleccione.
         * (Esta imagen 'void' índica que no hay fotos tomadas por la cámara desde la app)
         *
         */
        if ([self.model countOfImagesCamera]) {
            
            JMFImageCamera *imageCamera = [[JMFImageCamera alloc] init];
            imageCamera = [self.model.imagesCamera objectAtIndex:indexPath.row];
            
            tablePhotoVC = [[JMFImageTableViewController alloc] initWithImageCamera:imageCamera];
            
            [self.navigationController pushViewController:tablePhotoVC animated:YES];
        }
        
        
    } else {
        /*--------------------------------------------------
         *
         * SELECCION para imagenes descargadas de Flickr.
         *
         ---------------------------------------------------*/
        
        NSString *searchTerm = self.model.termsSearchesFlickr[indexPath.section -1];
        ImageFlickr *flickrPhoto = self.model.imagesFlickr[searchTerm][indexPath.row];
        
        tablePhotoVC = [[JMFImageTableViewController alloc] initWithFlickrPhoto:flickrPhoto];
        
        [self.navigationController pushViewController:tablePhotoVC animated:YES];
    }
    
}


//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//}




/*....................................................
 *
 ** Protocolo de UICollectionViewDelegateFlowLayout **
 *
 ....................................................*/

#pragma mark - UICollectionViewDelegateFlowLayout Delegates

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//     return CGSizeMake(206.f, 167.f);
//    
//    // ...anulado
    CGSize retval;
    if (indexPath.section == 0) {  // & [self.photosCamera count]>0) {
        /*------------------------------------------------------------------ __________ -
         *                                                                  |    _   |_|
         * TAMAÑO para los THUMBNAILS de las fotos tomadas con la camara.   |   |_|    |
         *                                                                  |__________|
         -------------------------------------------------------------------   CAMARA -*/
        UIImage *image;
        if ([self.model countOfImagesCamera] > 0) {
//            JMFCamera *imgCamera = [[JMFCamera alloc] init];
//            imgCamera = [self.model.imagesCamera objectAtIndex:indexPath.row];
//            image = imgCamera.image;

//            image = [self.model.imagesCamera objectAtIndex:indexPath.row];
            image = [self.model imageCamera:indexPath.row];
            
        }
        
        // Imagen para indicar que no hay fotos.
        else
            image = [UIImage imageNamed:@"can-stock-photo_csp12611066.png"];
 
        // Escala thumbail.
        retval = [Utils scaleFactor:image widthNewFrame:150];

        
    } else {
        /*----------------------------------------------------------------------
         *
         * TAMAÑO para los THUMBNAILS de las imagenes descargadas desde Flickr.
         *
         -----------------------------------------------------------------------*/
//        NSString *searchTerm = self.searches[indexPath.section -1]; //  - [self.photosCamera count]>0 ? 1:0];
//        FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
        
        NSString *searchTerm = self.model.termsSearchesFlickr[indexPath.section -1]; //  - [self.photosCamera count]>0 ? 1:0];
        ImageFlickr *photo = self.model.imagesFlickr[searchTerm][indexPath.row];

        // Escala thumbnail.
        CGSize frame = [Utils scaleFactor:photo.imageLarge widthNewFrame:200];
        retval = photo.imageThumbnail.size.width > 0 ? photo.imageThumbnail.size : frame; // CGSizeMake(200, 200);

    }

    /*
     * Para que se vea la chincheta o símilar.
     */
    retval.height += 35;
    retval.width += 35;

    return retval;
    
}






/*.................................
 *
 ** Protocolos de CollectionView **
 *
 ..................................*/

#pragma mark - UICollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
 
    if (section == 0) { // & [self.photosCamera count]>0) {
        /*------------------------------------------------------------------ __________ -
         *                                                                  |    _   |_|
         * NUMERO de fotos tomadas con la cámara.                           |   |_|    |
         *                                                                  |__________|
         -------------------------------------------------------------------   CAMARA -*/
        return MAX( 1, [self.model countOfImagesCamera]);

    
    } else {
        /*-----------------------------------------------------------------------------
         *
         * NÚMERO de imagenes descargadas de Flickr para cada término de busquda.
         *
         ------------------------------------------------------------------------------*/
        NSString *searchTerm = self.model.termsSearchesFlickr[section -1];
        return [self.model countOfTermSearchFlickr:searchTerm];

    }
}



- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return [self.model countSections];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    /*
     UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell " forIndexPath:indexPath];
     cell.backgroundColor = [UIColor whiteColor];
     */
    
    JMFPushpinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJMFPushpinCell forIndexPath:indexPath];
    
//    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];

    if (indexPath.section == 0) { // & [self.photosCamera count]>0) {

        /*---------------------------------------------- __________ -
         *                                              |    _   |_|
         * Sección para fotos tomadas con la camara.    |   |_|    |
         *                                              |__________|
         ------------------------------------------------- CAMARA --*/

        if ([self.model countOfImagesCamera] > 0 ) {
            //            cell.imagePhoto.image = [self.model.imagesCamera objectAtIndex:indexPath.row];
//            JMFCamera *imageCamera = [[JMFCamera alloc] init];
//            imageCamera = [self.model.imagesCamera objectAtIndex:indexPath.row];
//            cell.imagePhoto.image = imageCamera.image;


//            cell.imagePhoto.image = [self.model.imagesCamera objectAtIndex:indexPath.row];
            cell.imagePhoto.image = [self.model imageCamera:indexPath.row];
        }

        // Imagen que indica que no hay fotos tomadas con la cámara.
        else {
            cell.imagePhoto.image = [UIImage imageNamed:@"can-stock-photo_csp12611066.png"];
        }
        

    } else {
        
        /*----------------------------------------------
         *
         * Sección para imagenes descargadas de Flickr.
         *
         -----------------------------------------------*/
        NSString *searchTerm = self.model.termsSearchesFlickr[indexPath.section -1];
        //- [self.photosCamera count]>0 ? 1:0];
        cell.photo = self.model.imagesFlickr[searchTerm][indexPath.row];

   }
    

    return cell;
}






/*.......................................................
 *
 ** Protocolo de TextField para las busquedas en Flickr **
 *
 .......................................................*/
#pragma mark - UITextFieldDelegate Delegates


- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    /*---------------------------------------------------------------
     *
     *   Utiliza la clase	de Flickr para hacer una busqueda
     * asincrónica en el sitio Flickr.

     *
     * Cuando la búsqueda finaliza, el bloque de terminación será llamado 
     * con una referencia al término buscado, el resultado es un conjunto 
     * de objetos de FlickrPhoto, y un error si lo hay.
     *
     ----------------------------------------------------------------*/
    [self.activiyIndicator setHidden:NO];
    [self.activiyIndicator startAnimating];
    
    Flickr *flickr = [Flickr new];
    [flickr searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        
        if(results && [results count] > 0) {
            
            /* -----------------------------------------------------------------
             *
             *  Si no exite el término de busqueda la inserta en la posición 0.
             *
             ------------------------------------------------------------------*/
            if(![self.model.termsSearchesFlickr containsObject:searchTerm]) {
                [self.model.termsSearchesFlickr insertObject:searchTerm atIndex:0];
                self.model.imagesFlickr[searchTerm] = results;
            }
            
            /* ------------------------------------
             *
             *  Actualiza la interfaz de usuario.
             *
             --------------------------------------*/
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activiyIndicator setHidden:YES];
                [collectionView reloadData];
            });
        } else {
            NSLog(@"Error busqueda Flickr: %@", error.localizedDescription);
        } }];
    
    [textField resignFirstResponder];
    return YES;
}



/*..........................
 *
 ** delegado de la camara **
 *
 ...........................*/
#pragma mark - CameraViuewController Delegate

-(void)getImagePickerCamera:(JMFImageCamera *)imageCamera {

//    JMFImageCamera *imageCamera = [[JMFImageCamera alloc] initWithImage:image];
    [self.model.imagesCamera addObject:imageCamera];
    
    [collectionView reloadData];
    
}


#pragma mark - Notificaciones
/*...........................................
*
*  NOTIFICACION DE: JMFPhotoTableViewController.m
*
*
*  Recibe notificaciones de JMFPhotoTableViewController.m
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




/*.......................
 *
 ** Metodos 'Actions' **
 *
.........................*/

#pragma mark - Action Methods

- (IBAction)btnTakePhoto:(id)sender {
    
    BOOL isCamera = NO;
    
    if (!isCamera) {
        
        
        /*          o `´
         *      oo
         *   |~~/ o
         *   |~|
         *   |~|  PRUEBAS SIN CAMARA (simulador)
         *   |_|
         */
        /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         * Pruebas sin camara. Simula haber tomado una foto.
         ~~~~~~~~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~~*/
        //    [self.model.imagesCamera addObject:[UIImage imageNamed:@"famous-face-dementia-617x416.jpg"]];
        JMFImageCamera *imageCamera = [[JMFImageCamera alloc] init];
        imageCamera.image = [UIImage imageNamed:@"famous-face-dementia-617x416.jpg"];
        [self.model.imagesCamera addObject:imageCamera];
        
        //    [self.model.photosCamera addObject:[UIImage imageNamed:@"Washington.jpg"]];
    
        
        
    } else {
 
        /*
         *    __________
         *   |    _   |_|
         *   |   |_|    | CAMARA
         *   |__________|
         */
        /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         * LLamada a la camara.
         ~~~~~~~~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~~*/
        JMFCameraViewController *cameraVC = [[JMFCameraViewController alloc] init];
        cameraVC.delegate = self;
        [self.navigationController pushViewController:cameraVC animated:NO];
        //    [self.model.photosCamera addObject:cameraVC.imageView.image];
        
        
    }
    
    [collectionView reloadData];
    
}



- (IBAction)clickBackground:(id)sender {
    [self.view endEditing:YES];
}



#pragma mark - Private Methods
-(void) createCollectionView {
    
    CGRect rectMain=[[UIScreen mainScreen] bounds];
    CGFloat scale=[[UIScreen mainScreen] scale];
    
    NSLog(@"Actual Pixel Resolution: width :% f,height :%f",rectMain.size.width * scale,rectMain.size.height * scale);
    NSLog(@" Actual Size width :% f,height :%f",rectMain.size.width ,rectMain.size.height );
    
    
    [self.activiyIndicator setHidden:YES];
    
    
    /*----------------------------------------------------------------------
     *
     * Creación, registro y configuración para la "Collections".
     *
     ------------------------------------------------------------------------*/
    
    // Configuración 'collection'
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 4.f;
    flowLayout.minimumLineSpacing = 4;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 0, 100, 0); // ** Margenes para cabeceras y pies. **
    
    // Creación 'collection'
    CGRect rect = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height);
    collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    
    // Registro Celdas
    [collectionView registerNib:[UINib nibWithNibName:kJMFPushpinCell bundle:nil] forCellWithReuseIdentifier:kJMFPushpinCell];
    
    // Registro Cabecera
    [collectionView registerClass:[JMFHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kJMFHeaderView];
    
    
    
    /* -----------------------------
     *
     * Fondo para la coleccion.
     *
     --------------------------------*/
    collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    
    
    /*-------------------------------------
     *
     * Establece delegados y notificaiones
     *
     --------------------------------------*/
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.searchTextField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFacesRects:) name:kJMFTablePhotoViewControlle object:nil];
    
    
    [self.view addSubview:collectionView];
}






@end