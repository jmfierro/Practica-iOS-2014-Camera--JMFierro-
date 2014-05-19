//
//  JMFPushpinCell.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrPhoto;

#define kJMFPushpinCell @"JMFPushpinCell"

@interface JMFPushpinCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagePhoto;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoto;

@property(nonatomic, strong) FlickrPhoto *photo;

@end
