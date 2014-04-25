//
//  TipCell.h
//  TGFoursquareLocationDetail-Demo
//
//  Created by Thibault Guégan on 05/01/2014.
//  *****************************************************
//  Modificado por Jose Manuel Fierro Conchouso 11/4/2014
//  *****************************************************
//
//  Copyright (c) 2014 Thibault Guégan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipCell : UITableViewCell

+ (TipCell*) tipCell;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@end
