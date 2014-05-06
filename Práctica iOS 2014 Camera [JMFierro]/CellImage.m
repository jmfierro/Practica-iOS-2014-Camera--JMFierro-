//
//  COMOtherCell.m
//  CustomCells
//
//  Created by Juan Antonio Martin Noguera on 21/03/14.
//  Copyright (c) 2014 cloudonmobile. All rights reserved.
//

#import "CellImage.h"
#import "FaceDetection.h"
#import "CellFilters.h"


@implementation CellImage {
    
    UIImage *imageFace;
}

#pragma mark - View lifecycle

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//
//
//        _viewNumFaces.layer.cornerRadius = 20.0f;
//
//    }
//    return self;
//}



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
    
    
    // Añade marcos de la/s cara/s al 'view'.
    FaceDetection *faceDetection = [[FaceDetection alloc] initWithImagenView:self.photoView];
    [self.photoView addSubview:faceDetection.imageView];
    self.lblNumFaces.text = [NSString stringWithFormat:@"%d",faceDetection.numFaces];
    
    [self.indicatorFaceDetection stopAnimating];
}


#pragma mark - CellFilter Delegate
-(void)addFilter:(NSString *)nameFilter {
    
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
 