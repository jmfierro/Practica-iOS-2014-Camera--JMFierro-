//
//  InfoCell.m
//  TGFoursquareLocationDetail-Demo
//
//  Created by Thibault Guégan on 04/01/2014.
//  *****************************************************
//  Modificado por Jose Manuel Fierro Conchouso 11/4/2014
//  *****************************************************
//
//  Copyright (c) 2014 Thibault Guégan. All rights reserved.
//

#import "CellInfo.h"

@implementation CellInfo

+ (CellInfo*) infoCell
{
    CellInfo *cell = [[[NSBundle mainBundle] loadNibNamed:kCellInfo owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib {
    
    _txtInfo.backgroundColor = [UIColor clearColor];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
