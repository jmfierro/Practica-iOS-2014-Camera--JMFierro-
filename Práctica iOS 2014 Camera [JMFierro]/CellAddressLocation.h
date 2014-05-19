//
//  AddressLocationCell.h
//  TGFoursquareLocationDetail-Demo
//
//  Created by Thibault Guégan on 17/12/2013.
//  *****************************************************
//  Modificado por Jose Manuel Fierro Conchouso 11/4/2014
//  *****************************************************
//
//  Copyright (c) 2013 Thibault Guégan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define kCellAddress @"CellAddressLocation"

@interface CellAddressLocation : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblStreet;

@property (weak, nonatomic) IBOutlet UILabel *lblLatitud;
@property (weak, nonatomic) IBOutlet UILabel *lblLongitud;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;



+ (CellAddressLocation*) addressLocationDetailCell;


@end
