//
//  FlickrPhoto.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhoto : NSObject
@property(nonatomic,strong) UIImage *thumbnail;
@property(nonatomic,strong) UIImage *largeImage;

// Lookup info
@property(nonatomic) long long photoID;
@property(nonatomic) NSInteger farm;
@property(nonatomic) NSInteger server;
@property(nonatomic,strong) NSString *secret;

@property(nonatomic,strong) NSString *isfamily;
@property(nonatomic,strong) NSString *isfriend;
@property(nonatomic,strong) NSString *ispublic;
@property(nonatomic,strong) NSString *owner;
@property(nonatomic,strong) NSString *title;


@end
