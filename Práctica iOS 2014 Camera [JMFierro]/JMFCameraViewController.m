//
//  JMFCameraViewController.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 09/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "JMFCameraViewController.h"

@interface JMFCameraViewController ()

@end

@implementation JMFCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self useCamera:nil];
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
        self.newMedia = YES;  // La imagen es nueva y no una existente desde la 'Camera Roll'.
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
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        self.newMedia = NO;
    }
}


#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _imageView.image = image;
        
        [self.delegate getImagePickerCamera:image];
        
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    // En caso de video.
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        
    }
    
     [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
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

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
