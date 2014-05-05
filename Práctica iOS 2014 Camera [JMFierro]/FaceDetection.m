//
//  FaceDetection.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "FaceDetection.h"

@implementation FaceDetection

/*...........................................................................................
 *
 *    Recibe el UIImageView que contiene la imagen en la que detectar las caras.
 *
 *    Devuelve:
 *
 *          - UIView *imageView  : contiene la imagen con las caras detectadas mediante un cuadrado.
 *          - NSInteger numFaces : número de caras detectadas.
 *
 ..............................................................................................*/
-(id) initWithImagenView:(UIImageView *) aImageView numFaces:(NSNumber *)aNumFaces {
//    -(UIView *) initWithImagenView:(UIImageView *) aImageView numFaces:(NSNumber *)aNumFaces {
//    -(UIView *) initWithImagenView:(UIImageView *) aImageView getNumFaces:(UILabel *)lblNumFaces {
    
    UIImageView *imageView = aImageView;
    
    CIImage *imageCI=[[CIImage alloc] initWithImage:imageView.image];
    
    
    /*-----------------------------------------------------------------------------
     *
     *  Calcula la ESCALA a la que se muestra la foto en el 'content view',
     * se usa para reposionar en su lugar las coordenadas de las caras
     * encontradas en la imagen de tamaño original.
     *
     *  Tambien el MARGENES entre el 'content view' y la imagen al mostrala en él.
     *
     -----------------------------------------------------------------------------*/
    
    CGFloat newWidthtImage, newHeightImage;
    if (imageView.image.size.width > imageView.image.size.height) {
        
        // Regla del 3
        newHeightImage = (imageView.image.size.height*imageView.bounds.size.width)/imageView.image.size.width;
        newWidthtImage = imageView.bounds.size.width;
        
    } else {
        
        // Regla del 3
        newWidthtImage = (imageView.image.size.width * imageView.bounds.size.height)/imageView.image.size.height;
        newHeightImage = imageView.bounds.size.height;
        
    }
    
    // Escala
    CGFloat scaleWidth = newWidthtImage/imageView.image.size.width;
    CGFloat scaleHeight = newHeightImage/imageView.image.size.height;
    
    // Margenes
    CGFloat margenX = (imageView.bounds.size.width - newWidthtImage)/2;
    CGFloat margenY = (imageView.bounds.size.height - newHeightImage)/2;
    
    
    /* -------------------------
     *
     * ** Detección de caras **
     *
     --------------------------*/
    // Crear un 'face detector' - uso de 'high accuracy'
    CIDetector* detectorFaces=[CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    
    // Crea un array con las caras detectadas.
    NSArray *facesArray=[detectorFaces featuresInImage:imageCI];
//    lblNumFaces.text = [NSString stringWithFormat:@"%lu",(unsigned long)[facesArray count]];
    aNumFaces = [[NSNumber alloc] initWithUnsignedLong:(unsigned long)[facesArray count]];
    self.numFaces = [facesArray count];
    NSLog(@"%d",[facesArray count]);
    
//    NSLog(@"image width:%f",self.photoView.image.size.width);
//    NSLog(@"view width:%f",self.photoView.bounds.size.width);
//    NSLog(@"image height:%f",self.photoView.image.size.height);
//    NSLog(@"view height:%f",self.photoView.bounds.size.height);
    
    
    UIView *frameViewImagen=[[UIView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height)];
    
    
    /*
     * Iterar rostros detectados.
     *
     *    Anchura para toda la cara, y las coordenadas de cada ojo.
     *    Boca si es detectada.
     */
    for (CIFaceFeature * face in facesArray) {
        
        UIView *frameViewFace=[[UIView alloc]initWithFrame:CGRectMake((face.bounds.origin.x * scaleWidth) + margenX, (face.bounds.origin.y * scaleHeight) + margenY, face.bounds.size.width * scaleWidth , face.bounds.size.height * scaleHeight)];
        
        
        // Marco para la/s cara/s.
        frameViewFace.layer.borderWidth=2;
        frameViewFace.layer.borderColor=[[UIColor greenColor] CGColor];
        [frameViewImagen addSubview:frameViewFace];
    }
    
    // Invertir
    [frameViewImagen setTransform:CGAffineTransformMakeScale(1, -1)];
    
    self.imageView = frameViewImagen;
    
    return self;
}

@end
