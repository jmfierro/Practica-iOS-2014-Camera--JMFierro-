//
//  JMFPhotoCell.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 08/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMFPhotoCell : UITableViewCell

@property (nonatomic,strong) UIView *contenedor;
@property (nonatomic, strong) UILabel *titulo;
@property (nonatomic, strong) UIImageView *foto;

@end
