//
//  CellFilters.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 28/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//
/*
 ## Filtros
 
 Los filtros se aplican por medio de dos métodos de clase de **Utils.m**:
 
 filterOverImage:(UIImage *)aImage namesFilter:(NSArray *)namesFilter
 
 f-(UIImage *) filterOverImage:(UIImage *)aImage nameFilter:(NSString *)nameFilter
 
 En el método *cellImage* de la clase **JMFImageTableViewController** se le aplican los filtros activos contenidos en el atributo privado *'filtersActive'*. Esta variable se mantiene actualizada por el método *onFilter* que escucha las notificaciones enviadas desde la clase **CellFilters** *(celda personalizada que lista los filtros a seleccionar).*
 Utiliza **'CIContext'** para aumentar el rendimiento:
 
 CIContext *context = [CIContext contextWithOptions:nil];
 CGImageRef cgImage =
 [context createCGImage:outputImage fromRect:[outputImage extent]];
 
 El uso del método 'UIImage' con 'imageWithCIImage' sería más simple pero crea un nuevo *CIContext* cada vez, y si se usa un *'slider'* para actualizar los valores del filtro lo haría demasiado lento. *(nota: en este caso no uso slider)*
 */

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
