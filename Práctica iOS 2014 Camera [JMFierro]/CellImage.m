//
//  COMOtherCell.m
//  CustomCells
//
//  Created by Juan Antonio Martin Noguera on 21/03/14.
//  Copyright (c) 2014 cloudonmobile. All rights reserved.
//

#import "CellImage.h"
#import "FaceDetection.h"

@implementation CellImage {
    
    UIImage *imageFace;
}

#pragma mark - View lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {


        _viewNumFaces.layer.cornerRadius = 20.0f;

    }
    return self;
}



- (void)awakeFromNib
{
    [super awakeFromNib];

    _viewNumFaces.layer.cornerRadius = 20.0f;

    //    self.backgroundView.backgroundColor = [UIColor redColor];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



/*...................................
 *
 * ** Detecta caras en una imagen **
 *
 ....................................*/
- (IBAction)btnDetectFacialFeatures:(id)sender {
  
    [self.indicatorFaceDetection hidesWhenStopped];
    [self.indicatorFaceDetection startAnimating];
    
//    CIImage *imageCI=[[CIImage alloc] initWithImage:self.photoView.image];
//
//    
//    /*-----------------------------------------------------------------------------
//     *
//     *  Calcula la ESCALA a la que se muestra la foto en el 'content view',
//     * se usa para reposionar en su lugar las coordenadas de las caras 
//     * encontradas en la imagen de tamaño original.
//     * 
//     *  Tambien el MARGENES entre el 'content view' y la imagen al mostrala en él.
//     *
//     -----------------------------------------------------------------------------*/
//
//    CGFloat newWidthtImage, newHeightImage;
//    if (self.photoView.image.size.width > self.photoView.image.size.height) {
//        
//        // Regla del 3
//        newHeightImage = (self.photoView.image.size.height*self.photoView.bounds.size.width)/self.photoView.image.size.width;
//        newWidthtImage = self.photoView.bounds.size.width;
//        
//    } else {
//        
//        // Regla del 3
//        newWidthtImage = (self.photoView.image.size.width*self.photoView.bounds.size.height)/self.photoView.image.size.height;
//        newHeightImage = self.photoView.bounds.size.height;
//        
//    }
//
//    // Escala
//    CGFloat scaleWidth = newWidthtImage/self.photoView.image.size.width;
//    CGFloat scaleHeight = newHeightImage/self.photoView.image.size.height;
//    
//    // Margenes
//    CGFloat margenX = (self.photoView.bounds.size.width - newWidthtImage)/2;
//    CGFloat margenY = (self.photoView.bounds.size.height - newHeightImage)/2;
//
//    
//    /* -------------------------
//     * 
//     * ** Detección de caras **
//     *
//     --------------------------*/
//    // Crear un 'face detector' - uso de 'high accuracy'
//    CIDetector* detectorFaces=[CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
//    
//    
//    // Crea un array con las caras detectadas.
//    NSArray *facesArray=[detectorFaces featuresInImage:imageCI];
//    self.lblNumFaces.text = [NSString stringWithFormat:@"%lu",(unsigned long)[facesArray count]];
//    NSLog(@"%d",[facesArray count]);
//    
//    NSLog(@"image width:%f",self.photoView.image.size.width);
//    NSLog(@"view width:%f",self.photoView.bounds.size.width);
//    NSLog(@"image height:%f",self.photoView.image.size.height);
//    NSLog(@"view height:%f",self.photoView.bounds.size.height);
//    
//    
//    UIView *frameViewImagen=[[UIView alloc] initWithFrame:CGRectMake(self.photoView.frame.origin.x, self.photoView.frame.origin.y, self.photoView.frame.size.width, self.photoView.frame.size.height)];
//
//    
//    /*
//     * Iterar rostros detectados. 
//     *
//     *    Anchura para toda la cara, y las coordenadas de cada ojo.
//     *    Boca si es detectada.
//     */
//    for (CIFaceFeature * face in facesArray) {
//        
//        UIView *frameViewFace=[[UIView alloc]initWithFrame:CGRectMake((face.bounds.origin.x * scaleWidth) + margenX, (face.bounds.origin.y * scaleHeight) + margenY, face.bounds.size.width * scaleWidth , face.bounds.size.height * scaleHeight)];
//        
//        
//        // Marco para la/s cara/s.
//        frameViewFace.layer.borderWidth=2;
//        frameViewFace.layer.borderColor=[[UIColor greenColor] CGColor];
//        [frameViewImagen addSubview:frameViewFace];
//    }
//    
//    // Invertir
//    [frameViewImagen setTransform:CGAffineTransformMakeScale(1, -1)];
    
    // Añade marcos de la/s cara/s al 'view'.
//    [self.photoView addSubview:frameViewImagen];
    NSNumber *numFaces = [[NSNumber alloc] init];
//    [self.photoView addSubview:[[FaceDetection alloc] initWithImagenView:self.photoView getNumFaces:self.lblNumFaces]];
    FaceDetection *faceDetection = [[FaceDetection alloc] initWithImagenView:self.photoView numFaces:numFaces];
//    [self.photoView addSubview:[[FaceDetection alloc] initWithImagenView:self.photoView numFaces:numFaces]];
    [self.photoView addSubview:faceDetection.imageView];
//    self.lblNumFaces.text = [NSString stringWithFormat:@"%lu",[numFaces integerValue]];
    self.lblNumFaces.text = [NSString stringWithFormat:@"%d",faceDetection.numFaces];
    
    [self.indicatorFaceDetection stopAnimating];
}


/*..........................
 *
 * ** Métodos privados **
 *
 ...........................*/
#pragma mark - Metodos privados

-(UIImage*)ResizeImage:(UIImage*)img
{

   
    CGSize size = CGSizeMake(300, 285);

    size.height = (img.size.height/img.size.width)*size.width;

    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}



@end
 