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

@end
