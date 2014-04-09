//
//  JMFPhotoCell.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 08/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "JMFPhotoCell.h"

@implementation JMFPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contenedor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 200)];
        self.titulo = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.contentView.frame.size.width, 40)];
        self.foto = [[UIImageView alloc] initWithFrame:CGRectMake(5, 55, self.contentView.frame.size.width, self.contenedor.frame.size.height)];
        
        [self.contentView addSubview:self.titulo];
        [self.contentView addSubview:self.foto];
        
        [self.contentView addSubview:self.contenedor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
