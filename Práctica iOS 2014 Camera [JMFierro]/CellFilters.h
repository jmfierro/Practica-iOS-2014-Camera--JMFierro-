//
//  CellFilters.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 28/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellFilters @"CellFilters"



@interface CellFilters : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgFilter1;
@property (weak, nonatomic) IBOutlet UIImageView *imgFilter2;
@property (weak, nonatomic) IBOutlet UIImageView *imgFilter3;
@property (weak, nonatomic) IBOutlet UIImageView *imgFilter4;
@property (weak, nonatomic) IBOutlet UIImageView *imgFilter5;

@property (weak, nonatomic) IBOutlet UILabel *lblFilter1;
@property (weak, nonatomic) IBOutlet UILabel *lblFilter2;
@property (weak, nonatomic) IBOutlet UILabel *lblFilter3;
@property (weak, nonatomic) IBOutlet UILabel *lblFilter4;
@property (weak, nonatomic) IBOutlet UILabel *lblFilter5;

@property (weak, nonatomic) IBOutlet UIImageView *imgCheck1;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck2;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck3;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck4;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck5;

- (IBAction)btnFilter1:(id)sender;
- (IBAction)btnFilter2:(id)sender;
- (IBAction)btnFilter3:(id)sender;
- (IBAction)btnFilter4:(id)sender;
- (IBAction)btnFilter5:(id)sender;


@end
