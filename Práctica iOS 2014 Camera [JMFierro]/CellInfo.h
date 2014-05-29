//
//  InfoCell.h
//  TGFoursquareLocationDetail-Demo
//
//  Created by Thibault Guégan on 04/01/2014.
//  *****************************************************
//  Modificado por Jose Manuel Fierro Conchouso 11/4/2014
//  *****************************************************
//
//  Copyright (c) 2014 Thibault Guégan. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kCellInfo @"CellInfo"

@interface CellInfo : UITableViewCell

+ (CellInfo*) infoCell;

@property (weak, nonatomic) IBOutlet UIImageView *imagenInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;

@property (weak, nonatomic) IBOutlet UITableView *tblInfo;
@property (weak, nonatomic) IBOutlet UITextView *txtInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;

@end
