//
//  CellDetail.h
//  TGFoursquareLocationDetail-Demo
//
//  Created by Thibault Guégan on 17/12/2013.
//  *****************************************************
//  Modificado por Jose Manuel Fierro Conchouso 11/4/2014
//  *****************************************************
//
//  Copyright (c) 2013 Thibault Guégan. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kCellDetail @"CellDetail"

#define kCellDetailSegmentFlickr 0
#define kCellDetailSegmentGeneralMetaData 1


@interface CellDetail : UITableViewCell

+ (CellDetail*) detailLocationCell;


@property (weak, nonatomic) IBOutlet UIView *viewRate;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;

@property (weak, nonatomic) IBOutlet UILabel *lbl5;
@property (weak, nonatomic) IBOutlet UILabel *lbl6;
@property (weak, nonatomic) IBOutlet UILabel *lbl7;
@property (weak, nonatomic) IBOutlet UILabel *lbl8;

@property (weak, nonatomic) IBOutlet UILabel *lbl1content;
@property (weak, nonatomic) IBOutlet UILabel *lbl2content;
@property (weak, nonatomic) IBOutlet UILabel *lbl3content;
@property (weak, nonatomic) IBOutlet UILabel *lbl4content;
@property (weak, nonatomic) IBOutlet UILabel *lbl5content;
@property (weak, nonatomic) IBOutlet UILabel *lbl6content;
@property (weak, nonatomic) IBOutlet UILabel *lbl7content;
@property (weak, nonatomic) IBOutlet UILabel *lbl8content;


@property (weak, nonatomic) IBOutlet UIButton *btnMore;

- (IBAction)segmentMetadatos:(id)sender;


@end
