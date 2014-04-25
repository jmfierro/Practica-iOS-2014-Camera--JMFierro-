//
//  JMFPushpinCell.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "JMFPushpinCell.h"
#import "FlickrPhoto.h"
#import "Flickr.h"

@implementation JMFPushpinCell

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
//        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
//        bgView.backgroundColor = [UIColor blueColor];
//        bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
//        bgView.layer.borderWidth = 4;
//        self.selectedBackgroundView = bgView;
    }
    return self;
}

- (void) setPhoto:(FlickrPhoto *)photo
{
    if(_photo != photo)
    {
        _photo = photo;
    }
    
    self.imagePhoto.image = _photo.thumbnail;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
