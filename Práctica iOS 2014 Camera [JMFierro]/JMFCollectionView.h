//
//  JMFCollectionView.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhoto.h"
#import "JMFImages.h"
#import "CameraViewController.h"



@interface JMFCollectionView : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CameraViewControllerDelegate>

@property (nonatomic, strong) JMFImages *model;

@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activiyIndicator;

- (IBAction)btnTakePhoto:(id)sender;
- (IBAction)btnLocation:(id)sender;
- (IBAction)btnFilters:(id)sender;

- (IBAction)clickBackground:(id)sender;

@end
