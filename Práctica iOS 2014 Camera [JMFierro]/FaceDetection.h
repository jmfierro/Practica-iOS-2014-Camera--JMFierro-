//
//  FaceDetection.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface FaceDetection : UIView

@property (nonatomic, strong) UIView *imageView;
@property (nonatomic) NSInteger facesNum;

@property (nonatomic,strong) NSMutableArray *facesRects;

-(id) initWithImagenView:(UIImageView *) aImageView;


@end
