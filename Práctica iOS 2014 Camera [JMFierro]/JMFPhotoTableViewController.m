//
//  JMFTablePhotoViewController.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 08/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <ImageIO/ImageIO.h>

#import "JMFPhotoTableViewController.h"
#import "JMFLocationViewController.h"
#import "Flickr.h"

// Celdas
#import "ImageCell.h"
#import "DetailLocationCell.h"
#import "AddressLocationCell.h"
#import "UserCell.h"

#define kCellImage




@interface JMFPhotoTableViewController () {
    

    UITableView *tableViewPhotoSelectMetaData;
    
    // Localización
    JMFLocationViewController *locationVC;
    CLLocation *location;
    CLPlacemark *infoGeocoder;
    
    // Altura de las celdas
    CGFloat height_CellImage;
    CGFloat height_CellDetalle;
    CGFloat height_CellAddress;
    CGFloat height_CellUser;
    
}

    @property (nonatomic, strong) UITableViewCell *prototypeCell;

@end


@implementation JMFPhotoTableViewController


#pragma mark - Init methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


/*....................................
 *
 *  ** Imagen bajada de Flickr.  **
 *
 .....................................*/
-(id) initWithFlickrPhoto:(FlickrPhoto *)flickrPhoto {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _flickrPhoto = flickrPhoto;
        
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
        _image = image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /*
     * Localizacion
     */
    locationVC = [[JMFLocationViewController alloc] init];
    locationVC.delegate = self;
    
    
    /*
     * Creación de la Tableview.
     */
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
    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kImageCell bundle:nil] forCellReuseIdentifier:kImageCell];
    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kDetalleCell bundle:nil] forCellReuseIdentifier:kDetalleCell];
    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kAddressCell bundle:nil] forCellReuseIdentifier:kAddressCell];
    [tableViewPhotoSelectMetaData registerNib:[UINib nibWithNibName:kUserCell bundle:nil] forCellReuseIdentifier:kUserCell];
    
    
    // Añade la tabla a la vista del controlador
    [self.view addSubview:tableViewPhotoSelectMetaData];
    
    // Guarda altura de las celdas personalizadas
    UITableViewCell *cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kImageCell];
    height_CellImage = cell.frame.size.height;
    cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kDetalleCell];
    height_CellDetalle = cell.frame.size.height;
    cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kAddressCell];
    height_CellAddress = cell.frame.size.height;
    cell = [tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kUserCell];
    height_CellUser = cell.frame.size.height;

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

#pragma mark - Tableview delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     * Para cada celda muestra una información diferente.
     */
    
    if (indexPath.row == 0) {
        
        /** ------------------------------------------------------------------
         *
         *  CELDA:
         *
         *      - Imagen
         *
         ---------------------------------------------------------------------*/
        return [self cellImage:tableView cellForRowAtIndexPath:indexPath];
        
        
    } else if (indexPath.row == 1) {
        /** ------------------------------------------------------------------
         *
         *  CELDA:
         *
         *       - Titulo
         *       - Descripción
         *
         ---------------------------------------------------------------------*/
        return [self cellDetail:tableView cellForRowAtIndexPath:indexPath];
        
        
        
    } else if (indexPath.row == 2) {
        
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
        
    } else if (indexPath.row == 3) {
        
        UserCell * cell = (UserCell *)[tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kUserCell];
        
        return cell;
        
        
        
    }
    
    else {
        
        return nil;
    }

}



/*............................................
 *
 * ** Desactivacion de la seleccion de los **
 * ** elementos de la 'TableView'          **
 *
 .............................................*/

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
        return height_CellImage;   // 600;
    else if (indexPath.row == 1)
        return height_CellDetalle;  // 249.f;
    else if (indexPath.row == 2)
        return height_CellAddress;    // 400.f;
    else if (indexPath.row == 3)
        return height_CellUser;   // 234.f;
    else
        return 0;

}




/*..............................
 *
 * ** Cambios de orientacion **
 *
 ...............................*/
-(BOOL)shouldAutorotate {
    return NO;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // grab the window frame and adjust it for orientation
    UIView *rootView = [[[UIApplication sharedApplication] keyWindow]
                        rootViewController].view;
    CGRect originalFrame = [[UIScreen mainScreen] bounds];
    CGRect adjustedFrame = [rootView convertRect:originalFrame fromView:nil];
    
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

-(UITableViewCell *) cellImage:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /** ------------------------------------------------------------------
     *
     *  CELDA:
     *
     *      - Imagen
     *
     ---------------------------------------------------------------------*/
    ImageCell *cell = (ImageCell *) [tableView dequeueReusableCellWithIdentifier:kImageCell];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // Locate spinner in the center of the cell at end of text
    [spinner setFrame:CGRectMake(768/2, 261, 0, 0)];
    [[cell contentView] addSubview:spinner];
    
    [spinner startAnimating];
    [spinner setHidesWhenStopped:YES];
    

    /*
     *  Imagen de la cámara.
     */
    if (self.image) {
        
        [spinner stopAnimating];
        
        cell.photo.image = self.image;
    }
    
    /*
     *  Imagen de Flickr.
     */
    else {
        if(self.flickrPhoto.largeImage)
        {
            [spinner stopAnimating];
            //                [spinner setHidden:YES];
            cell.photo.image = self.flickrPhoto.largeImage;
            //                [tableViewPhotoSelectMetaData reloadData];
            
            //            cell.imagePhotoFlickr.image = [UIImage imageNamed:@"famous-face-dementia-617x416.jpg"];
        }
        else
        {
            //        cell.photo.image = self.flickrPhoto.thumbnail;
            [Flickr loadImageForPhoto:self.flickrPhoto thumbnail:NO completionBlock:^(UIImage *photoImage, NSError *error) {
                
                [spinner stopAnimating];
                //                    [spinner setHidden:YES];
                
                if(!error)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.photo.image = self.flickrPhoto.largeImage;
                        //                        cell.imagePhotoFlickr.image = [UIImage imageNamed:@"famous-face-dementia-617x416.jpg"];
                        
                        [tableViewPhotoSelectMetaData reloadData];
                    });
                }
                
            }];
        }
    }
    
    
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
     ---------------------------------------------------------------------*/
    DetailLocationCell * cell = (DetailLocationCell *)[tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kDetalleCell];
    
    //        self.flickrPhoto.description;
    cell.lblTitle.text = self.flickrPhoto.title;
    cell.lblDescription.text = self.flickrPhoto.description;
    
    //        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)self.flickrPhoto.largeImage, NULL);
    //        CFDictionaryRef imageMetaData = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    //        NSDictionary *objectCollection = (__bridge NSDictionary*)imageMetaData;
    //
    
    
    //        NSData* pngData =  UIImagePNGRepresentation(self.flickrPhoto.largeImage);
    //
    //        NSURL *imageFileURL = [NSURL fileURLWithPath:...];
    //        CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)imageFileURL, NULL);
    //
    //        if (imageSource == NULL) { // Error loading image ... return;
    //        		}
    //
    //        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:NO], (NSString *)kCGImageSourceShouldCache, nil];
    //
    //        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (CFDictionaryRef)options);
    //
    //        if (imageProperties) { NSNumber *width = (NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth); NSNumber *height = (NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
    //
    //            NSLog(@"Image dimensions: %@ x %@ px", width, height); CFRelease(imageProperties); }
    //
    //
    //        CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)CFBridgingRetain(pngData), NULL);
    //        NSDictionary *metadata = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, 0, NULL));
    //
    
    
    
    
    
//    // Adjust cell frame width to be equal to tableview frame width
//    cell.frame = CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height);
//    
//    
//    //        UITableViewCell *cell = nil;
//    // add width of table to the name so that rotations will change the cell dequeue names
//    NSString *s_cell = [s_cell stringByAppendingString:
//                        [NSString stringWithFormat:@"%@%d",@"Width",(int)tableView.bounds.size.width]
//                        ];
//    
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    
//    NSLog(@"\n--- %f",width);
    
    
       
    //        cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    //        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
    //            CGRect newFrame = customCell.frame;
    //            newFrame.size.width = newFrame.size.width+160;
    //            customCell.frame = newFrame;
    //        }
    
    
    //        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
    //            //Make labels smaller
    //        }
    //        else {
    //            //Make them bigger
    //        }
    
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
    AddressLocationCell * cell = (AddressLocationCell *)[tableViewPhotoSelectMetaData dequeueReusableCellWithIdentifier:kAddressCell];
    //
    //        JMFLocationViewController *lVC = [[JMFLocationViewController alloc] initWithMapView:cell.mapkit];
    //        lVC.delegate = self;
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *userCLLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    //    [geocoder reverseGeocodeLocation:userCLLocation completionHandler:^(NSArray *placemarks. NSError )];
    
    //    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //    CLLocation *userCLLocation = [[CLLocation alloc] itWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    //        __block JMFLocationViewController *weakSelf = self;
    [geocoder reverseGeocodeLocation:userCLLocation completionHandler:^(NSArray *placemarks, NSError *error) {
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
            
            
            [cell.mapkit setMapType:MKMapTypeHybrid];
            cell.mapkit.rotateEnabled = YES;
            cell.mapkit.zoomEnabled = YES;
            cell.mapkit.pitchEnabled = YES;
            cell.mapkit.showsBuildings = YES;
            cell.mapkit.showsUserLocation = YES;
            cell.mapkit.delegate = self;
            
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                MKPointAnnotation *chincheta = [[MKPointAnnotation alloc] init];
                chincheta.coordinate = CLLocationCoordinate2DMake(40.0f, -3.0f);
                chincheta.title = @"Chincheta";
                chincheta.subtitle = @"texto ejemplo";
                
                [cell.mapkit addAnnotation:chincheta];
            });
            
            
            
            
            [tableView reloadData];
        }
    }];
    
    
    
    
    // Localizacion
    cell.lblLatitud.text = [[NSString alloc] initWithFormat:@"%.6f %@",location.coordinate.latitude, @"lat"];
    cell.lblLongitud.text = [[NSString alloc] initWithFormat:@"%.6f %@", location.coordinate.longitude, @"long"];
    
    NSString *direccion = [[infoGeocoder addressDictionary] objectForKey:(NSString*)@"Street"];
    
    cell.lblGeolocalizacion.text = direccion;
    
    cell.lblOwer.text = self.flickrPhoto.owner;
    
    cell.lblSecret.Text = [[NSString alloc] initWithFormat:@"%@ %@", self.flickrPhoto.secret, @"secret"];
    
    
    return cell;
    
}



-(void) setLastLocation:(CLLocation *)aLastLocation {
    location = aLastLocation;
}

-(void) setInfoGeocoder:(CLPlacemark *)aInfo {
    infoGeocoder = aInfo;
}


//#pragma mark - carga de modelo
//- (void)loadDataModel{
//    
//   
//
////    FlickrPhoto *flickrPhoto = [self.delegate getFlickrPhoto];
//    
//    modelo = @[@"Madrid",
//               @"Granada",
//               @"Sevilla",
//               @"Cuenca"];
//}

@end
