//
//  JMFMetaData.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 09/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>
#import "JMFMetaDataModel.h"

@interface JMFMetaData : NSObject

@property(nonatomic,strong) JMFMetaDataModel *modelMetaData;

-(id) init;

-(UIImage *)addMetaData:(UIImage *)aImage;

@end
