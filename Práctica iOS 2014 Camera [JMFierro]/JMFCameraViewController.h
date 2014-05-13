//
//  JMFCameraViewController.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 09/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@protocol CameraViewControllerDelegate

-(void) getImagePickerCamera:(UIImage *) image;

@end

@interface JMFCameraViewController : UIViewController <UIImagePickerControllerDelegate> {


id delegate;
}

@property (nonatomic, retain) id<CameraViewControllerDelegate> delegate;

@property BOOL newMedia;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


- (IBAction)useCamera:(id)sender;
- (IBAction)useCameraRoll:(id)sender;



@end


/*
{
    DPIHeight = 72;
    DPIWidth = 72;
    Orientation = 6;
    "{Exif}" =     {
        ApertureValue = "2.526068811667588";
        BrightnessValue = "-2.662584641754744";
        ColorSpace = 1;
        DateTimeDigitized = "2014:05:12 20:29:36";
        DateTimeOriginal = "2014:05:12 20:29:36";
        ExposureMode = 0;
        ExposureProgram = 2;
        ExposureTime = "0.06666666666666667";
        FNumber = "2.4";
        Flash = 32;
        FocalLenIn35mmFilm = 33;
        FocalLength = "3.3";
        ISOSpeedRatings =         (
                                   640
                                   );
        LensMake = Apple;
        LensModel = "iPad mini back camera 3.3mm f/2.4";
        LensSpecification =         (
                                     "3.3",
                                     "3.3",
                                     "2.4",
                                     "2.4"
                                     );
        MeteringMode = 5;
        PixelXDimension = 2592;
        PixelYDimension = 1936;
        SceneType = 1;
        SensingMethod = 2;
        ShutterSpeedValue = "3.906905022631062";
        SubjectArea =         (
                               1295,
                               967,
                               699,
                               696
                               );
        SubsecTimeDigitized = 138;
        SubsecTimeOriginal = 138;
        WhiteBalance = 0;
    };
    "{MakerApple}" =     {
        1 = 0;
        3 =         {
            epoch = 0;
            flags = 1;
            timescale = 1000000000;
            value = 12978342346625;
        };
        4 = 0;
        5 = 200;
        6 = 52;
        7 = 1;
    };
    "{TIFF}" =     {
        DateTime = "2014:05:12 20:29:36";
        Make = Apple;
        Model = "iPad mini";
        Software = "7.0.4";
        XResolution = 72;
        YResolution = 72;
    };
}
*/