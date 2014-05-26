//
//  JMFHeaderView.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 22/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "JMFHeaderView.h"

@implementation JMFHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width, self.bounds.size.height*2)];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;

        self.label.font = [UIFont fontWithName:@"Zapfino" size:40];
//        [self.label sizeThatFits:CGSizeMake(self.label.frame.size.width, 100)];
        self.label.textColor = [UIColor whiteColor];
        
        UIImageView *labelBackground = [[UIImageView alloc]
                                        initWithImage:[UIImage imageNamed:@"papel-rasgado-54166.png"]];

        
        /*
         * Aspect Fill
         */
        /*
        UIImage *img = [UIImage imageNamed:@"papel-rasgado-54166.png"];
        CGSize imgSize = self.label.frame.size;
        
        UIGraphicsBeginImageContext( imgSize );
        [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.label.backgroundColor = [UIColor colorWithPatternImage:newImage];
        
        UIImageView *labelBackground = [[UIImageView alloc]
                                        initWithImage:newImage];
        [self.label addSubview:labelBackground];
         */

        self.label.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.label];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.label.text = nil;
}

@end
