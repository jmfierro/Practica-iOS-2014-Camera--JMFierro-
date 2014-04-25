//
//  JMFHeader.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 21/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//
#import "JMFHeader.h"

@interface JMFHeader ()
@property(weak) IBOutlet UIImageView *backgroundImageView;
@property(weak) IBOutlet UILabel *searchLabel;
@end

@implementation JMFHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.searchLabel.text = @"farts";
        self.lblTitle.text = @"Titulo";
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
