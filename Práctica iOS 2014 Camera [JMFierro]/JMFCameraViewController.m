//
//  JMFCameraViewController.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 09/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//



#import "JMFCameraViewController.h"

#define kIsCamera @"camera"
#define kIsCameraRoll @"cameraRoll"

@interface JMFCameraViewController () {
    
    CLLocationManager *managerLocation;
    CLLocation *lastLocation;
    
    JMFImageCamera *imageCamera;
    NSString *getImage;
    BOOL newMedia;
}

@end

@implementation JMFCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        imageCamera = [[JMFImageCamera alloc] init];
    }
    return self;
}

-(id)initWithCamera {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        getImage = kIsCamera;
    }
    return self;
}

-(id)initWithCameraRoll {
    if (self = [super initWithNibName:nil bundle:nil]) {
        getImage = kIsCameraRoll;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imageCamera = [[JMFImageCamera alloc] init];
    if (getImage == kIsCamera) {
        [self useCameraRoll:nil];
        
    } else if (getImage == kIsCameraRoll) {
        [self useCameraRoll:nil];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*......................................................................
 *
 *     TOMA FOTOS DE LA CAMARA
 *
 *  Comprueba que el dispositivo cuenta con una cámara.
 *  Instancia *'UIImagePickerController'*.
 *  Asigna el delegado
 *  Y configura (la cámara de fotos, sin video).
 *
 ......................................................................*/


- (IBAction)useCamera:(id)sender {
    
    /* -----------------------
     *
     * Localización.
     *
     -------------------------*/
    if ([CLLocationManager locationServicesEnabled]) {
        managerLocation = [[CLLocationManager alloc] init];
        managerLocation.desiredAccuracy = kCLLocationAccuracyBest;
        managerLocation.delegate = self;
        
        [managerLocation startUpdatingLocation];
    }

    
    /* -----------------
     *
     * Camara de fotos.
     *
     -------------------*/
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Dispositivo sin cámara"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancelar"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        [self.navigationController popToRootViewControllerAnimated:FALSE];
        
    }else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        newMedia = YES;  // La imagen es nueva y no una existente desde la 'Camera Roll'.
    }
    
}


/*......................................................................
 *
 *     SELECCIONA UNA FOTO ALMECENADA EN EL DISPOSITIVO.
 *
 *  Comprueba que el dispositivo cuenta con una cámara.
 *  Instancia *'UIImagePickerController'*.
 *  Asigna el delegado
 *  Y Define el origen de los medios (la cámara de fotos, sin video).
 *
 ......................................................................*/

- (IBAction)useCameraRoll:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        newMedia = NO;
    }
}


#pragma mark UIImagePickerController Delegate

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)dictionary
{
    
    [picker dismissModalViewControllerAnimated:YES];
    
    NSData *dataOfImageFromGallery = UIImageJPEGRepresentation (image,0.5);
    NSLog(@"Image length:  %d", [dataOfImageFromGallery length]);
    
    
    CGImageSourceRef source;
    source = CGImageSourceCreateWithData((CFDataRef)dataOfImageFromGallery, NULL);
    
    NSDictionary *metadata = (NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    
    NSMutableDictionary *metadataAsMutable = [[metadata mutableCopy]autorelease];
    [metadata release];
    
    NSMutableDictionary *EXIFDictionary = [[[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyExifDictionary]mutableCopy]autorelease];
    NSMutableDictionary *GPSDictionary = [[[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGPSDictionary]mutableCopy]autorelease];
    
    
    if(!EXIFDictionary)
    {
        //if the image does not have an EXIF dictionary (not all images do), then create one for us to use
        EXIFDictionary = [NSMutableDictionary dictionary];
    }
    
    if(!GPSDictionary)
    {
        GPSDictionary = [NSMutableDictionary dictionary];
    }
    
    //Setup GPS dict -
    //I am appending my custom data just to test the logic……..
    
    [GPSDictionary setValue:[NSNumber numberWithFloat:1.1] forKey:(NSString*)kCGImagePropertyGPSLatitude];
    [GPSDictionary setValue:[NSNumber numberWithFloat:2.2] forKey:(NSString*)kCGImagePropertyGPSLongitude];
    [GPSDictionary setValue:@"lat_ref" forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    [GPSDictionary setValue:@"lon_ref" forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    [GPSDictionary setValue:[NSNumber numberWithFloat:3.3] forKey:(NSString*)kCGImagePropertyGPSAltitude];
    [GPSDictionary setValue:[NSNumber numberWithShort:4.4] forKey:(NSString*)kCGImagePropertyGPSAltitudeRef];
    [GPSDictionary setValue:[NSNumber numberWithFloat:5.5] forKey:(NSString*)kCGImagePropertyGPSImgDirection];
    [GPSDictionary setValue:@"_headingRef" forKey:(NSString*)kCGImagePropertyGPSImgDirectionRef];
    
    [EXIFDictionary setValue:@"xml_user_comment" forKey:(NSString *)kCGImagePropertyExifUserComment];
    //add our modified EXIF data back into the image’s metadata
    [metadataAsMutable setObject:EXIFDictionary forKey:(NSString *)kCGImagePropertyExifDictionary];
    [metadataAsMutable setObject:GPSDictionary forKey:(NSString *)kCGImagePropertyGPSDictionary];
    
    CFStringRef UTI = CGImageSourceGetType(source);
    NSMutableData *dest_data = [NSMutableData data];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef) dest_data, UTI, 1, NULL);
    
    if(!destination)
    {
        NSLog(@"--------- Could not create image destination---------");
    }
    
    
    CGImageDestinationAddImageFromSource(destination, source, 0, (CFDictionaryRef) metadataAsMutable);
    
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);
    
    if(!success)
    {
        NSLog(@"-------- could not create data from image destination----------");
    }
    
    UIImage * image1 = [[UIImage alloc] initWithData:dest_data];
    UIImageWriteToSavedPhotosAlbum (image1, self, nil, nil);    
}
*/
 
 
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSDictionary *metadata = [info valueForKey:UIImagePickerControllerMediaMetadata];
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    /* ----------------------
     *
     * En caso de fotografia.
     *
     ------------------------*/
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
//        UIImage *img = [JMFMetaData addMetaData:info[UIImagePickerControllerOriginalImage] Location:lastLocation];
        
        imageCamera.image = [JMFMetaData addMetaData:info[UIImagePickerControllerOriginalImage] Location:lastLocation];
        
        /* ---------------------
         *
         * Llamada al delegado.
         *
         -----------------------*/
        [self.delegate getImagePickerCamera:imageCamera];
        
        
        
        /* ---------------
         *
         * Guarda imagen.
         *
         -----------------*/
        UIImageWriteToSavedPhotosAlbum(imageCamera.image,
                                       self,
                                       @selector(image:finishedSavingWithError:contextInfo:),
                                       nil);
        
    }
    

    /* -------------------
     *
     * En caso de video.
     *
     ---------------------*/
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        
    }
    
     [self.navigationController popToRootViewControllerAnimated:NO];
}



- (NSDictionary *) gpsDictionaryForLocation:(CLLocation *)location {
    CLLocationDegrees exifLatitude  = location.coordinate.latitude;
    CLLocationDegrees exifLongitude = location.coordinate.longitude;
    
    NSString * latRef;
    NSString * longRef;
    if (exifLatitude < 0.0) {
        exifLatitude = exifLatitude * -1.0f;
        latRef = @"S";
    } else {
        latRef = @"N";
    }
    
    if (exifLongitude < 0.0) {
        exifLongitude = exifLongitude * -1.0f;
        longRef = @"W";
    } else {
        longRef = @"E";
    }
    
    NSMutableDictionary *locDict = [[NSMutableDictionary alloc] init];
    
    [locDict setObject:location.timestamp forKey:(NSString*)kCGImagePropertyGPSTimeStamp];
    [locDict setObject:latRef forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    [locDict setObject:[NSNumber numberWithFloat:exifLatitude] forKey:(NSString *)kCGImagePropertyGPSLatitude];
    [locDict setObject:longRef forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    [locDict setObject:[NSNumber numberWithFloat:exifLongitude] forKey:(NSString *)kCGImagePropertyGPSLongitude];
    [locDict setObject:[NSNumber numberWithFloat:location.horizontalAccuracy] forKey:(NSString*)kCGImagePropertyGPSDOP];
    [locDict setObject:[NSNumber numberWithFloat:location.altitude] forKey:(NSString*)kCGImagePropertyGPSAltitude];
    
    return locDict;
 }



-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: @"Fallo al guardar imagen"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Loaction Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"Cambio de localizacion (JMFCamera.m)");
    
    //    CLLocation *lastLocation = [locations lastObject];
    lastLocation = [locations lastObject];
    imageCamera.latitude = lastLocation.coordinate.latitude;
    imageCamera.longitude = lastLocation.coordinate.longitude;
    
    [managerLocation stopUpdatingLocation];
}


@end
