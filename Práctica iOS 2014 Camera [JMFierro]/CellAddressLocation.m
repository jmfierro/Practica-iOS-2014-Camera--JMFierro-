//
//  AddressLocationCell.m
//  TGFoursquareLocationDetail-Demo
//
//  Created by Thibault Guégan on 17/12/2013.
//  *****************************************************
//  Modificado por Jose Manuel Fierro Conchouso 11/4/2014
//  *****************************************************
//
//  Copyright (c) 2013 Thibault Guégan. All rights reserved.
//
/*
 ## Localización y Geocoding
 
 La celda **CellAddressLocation.xib** muestra las coordenadas y dirección de la imagen o de la posición actual.
 
 En **JMFImageTableViewController** toma las coordenadas de los metadatos si los tiene, en caso contrario obtiene la localización con el framework de **'CoreLocation'*.
 
 El método **startLocation** inicia la localización del usuario, una vez obtenida en **locationManager:didUpdateLocations:** se para la localización.
 
 Para el geocoding usa el framework **MapKit**. El método **cellAddressLocation:cellForRowAtIndexPath:
 ** instancia *CLGeocoder* y hace *reverseGeocodeLocation* . Un **mapView** en la celda se actualiza con una *chincheta* y una *etiqueta*.
 
 En el método **cellForRowAtIndexPath**, en segundo plano se hace un
 
 [geocoder reverseGeocodeLocation:userCLLocation completionHandler:^(NSArray *placemarks, NSError *error) { ...
 Finalmente establece los parametros del mapa:
 
 cell.mapView.rotateEnabled = YES;
 cell.mapView.zoomEnabled = YES;
 cell.mapView.pitchEnabled = YES;
 cell.mapView.showsBuildings = YES;
 cell.mapView.showsUserLocation = NO;
 cell.mapView.delegate = self;
 cell.mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
 */

#import "CellAddressLocation.h"

@implementation CellAddressLocation

+ (CellAddressLocation*) addressLocationDetailCell
{
    CellAddressLocation * cell = [[[NSBundle mainBundle] loadNibNamed:kCellAddress owner:self options:nil] objectAtIndex:0];
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

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
