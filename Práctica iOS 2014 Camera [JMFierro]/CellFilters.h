//
//  CellFilters.h
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
