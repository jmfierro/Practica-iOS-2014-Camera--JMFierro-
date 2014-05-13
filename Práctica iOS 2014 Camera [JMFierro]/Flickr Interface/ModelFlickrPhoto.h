//
//  FlickrPhotoModel.h
//  Práctica iOS 2014 Camera [JMFierro]
//
// ************************************************
//  Modificado por Jose Manuel Fierro Conchouso
// ************************************************
//  Created by Brandon Trebitowski on 6/28/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelFlickrPhoto : NSObject
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
