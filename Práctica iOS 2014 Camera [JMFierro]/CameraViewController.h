//
//  CameraViewController.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@protocol CameraViewControllerDelegate

-(void) getImagePickerCamera:(UIImage *) image;

@end


@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate> {
    id delegate;
}

@property (nonatomic, retain) id<CameraViewControllerDelegate> delegate;

@property BOOL newMedia;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


- (IBAction)useCamera:(id)sender;
- (IBAction)useCameraRoll:(id)sender;

@end
