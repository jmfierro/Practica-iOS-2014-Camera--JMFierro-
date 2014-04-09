//
//  JMFCollectionViewController.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhoto.h"


@interface JMFFlickrPhotosCollectionViewController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end
