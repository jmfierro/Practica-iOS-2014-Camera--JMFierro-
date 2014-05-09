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


#define kCellDetalle @"CellDetailLocation"


@interface CellDetailLocation : UITableViewCell

+ (CellDetailLocation*) detailLocationCell;


@property (weak, nonatomic) IBOutlet UIView *viewRate;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckin;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;

@property (weak, nonatomic) IBOutlet UILabel *lblID;
@property (weak, nonatomic) IBOutlet UILabel *lblFarm;
@property (weak, nonatomic) IBOutlet UILabel *lblServer;
@property (weak, nonatomic) IBOutlet UILabel *lblSecret;
@property (weak, nonatomic) IBOutlet UILabel *lblFamily;
@property (weak, nonatomic) IBOutlet UILabel *lblFriend;
@property (weak, nonatomic) IBOutlet UILabel *lblPublic;
@property (weak, nonatomic) IBOutlet UILabel *lblOwer;


@end
