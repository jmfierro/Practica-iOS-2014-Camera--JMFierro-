//
//  UserCell.h
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
#define kCellUser @"CellUser"

@interface CellUser : UITableViewCell

+ (CellUser*) userCell;

@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@end
