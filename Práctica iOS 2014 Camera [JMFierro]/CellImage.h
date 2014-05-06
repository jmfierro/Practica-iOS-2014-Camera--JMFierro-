//
//  COMOtherCell.h
//  CustomCells
//
//  Created by Juan Antonio Martin Noguera on 21/03/14.
//  Copyright (c) 2014 cloudonmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import "CellFilters.h"

#define kCellImage @"CellImage"

@interface CellImage : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
- (IBAction)btnDetectFacialFeatures:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewNumFaces;
@property (weak, nonatomic) IBOutlet UILabel *lblNumFaces;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorFaceDetection;

@end
