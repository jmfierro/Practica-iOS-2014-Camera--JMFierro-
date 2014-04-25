//
//  DetailLocationCell.h
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


#define kDetalleCell @"DetailLocationCell"


@interface DetailLocationCell : UITableViewCell

+ (DetailLocationCell*) detailLocationCell;


@property (weak, nonatomic) IBOutlet UIView *viewRate;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckin;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@end
