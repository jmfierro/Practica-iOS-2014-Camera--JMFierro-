//
//  JMFCamera.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 19/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMFMetaData.h"

@interface JMFCamera : NSObject

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *health;
@property (nonatomic, strong) JMFMetaData *metaData;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic, strong) NSArray *fecesRect;


@end
