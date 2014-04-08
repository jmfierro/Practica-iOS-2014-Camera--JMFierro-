//
//  FlickrPhotoHeaderView.m
//  Flickr Search
//
//  Created by Brandon Trebitowski on 7/12/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import "FlickrPhotoHeaderView.h"

@interface FlickrPhotoHeaderView ()
@property(weak) IBOutlet UIImageView *backgroundImageView;
@property(weak) IBOutlet UILabel *searchLabel;
@end

@implementation FlickrPhotoHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.searchLabel.text = @"farts";
    }
    return self;
}

- (void) setSearchText:(NSString *)text
{
    self.searchLabel.text = text;
    
    UIImage *shareButtonImage = [[UIImage
                                  imageNamed:@"header_bg.png"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(68, 68, 68, 68)];
    
    self.backgroundImageView.image = shareButtonImage;
    self.backgroundImageView.center = self.center;
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
