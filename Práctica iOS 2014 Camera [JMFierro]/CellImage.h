//
//  COMOtherCell.h
//  CustomCells
//
//  Created by Juan Antonio Martin Noguera on 21/03/14.
//  Copyright (c) 2014 cloudonmobile. All rights reserved.
//
/*
 Se pueden detectar desde la **'TableView'**, mediante un botón habilitado junto a la imagen mostrada. La ***busqueda se realiza en segundo plano*** desde el método **btnDetectFacialFeatures** llamando a la clase **FaceDetection**. *Al lado del botón se muestra el número de caras encontradas.*
 
 El resultado se guarda en el modelo enviando una notificación desde la clase **CellImage** con la información contenida en el atributo **facesRects** de la clase **FaceDetection** *(un array de cadenas obtenidas desde **NSStringFromCGRect** por cada cara detectada)*. La clase **CellImage** es la que contiene el botón de busqueda de caras.
 
 Luego, en la clase **JMFImageTableViewController** la notificación es  escuchada por el método **onFacesRects**, este a su vez envia una nueva notificación.
 
 Finalmente la clase **JMFCollectionView** recibe esta última notificación en un método llamado tambien **onFacesRects** y guarda en el modelo el array de cadenas con las caras detectadas.
 */
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import "CellFilters.h"

#define kCellImage @"CellImage"


@interface CellImage : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoView;

- (IBAction)btnDetectFacialFeatures:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewNumFaces;
@property (weak, nonatomic) IBOutlet UILabel *lblNumFaces;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorFaceDetection;

@end
