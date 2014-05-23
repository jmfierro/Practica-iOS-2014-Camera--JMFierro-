//
//  JMFTablePhotoViewController.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 08/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//


#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

#import "JMFImageTableViewController.h"

#import "Flickr.h"


// Celdas
#import "CellFilters.h"
#import "CellImage.h"
#import "CellDetail.h"
#import "CellAddressLocation.h"
#import "CellUser.h"

#import "Utils.h"
#import "JMFMetaData.h"



@interface JMFImageTableViewController () {
    
    UITableView *tableViewPhotoSelectMetaData;
    CellImage *cellImage;
    
    // Localización
    CLLocation *location;
    CGFloat latitude;
    CGFloat longitude;
    BOOL isLocationData;
    BOOL isDidStartLocalization;
    CLPlacemark *infoGeocoder;
    
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


@implementation JMFImageTableViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}



/*...........................
 *
 *  ** Imagen a mostrar.  **
 *
 ...........................*/
-(id) initWithImage:(UIImage *) image {
    //-(id) initWithModel:(JMFModel *)model andImage:(UIImage *) image {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        [self loadImage:image];
        _metaData = [[JMFMetaData alloc] initWithImage:image];
    }
    
    return self;
}


/*..................................................
 *
 *  ** Imagen tomada por la camara desde la App.  **
 *
 ...................................................*/
-(id) initWithImageCamera:(JMFImageCamera *) imageCamera {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        // Imagen.
        [self loadImage:imageCamera.image];
        
        // Metadatos.
        if (imageCamera.metaData)
            _metaData = imageCamera.metaData;
        
        /* ----------------------------------------------
         *
         *  En caso de 'imageCamera' no tenga metadatos,
         * estos se sacan de los que porte la  imagen.
         *
          ----------------------------------------------*/
        else
            _metaData = [[JMFMetaData alloc] initWithImage:imageCamera.image];
        
        
        /* ---------------------------
         *
         * Datos de localizacion.
         *
         -----------------------------*/
        if (imageCamera.latitude ||imageCamera.longitude) {
            isLocationData = YES;

            latitude = imageCamera.latitude;
            longitude = imageCamera.longitude;
        
        } else {
            isLocationData = NO;
        }

    }
    
    return self;
}


/*..................................
 *
 *  ** Imagen bajada de Flickr.  **
 *
 ...................................*/
-(id) initWithFlickrPhoto:(ImageFlickr *)flickrPhoto {


    if (self = [super initWithNibName:nil bundle:nil]) {
        _imageFlickr = flickrPhoto;
        
        /*
         *  Imagen de Flickr.
         */
        if(_imageFlickr.imageLarge)
        {
            [self loadImage:_imageFlickr.imageLarge];
        }
        else
        {
            //        cell.photo.image = self.flickrPhoto.thumbnail;
            [Flickr loadImageForPhoto:self.imageFlickr thumbnail:NO completionBlock:^(UIImage *photoImage, NSError *error) {
                
                if(!error)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        /*------------------------------------------------------
                         *
                         * Cuando la imagen es descargada se actualiza los 
                         * datos de la TableView en el hilo principal.ƒ
                         *
                         ------------------------------------------------------*/
                        [self loadImage:_imageFlickr.imageLarge];
                        _metaData = [[JMFMetaData alloc] initWithImage:_imageFlickr.imageLarge];
                      
                        [tableViewPhotoSelectMetaData reloadData];
                    });
                }
                
            }];
        }
    }
    
    return self;
}


-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
//    [self registers];

    }


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /* ---------------------    ^
     *                         _|_
     * Boton para compartir   | | |
     *                        |___|
     -----------------------*/
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemAction                            target:self
                            action:@selector(btnShare:)];
    
    
    self.navigationItem.rightBarButtonItem = share;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    filtersActive = [[NSMutableDictionary alloc] init];
}


-(void)viewWillDisappear:(BOOL)animated {
    /*---------------------------    ______
     *                              | \  / |
     * Baja en Notificaciones.      |__\/__|
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
// No es llamada por usar el Navigator
-(BOOL)shouldAutorotate {
    return NO;
}

/*
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"willRotateToInterfaceOrientation") ;
}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"didRotateFromInterfaceOrientation");
    [self registers];
}

*/

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






/*..................
 *
 * ** Delegados **
 *
 ..................*/

#pragma mark - Locations Delegates
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



#pragma mark - Notificaciones


/*...........................................
 *
 *  NOTIFICACION DE: CellImage.m
 *
 *
 *  Recibe notificaciones de CellImage.m
 *  Recibe los 'CGRect' de las caras detectadas.
 *
 ...........................................*/
-(void)onFacesRects: (NSNotification *) note {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kJMFTablePhotoViewControlle object:note.object];
}


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
    
  
    // Actualiza filtros.
    if ([filtersActive objectForKey:note.object])
        [filtersActive removeObjectForKey:note.object];
    else
        [filtersActive setObject:@YES forKey:note.object];
/*
    // Recorrido y aplicación de todos los filtros activos
    self.imageAplyFilters = self.image;
    NSArray *keys = [filtersActive allKeys];
    for (id key in keys)
        self.imageAplyFilters = [Utils filterOverImage:self.imageAplyFilters nameFilter:key];
    
    
    UIImage *img = self.imageAplyFilters;
    self.imageAplyFilters = [Utils filterOverImage:self.image nameFilter:@"CISepiaTone"];
    
//    self.imageAplyFilters = nil;
 */
    [tableViewPhotoSelectMetaData reloadData];
}

/*...............................................................
 *
 *  NOTIFICACION DE: CellDetatil.m
 *
 *
 *  Recibe notificaciones de CellDetail.m
 *  Indica que opción del 'segment' ha seleccionado el usuario.
 *
 ................................................................*/
-(void)onMetaData: (NSNotification *) note {

    segment = [note.object integerValue];
    
    [tableViewPhotoSelectMetaData reloadData];
}




#pragma mark - Métodos 'Actions'
-(void)btnShare:(id)sender {
    
//    NSArray *postItem = @[@"mensaje", self.image];
    NSArray *postItem = @[@"mensaje", [Utils filterOverImage:self.image namesFilter:filtersActive]];

//    CellImage *cell = (CellImage *) [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kCellImage];
//    
//        NSArray *postItem = @[@"mensaje", cell.photoView.image];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:postItem
                                            applicationActivities:nil];
    /*
     // Actividades a excluir
     activityVC.excludedActivityTypes = @[
     UIActivityTypePostToWeibo,
     UIActivityTypeMessage,
     UIActivityTypeMail,
     UIActivityTypePrint,
     UIActivityTypeCopyToPasteboard,
     UIActivityTypeAssignToContact,
     UIActivityTypeSaveToCameraRoll,
     UIActivityTypeAddToReadingList,
     UIActivityTypePostToFlickr,
     UIActivityTypePostToVimeo,
     UIActivityTypePostToTencentWeibo,
     UIActivityTypeAirDrop];
     */
    
    [self presentViewController:activityVC animated:YES completion:nil];
}



/*...................................................
 *
 * ** Métodos privados para celdas personalizadas **
 *
 ....................................................*/

#pragma mark - Métodos privados para celdas personalizadas

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
        [indicatorLoadImagen setFrame:CGRectMake(self.view.frame.size.width/2, 261, 0, 0)];
        //        [[cell contentView] addSubview:indicatorLoadImagen];
        [[cellImage contentView] addSubview:indicatorLoadImagen];
        
        [indicatorLoadImagen startAnimating];
        [indicatorLoadImagen setHidesWhenStopped:YES];
    }
    else {
        [indicatorLoadImagen stopAnimating];
        
    }
    
    
//    //    cell.photoView.image = self.image;
//    if (self.imageAplyFilters) {
//        cellImage.photoView.image = self.imageAplyFilters;
//    } else {
//        cellImage.photoView.image = self.image;
//    }
    
    cellImage.photoView.image = [Utils filterOverImage:self.image namesFilter:filtersActive];
    
    return cellImage;
    
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
    
  
    
    cell.imgFilter1.image = [Utils filterOverImage:self.imageThumbnail nameFilter:@"CISepiaTone"];
    cell.imgFilter2.image = [Utils filterOverImage:self.imageThumbnail nameFilter:@"CIPhotoEffectProcess"];
    cell.imgFilter3.image = [Utils filterOverImage:self.imageThumbnail nameFilter:@"CIPixellate"];
    cell.imgFilter4.image = [Utils filterOverImage:self.imageThumbnail nameFilter:@"CIPinchDistortion"];
    cell.imgFilter5.image = [Utils filterOverImage:self.imageThumbnail nameFilter:@"CIPerspectiveTransform"];
    
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
    if (self.imageFlickr.title)
        cell.lblTitle.text = self.imageFlickr.title;
    if (self.imageFlickr.description)
        cell.lblDescription.text = self.imageFlickr.description;
    
    
    
    //        self.flickrPhoto.description;
    
    //    if (self.flickrPhotoModel) {
    if (segment == kCellDetailSegmentFlickr) {
        cell = [self writerDatosFlickr:cell];
        
    } else if (segment == kCellDetailSegmentGeneralMetaData){
        cell = [self writerGeneralMetaDatos:cell];
        
    } else if (segment == kCellDetailSegmentExifMetaData){
        cell = [self writerExifMetaDatos:cell];
        
    } else if (segment == kCellDetailSegmentJFIFMetaData){
        cell = [self writerJFIFMetaDatos:cell];
        
    } else if (segment == kCellDetailSegmentTIFFMetaData){
        cell = [self writerTIFFMetaDatos:cell];
    }
    
    
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
    
    
//    if (locationUser) {
//        cell.lblLoacationOrigin.text = @"Localización del usuario";
//    } else
//        cell.lblLoacationOrigin.text = @"Localización de la imagen";
    
    //    CLLocation *lastLocation = [CLLocation alloc  ini]CLLocationCoordinate2DMake(30.0f, -3.0f);
    //
    //    [location.coordinate setLatitude:30];
    //    location.coordinate = CLLocationCoordinate2DMake(43.0f, -3.0f);
    
    //            JMFLocationViewController *lVC = [[JMFLocationViewController alloc] initWithMapView:cell.mapkit];
    //        lVC.delegate = self;
    
    if (!isDidStartLocalization) {
        isDidStartLocalization = YES;
        
        if (!isLocationData) {
            latitude = location.coordinate.latitude;
            longitude = location.coordinate.longitude;
        }
        
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
                    
                    // Anotacion con la información
                    MKPointAnnotation *chincheta = [[MKPointAnnotation alloc] init];
                    chincheta.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                    chincheta.title = [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"Country"];
                    NSString *msg;
                    
                    /*------------------------------------------------------------
                     *
                     * Muestra informacion sobre el origen de la localización:
                     *      - de la imagen.
                     *      - del usuario.
                     *
                     -------------------------------------------------------------*/
                    if (!isLocationData) {
                        msg = [NSString stringWithFormat:@"%@ (%@)",[[infoGeocoder addressDictionary] objectForKey:(NSString*)@"State"],@"Usuario"];
                    } else {
                        msg = [NSString stringWithFormat:@"%@ (%@)",[[infoGeocoder addressDictionary] objectForKey:(NSString*)@"State"],@"Imagen"];
                    }
                    
                    chincheta.subtitle = msg;
                  
                    [cell.mapView addAnnotation:chincheta];
                    
                    // Despliega la anotación
                    [cell.mapView selectAnnotation:chincheta animated:YES];
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
    
    return cell;
    
}


/*.....................................
 *
 * Añadiendo imagen a la localizacion.
 *
 ......................................*/
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
//    if ([[annotation title] isEqualToString:@"Current Location"]) {
//        return nil;
//    }
    
    MKAnnotationView *annView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    /*
    if ([[annotation title] isEqualToString:@"McDonald's"])
        annView.image = [ UIImage imageNamed:@"mcdonalds.png" ];
    else if ([[annotation title] isEqualToString:@"Apple store"])
        annView.image = [ UIImage imageNamed:@"applestore.png" ];
    else
        annView.image = [ UIImage imageNamed:@"marker.png" ];
     */
    
    /*
     * Añade imagen al mapa.
     */
    /*
    UIImage *img = [ UIImage imageNamed:@"PILAR-GARCIA-MUÑIZ-JOSE-ANGEL-LEIRAS-MAS-GENTE.jpg" ];
    annView.image = [Utils imageToThumbnail:img Size:CGSizeMake(70, 70)];
     //    annView.calloutOffset = CGPointMake(0, 32);
    */
    
    /*
     * Añade imagen dentro de la anotación.
     */
//    UIImage *img = [ UIImage imageNamed:@"PILAR-GARCIA-MUÑIZ-JOSE-ANGEL-LEIRAS-MAS-GENTE.jpg" ];
//    img = [Utils imageToThumbnail:img Size:CGSizeMake(70, 70)];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[Utils imageToThumbnail:self.image Size:CGSizeMake(70, 70)]];
    annView.leftCalloutAccessoryView = iconView;
    
    /*
     * Añade boton dentro de  anotación.
     */
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [infoButton addTarget:self action:@selector(showDetailsView)
         forControlEvents:UIControlEventTouchUpInside];
    annView.rightCalloutAccessoryView = infoButton;
    annView.canShowCallout = YES;
    
    return annView;
}

-(void)showDetailsView {
    
    NSString *msg;
    if (!isLocationData)
        msg = @"Ni el \"Modelo\" ni los \"Metadatos\" de la imagen proporcionan información sobre la localización. Se muestra la situación actual del usuario.";
    else
        msg = @"Localización proporcionada por el \"Modelo\" o los \"Metadatos\" de la imagen.";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Localización" message:msg delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Metodos privados



-(CellDetail *) writerDatosFlickr:(CellDetail *) cell {
    
    cell = [self writerEraserMetaDatos:cell];
    
    cell.lbl1.text = @"ID:";
    if (self.imageFlickr.ID)
        cell.lbl1content.text = [[NSString alloc] initWithFormat:@"%lld", self.imageFlickr.ID];
    
    cell.lbl2.text = @"Farm:";
    if (self.imageFlickr.farm)
        cell.lbl2content.text = [[NSString alloc] initWithFormat:@"%d", self.imageFlickr.farm];
    
    cell.lbl3.text = @"Servidor:";
    if (self.imageFlickr.server)
        cell.lbl3content.text = [[NSString alloc] initWithFormat:@"%d", self.imageFlickr.server];
    
    cell.lbl4.text = @"Secreto:";
    if (self.imageFlickr.secret)
        cell.lbl4content.text = self.imageFlickr.secret;
    
    cell.lbl5.text = @"Familia:";
    if (self.imageFlickr.isfamily)
        cell.lbl5content.text = self.imageFlickr.isfamily;
    
    cell.lbl6.text = @"Amigo:";
    if (self.imageFlickr.isfriend)
        cell.lbl6content.text = self.imageFlickr.isfriend;
    
    cell.lbl7.text = @"Publico:";
    if (self.imageFlickr.ispublic)
        cell.lbl7content.text = self.imageFlickr.ispublic;
    
    cell.lbl8.text = @"Propietario:";
    if (self.imageFlickr.owner)
        cell.lbl8content.text = self.imageFlickr.owner;
    
    return cell;
}


-(CellDetail *) writerGeneralMetaDatos:(CellDetail *) cell {
    
    cell = [self writerEraserMetaDatos:cell];
    
    cell.lbl1.text = @"Color";
    cell.lbl1content.text = [self.metaData.allMetaData objectForKey:@"ColorModel"];
    
    cell.lbl2.text = @"Profundidad";
    cell.lbl2content.text = [NSString stringWithFormat:@"%@",[self.metaData.allMetaData objectForKey:@"Depth"]];
    
    cell.lbl3.text = @"Orientacion";
    cell.lbl3content.text = [NSString stringWithFormat:@"%@",[self.metaData.allMetaData objectForKey:@"Orientation"]];
    
    cell.lbl5.text = @"Alto";
    cell.lbl5content.text = [NSString stringWithFormat:@"%@",[self.metaData.allMetaData objectForKey:@"PixelHeight"]];
    
    cell.lbl6.text = @"Ancho";
    cell.lbl6content.text = [NSString stringWithFormat:@"%@",[self.metaData.allMetaData objectForKey:@"PixelWidth"]];
    
    
    return cell;
}


-(CellDetail *) writerExifMetaDatos:(CellDetail *) cell {
    
    cell = [self writerEraserMetaDatos:cell];
    
    cell.lbl1.text = @"Color S.";
    cell.lbl1content.text = [NSString stringWithFormat:@"%@",[self.metaData.EXIFDictionary objectForKey:@"ColorSpace"]];
    
    cell.lbl2.text = @"XDimension";
    cell.lbl2content.text = [NSString stringWithFormat:@"%@",[self.metaData.EXIFDictionary objectForKey:@"PixelXDimension"]];
    
    cell.lbl3.text = @"YDimension";
    cell.lbl3content.text = [NSString stringWithFormat:@"%@",[self.metaData.EXIFDictionary objectForKey:@"PixelYDimension"]];
    
    
    return cell;
}

-(CellDetail *) writerJFIFMetaDatos:(CellDetail *) cell {
    
    cell = [self writerEraserMetaDatos:cell];
    
    cell.lbl1.text = @"Densidad (ud)";
    cell.lbl1content.text = [NSString stringWithFormat:@"%@",[self.metaData.JFIFDictionary objectForKey:@"DensityUnit"]];
    
    NSArray *array  = [self.metaData.JFIFDictionary objectForKey:@"JFIFVersion"];
//    NSString *string = [[array valueForKey:@"description"] componentsJoinedByString:@""];
    cell.lbl2.text = @"JFIF versión";
    cell.lbl2content.text = [NSString stringWithFormat:@"%@.%@",array[0],array[1]];
    
    cell.lbl5.text = @"XDensidad";
    cell.lbl5content.text = [NSString stringWithFormat:@"%@",[self.metaData.JFIFDictionary objectForKey:@"XDensity"]];
    
    cell.lbl6.text = @"YDensidad";
    cell.lbl6content.text = [NSString stringWithFormat:@"%@",[self.metaData.JFIFDictionary objectForKey:@"YDensity"]];
    
    
    return cell;
}

-(CellDetail *) writerTIFFMetaDatos:(CellDetail *) cell {
    
    cell = [self writerEraserMetaDatos:cell];
    
    cell.lbl1.text = @"Orientacion";
    cell.lbl1content.text = [NSString stringWithFormat:@"%@",[self.metaData.TIFFDictionary objectForKey:@"Orientation"]];
    
    
    return cell;
}



-(CellDetail *) writerEraserMetaDatos:(CellDetail *) cell {
    
    cell.lbl1.text = @"";
    cell.lbl1content.text = @"";
    
    cell.lbl2.text = @"";
    cell.lbl2content.text = @"";
    
    cell.lbl3.text = @"";
    cell.lbl3content.text = @"";
    
    cell.lbl5.text = @"";
    cell.lbl5content.text = @"";
    
    cell.lbl6.text = @"";
    cell.lbl6content.text = @"";
    
    cell.lbl4.text = @"";
    cell.lbl4content.text = @"";
    
    cell.lbl7.text = @"";
    cell.lbl7content.text = @"";
    
    cell.lbl8.text = @"";
    cell.lbl8content.text = @"";
    
    return cell;
}





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


-(void) loadImage:(UIImage *) image {
    
    
    // Inicializa locations, tableView, celdas.
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
    
}





-(void) registers {
    
  
    /*----------------------------
     *
     * Localización.
     *
     -----------------------------*/
    /*
     *  La imagen contiene información de GPS.
     */
    NSDictionary *gps = [self.metaData GPSDictionary];
    if ([gps objectForKey:kCGImagePropertyGPSLatitude] &&
        [gps objectForKey:kCGImagePropertyGPSLongitude]) {
        
        latitude = [[gps objectForKey:kCGImagePropertyGPSLatitude] floatValue];
        longitude = [[gps objectForKey:kCGImagePropertyGPSLongitude] floatValue];
        isLocationData = YES;
        
        
        /*
         *  La imagen no contiene información de GPS. 
         *  Se obtiene la localización del usuario.
         */
    } else {
        [self startLocation];
        isLocationData = NO;
    }
    
    
    
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
    [center addObserver:self selector:@selector(onFacesRects:) name:kCellImage object:nil];
    [center addObserver:self selector:@selector(onFilters:) name:kCellFilters object:nil];
    [center addObserver:self selector:@selector(onMetaData:) name:kCellDetail object:nil];

}


@end
