//
//  JMFImageCamera.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 21/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMFMetaData.h"

@interface JMFImage : NSObject

@property (nonatomic,strong) UIImage *image;
@property (nonatomic, strong) JMFMetaData *metaData;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic, strong) NSArray *facesRect;


@end
