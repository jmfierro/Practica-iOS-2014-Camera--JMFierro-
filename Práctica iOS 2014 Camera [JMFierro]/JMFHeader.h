//
//  JMFHeader.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 21/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kJMFHeader @"JMFHeader"

@interface JMFHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

- (void) setSearchText:(NSString *)text;
@end
