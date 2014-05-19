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

#import "JMFPhotoTableViewController.h"
#import "JMFLocationViewController.h"
#import "JMFCoreViewController.h"
#import "LocationViewController.h"
#import "JMFCameraViewController.h"


#import "Flickr.h"
#import "FlickrPhoto.h"
#import "Utils.h"



@interface JMFCollectionView () {
    
    NSMutableDictionary *modelDictionay;
    
    // Accesible en toda la clase
//    @property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
    UICollectionView *collectionViewPhotos;
//    FlickrPhoto *flickrPhoto;
    NSInteger sectionCamera;
}

//// Nueva version para Collection
//@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
//@property(nonatomic, weak) IBOutlet UIBarButtonItem *shareButton;
@property(nonatomic, weak) IBOutlet UITextField *textField;

//- (IBAction)shareButtonTapped:(id)sender;

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
//        modelDictionay = [[NSMutableDictionary alloc] init];
        self.model = [[JMFModel alloc] initWith];
    }
    return self;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    collectionViewPhotos = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    
    // Registro Celdas
    [collectionViewPhotos registerNib:[UINib nibWithNibName:kJMFPushpinCell bundle:nil] forCellWithReuseIdentifier:kJMFPushpinCell];
    
    // Registro Cabecera
    [collectionViewPhotos registerClass:[JMFHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kJMFHeaderView];
    
    
    
    /*
     * Fondo para la coleccion.
     */
    collectionViewPhotos.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];

    
    
    /*
     * Establece delegados
     */
    collectionViewPhotos.delegate = self;
    collectionViewPhotos.dataSource = self;
    self.searchTextField.delegate = self;
    

    [self.view addSubview:collectionViewPhotos];
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




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
            /*-----------------------------------------------------------------------------
             *
             * CABECERA para fotos tomadas con la camara.
             *
             ------------------------------------------------------------------------------*/
            ((JMFHeaderView *)titleView).label.text = @"Camara";
            
            
        } else {
            /*-----------------------------------------------------------------------------
             *
             * CABECERA para imagenes descargadas dde Flickr.
             *
             ------------------------------------------------------------------------------*/
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

        JMFPhotoTableViewController *tablePhotoVC = [[JMFPhotoTableViewController alloc] init];
        
        if (indexPath.section == 0) {  // & [self.photosCamera count]>0) {
            /*-----------------------------------------------------------------------------
             *
             * SELECCION para fotos tomadas con la camara.
             *
             ------------------------------------------------------------------------------*/
   
            /*
             * Evita que la imagen inicial de "void" en la seccion de 'Camara' se seleccione.
             * (Esta imagen 'void' índica que no hay fotos tomadas por la cámara desde la app)
             *
             */
            if ([self.model countOfPhotosCamera]) {

                //                tablePhotoVC = [[JMFPhotoTableViewController alloc] initWithImage:[self.model.imagesCamera objectAtIndex:indexPath.row]];
                JMFCamera *camera = [[JMFCamera alloc] init];
                camera = [self.model.imagesCamera objectAtIndex:indexPath.row];
                
                tablePhotoVC = [[JMFPhotoTableViewController alloc] initWithImageCamera:camera];
                
                
                [self.navigationController pushViewController:tablePhotoVC animated:YES];
            }
            
            
        } else {
            /*-----------------------------------------------------------------------------
             *
             * SELECCION para imagenes descargadas de Flickr.
             *
             ------------------------------------------------------------------------------*/
          
            
            NSString *searchTerm = self.model.termsSearchesFlickr[indexPath.section -1];
            FlickrPhoto *flickrPhoto = self.model.imagesFlickr[searchTerm][indexPath.row];
            
            tablePhotoVC = [[JMFPhotoTableViewController alloc] initWithFlickrPhoto:flickrPhoto];

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

#pragma mark – UICollectionViewDelegateFlowLayout Delegates

/************************************************
 ** Métodos para la APARIENCIA de las celdas. **
 ************************************************/

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//     return CGSizeMake(206.f, 167.f);
//    
//    // ...anulado
    CGSize retval;
    if (indexPath.section == 0) {  // & [self.photosCamera count]>0) {
        /*-----------------------------------------------------------------
         *
         * TAMAÑO para los THUMBNAILS de las fotos tomadas con la camara.
         *
         -----------------------------------------------------------------*/
        UIImage *image;
        if ([self.model countOfPhotosCamera] > 0) {
            JMFCamera *imgCamera = [[JMFCamera alloc] init];
            imgCamera = [self.model.imagesCamera objectAtIndex:indexPath.row];
            image = imgCamera.image;
        }
        else
            image = [UIImage imageNamed:@"can-stock-photo_csp12611066.png"];
 
        // Escala thumbail.
        retval = [Utils scaleFactor:image widthNewFrame:150];

        
    } else {
        /*-----------------------------------------------------------------------------
         *
         * TAMAÑO para los THUMBNAILS de las imagenes descargadas desde Flickr.
         *
         ------------------------------------------------------------------------------*/
//        NSString *searchTerm = self.searches[indexPath.section -1]; //  - [self.photosCamera count]>0 ? 1:0];
//        FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
        
        NSString *searchTerm = self.model.termsSearchesFlickr[indexPath.section -1]; //  - [self.photosCamera count]>0 ? 1:0];
        FlickrPhoto *photo = self.model.imagesFlickr[searchTerm][indexPath.row];

        // Escala thumbnail.
        CGSize frame = [Utils scaleFactor:photo.largeImage widthNewFrame:200];
        retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : frame; // CGSizeMake(200, 200);

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
        /*-----------------------------------------------------------------------------
         *
         * NUMERO de fotos tomadas con la cámara.
         *
         ------------------------------------------------------------------------------*/
//        return [self.photosCamera count];
//        return [self.model.photosCamera count];

        return MAX( 1, [self.model countOfPhotosCamera]);

    
    } else {
        /*-----------------------------------------------------------------------------
         *
         * NÚMERO de imagenes descargadas de Flickr para cada término de busquda.
         *
         ------------------------------------------------------------------------------*/
//        NSString *searchTerm = self.searches[section -1]; //- [self.photosCamera count]>0 ? 1:0];
//        return [self.searchResults[searchTerm] count];
        
//        NSString *searchTerm = self.model.termsSearchesFlickr[section -1]; //- [self.photosCamera count]>0 ? 1:0];
//        return [self.model.photosFlickrSearchResults[searchTerm] count];
        
        NSString *searchTerm = self.model.termsSearchesFlickr[section -1]; //- [self.photosCamera count]>0 ? 1:0];
//        return [self.model.photosFlickrSearchResults[searchTerm] count];
        return [self.model countOfPhotosFlickrSearchResults:searchTerm];


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
    
    JMFPushpinCell *cell = [collectionViewPhotos dequeueReusableCellWithReuseIdentifier:kJMFPushpinCell forIndexPath:indexPath];
    
//    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];

    if (indexPath.section == 0) { // & [self.photosCamera count]>0) {
        /*-----------------------------------------------------------------------------
         *
         * Sección para fotos tomadas con la camara.
         *
         ------------------------------------------------------------------------------*/

        if ([self.model countOfPhotosCamera] > 0 ) {
            //            cell.imagePhoto.image = [self.model.imagesCamera objectAtIndex:indexPath.row];
            JMFCamera *imageCamera = [[JMFCamera alloc] init];
            imageCamera = [self.model.imagesCamera objectAtIndex:indexPath.row];
            cell.imagePhoto.image = imageCamera.image;
        }

        else {
            cell.imagePhoto.image = [UIImage imageNamed:@"can-stock-photo_csp12611066.png"];
        }
        

    } else {
        
        /*-----------------------------------------------------------------------------
         *
         * Sección para imagenes descargadas de Flickr.
         *
         ------------------------------------------------------------------------------*/
        /*
        NSArray *keys = [modelDictionay allKeys];
        
        NSArray *array = [modelDictionay objectForKey:[array objectAtIndex:0]];
        cell.photo = [array objectAtIndex:indexPath.row];
        
        
//        JMFModel *mdl = (JMFModel *)[array objectAtIndex:0];
//        mdl.flickrPhoto.
//        NSString *s1 = [array objectAtIndex:0];
//        NSString *s2 = [array objectAtIndex:1];
//        NSInteger i = indexPath.section;

//        NSString *s3 = [array objectAtIndex:indexPath.section];
//        NSArray *dic = [modelDictionay objectForKey:[array objectAtIndex:indexPath.section]];
//        cell.photo = [dic objectAtIndex:indexPath.row];
        
//        NSString *searchTerm = self.model.termsSearchesFlickr[indexPath.section -1]; //- [self.photosCamera count]>0 ? 1:0];
//        cell.photo = self.model.photosSearchResultsFlickr[searchTerm][indexPath.row];
         */
        
        //        NSString *searchTerm = self.searches[indexPath.section -1]; //- [self.photosCamera count]>0 ? 1:0];
        //        cell.photo = self.searchResults[searchTerm][indexPath.row];
        
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
    
//    [self.flickr searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
    Flickr *flickr = [Flickr new];
    [flickr searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        
        if(results && [results count] > 0) {
            
            /* -----------------------------------------------------------------
             *
             *  Si no exite el término de busqueda la inserta en la posición 0.
             *
             ------------------------------------------------------------------*/
            /*
            if(![self.model.termsSearchesFlickr containsObject:searchTerm]) {
           
//                NSMutableArray *array = [[NSMutableArray alloc] init];
//                for (id result in results) {
//                    JMFModel *imagenData = [[JMFModel alloc] init];
//                    imagenData.flickrPhoto = result;
//                    [array addObject:[[JMFModel alloc]initWithFlickr:result]];
////                    [model addObject:[JMFModel;
//                }
//                [modelDictionay setObject:searchTerm
//                                   forKey:[JMFModel modelResultsFromFlickr:results]];

                
                JMFModel *image = [[JMFModel alloc] initWithFlickr:results];
                image.flfiickrPhoto =
                [modelDictionay setObject:searchTerm forKey:results];
                
                [self.model.termsSearchesFlickr insertObject:searchTerm atIndex:0];                   self.model.imagesFlickr[searchTerm] = results;
            }
       */
             
            /* -------------------------------------------------
             *
             *  Actualiza la interfaz de usuario.
             *
             ---------------------------------------------------*/
     /*
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activiyIndicator setHidden:YES];
                [collectionViewPhotos reloadData];
            });
        } else {
            NSLog(@"Error searching Flickr: %@", error.localizedDescription);
        } }];
    
    [textField resignFirstResponder];
    return YES;
    
    */
            
            //  Si no exite la busqueda la inserta en la seccón 0
            if(![self.model.termsSearchesFlickr containsObject:searchTerm]) {
                [self.model.termsSearchesFlickr insertObject:searchTerm atIndex:0];
                self.model.imagesFlickr[searchTerm] = results;
            }
            
            //  Nuevos datos: actualiza la interfaz de usuario.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activiyIndicator setHidden:YES];
                [collectionViewPhotos reloadData];
            });
        } else {
            NSLog(@"Error searching Flickr: %@", error.localizedDescription);
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

-(void)getImagePickerCamera:(UIImage *)image {

    [self.model.imagesCamera addObject:image];
    [collectionViewPhotos reloadData];
    
}


/***********************
 ** Delegado  camara **
 ***********************/

/*
#pragma mark - TakePhoto Delegate


- (void) simpleCam:(SimpleCam *)simpleCam didFinishWithImage:(UIImage *)image {
    
    if (image) {
        
        [self.model.photosCamera addObject:image];    // [self.photosCamera addObject:image];
        
        // simple cam finished with image
        
//        _imgView.image = image;
//        _tapLabel.hidden = YES;
    }
    else {
        // simple cam finished w/o image
        
//        _imgView.image = nil;
//        _tapLabel.hidden = NO;
    }
    
    [simpleCam closeWithCompletion:^{
        NSLog(@"Camara cerrada ... ");
    }];
    
    [collectionViewPhotos reloadData];
}
 */




/*.......................
 *
 ** Metodos 'Actions' **
 *
.........................*/

#pragma mark - Action Methods

- (IBAction)btnTakePhoto:(id)sender {
    


    /*
     * Pruebas sin camara. Simula haber tomado una foto.
     */
//    [self.model.imagesCamera addObject:[UIImage imageNamed:@"famous-face-dementia-617x416.jpg"]];
    JMFCamera *imageCamera = [[JMFCamera alloc] init];
    imageCamera.image = [UIImage imageNamed:@"famous-face-dementia-617x416.jpg"];
    [self.model.imagesCamera addObject:imageCamera];

    
    
    //    [self.model.photosCamera addObject:[UIImage imageNamed:@"Washington.jpg"]];
    [collectionViewPhotos reloadData];
    
    /*
     * LLamada a la camara.
     */
//    JMFCameraViewController *cameraVC = [[JMFCameraViewController alloc] init];
//    cameraVC.delegate = self;
//    [self.navigationController pushViewController:cameraVC animated:NO];
////    [self.model.photosCamera addObject:cameraVC.imageView.image];
    
    
}

- (IBAction)btnLocation:(id)sender {
    
//    LocationViewController *locationVC = [[LocationViewController alloc] initWithViewMap:self.viewMap];
    
    
//    [locationVC viewDidLoad];

    
    JMFCoreViewController *locationVC = [[JMFCoreViewController alloc] init];
    [self.navigationController pushViewController:locationVC animated:NO];
    
}

- (IBAction)btnFilters:(id)sender {
//    ViewController *vc = [ViewController new];
//    [self.navigationController pushViewController:vc animated:NO];
    
    
}

- (IBAction)clickBackground:(id)sender {
    [self.view endEditing:YES];
}


/*.......................
 *
 ** Metodos privados **
 *
 .........................*/
#pragma mark - Privates Methods



//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}


@end