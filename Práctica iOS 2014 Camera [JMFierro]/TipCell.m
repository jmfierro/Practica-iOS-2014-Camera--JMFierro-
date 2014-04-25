//
//  TipCell.m
//  TGFoursquareLocationDetail-Demo
//
//  Created by Thibault Guégan on 05/01/2014.
//  *****************************************************
//  Modificado por Jose Manuel Fierro Conchouso 11/4/2014
//  *****************************************************
//
//  Copyright (c) 2014 Thibault Guégan. All rights reserved.
//

#import "TipCell.h"

@implementation TipCell

+ (TipCell*) tipCell
{
    TipCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TipCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
