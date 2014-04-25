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
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
//        self.label.backgroundColor = [UIColor randomColor];
//        self.label.textAlignment = NSTextAlignmentCenter;
//        self.label.font = [UIFont boldSystemFontOfSize:13.0f];
        self.label.textColor = [UIColor blackColor];

        UIImageView *labelBackground = [[UIImageView alloc]
                                        initWithImage:[UIImage imageNamed:@"papel-rasgado-54166.png"]];
        [self.label addSubview:labelBackground];
//        [labelBackground release];
        self.label.backgroundColor = [UIColor clearColor];
        
//        self.label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header_bg.png"]];
        
//        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header_bg.png"]];
//        self.label.backgroundColor = color;

        
        [self addSubview:self.label];
        
//        [self.label setBackGround:[UIImage imageNamed:@"header_bg.png"]];
//        [self.label setText:@"created programatically"];
////        [self.label release];
        
//        UIImageView *labelBackground = [[UIImageView alloc]
//                                        initWithImage:[UIImage imageNamed:@"header_bg.png"]];
//        [self.label addSubview:labelBackground];
//        [self.label setText:@"created programatically"];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.label.text = nil;
}

@end
