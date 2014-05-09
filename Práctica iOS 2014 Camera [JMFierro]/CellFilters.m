//
//  CellFilters.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 28/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "CellFilters.h"
#import "JMFFilters.h"


@implementation CellFilters



//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        [self filter];
//    }
//    return self;
//}


-(void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)btnFilter1:(id)sender {
    
    [self.imgCheck1 setHidden:!self.imgCheck1.isHidden];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCellFilters object:@"CISepiaTone"];
}

- (IBAction)btnFilter2:(id)sender {

    [self.imgCheck2 setHidden:!self.imgCheck2.isHidden];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCellFilters object:@"CIPhotoEffectProcess"];
}

- (IBAction)btnFilter3:(id)sender {

    [self.imgCheck3 setHidden:!self.imgCheck3.isHidden];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCellFilters object:@"CIPixellate"];
}

- (IBAction)btnFilter4:(id)sender {

    [self.imgCheck4 setHidden:!self.imgCheck4.isHidden];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCellFilters object:@"CIPinchDistortion"];

}

- (IBAction)btnFilter5:(id)sender {

    [self.imgCheck5 setHidden:!self.imgCheck5.isHidden];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCellFilters object:@"CIPerspectiveTransform"];

}
@end
