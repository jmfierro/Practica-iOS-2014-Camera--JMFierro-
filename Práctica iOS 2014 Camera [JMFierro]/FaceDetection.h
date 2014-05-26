//
//  FaceDetection.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//
/*
 La clase **'FaceDetection'** recibe el UIImageView que contiene la imagen en la que detectar las caras y devuelve:
 
 - UIView *imageView  : contiene la imagen con las caras detectadas mediante un cuadrado
 - NSInteger numFaces : número de caras detectadas
 
 
 Calcula la escala a la que se muestra la foto en el *'contentView'*, para reposionar en su lugar las coordenadas de las caras encontradas en la imagen de tamaño original.
 
 Calcula los MARGENES que hay entre el 'content view' y la imagen que ajusta en el modo 'Aspect Fit'.
 
 Utiliza el *'framework de Coreimagen'*. Una vez detectadas las caras ubica las coordenadas de la imagen en las del *UIView*. Finalmente al ir obteniendo las coordenadas de los marcos de las caras, se escalan y se añaden al *'view'*.
 
 En *NSINteger numFaces* recoge el número de caras detectadas.
 */

#import <UIKit/UIKit.h>

@interface FaceDetection : UIView

@property (nonatomic, strong) UIView *imageView;
@property (nonatomic) NSInteger facesNum;

@property (nonatomic,strong) NSMutableArray *facesRects;

-(id) initWithImagenView:(UIImageView *) aImageView;


@end
