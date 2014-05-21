//
//  JMFCollectionView.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFlickr.h"
#import "JMFModel.h"




@interface JMFCollectionView : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) JMFModel *model;

@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activiyIndicator;

- (IBAction)btnTakePhoto:(id)sender;


- (IBAction)clickBackground:(id)sender;
//@property (weak, nonatomic) IBOutlet UIView *viewMap;

@end
