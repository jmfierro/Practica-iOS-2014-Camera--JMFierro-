//
//  JMFTablePhotoViewController.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 08/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "JMFPhotoTableViewController.h"
#import "JMFPhotoCell.h"
#import "JMFFlickrPhotosCollectionViewController.h"
#import "Flickr.h"


#define kPhotoCellIdentify @"PHOTO_CELL"

@interface JMFPhotoTableViewController () {
    
    NSArray *modelo;
    UITableView *photoTableView;
}

@end

@implementation JMFPhotoTableViewController

//@synthesize delegate;



#pragma mark - Init methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(id) initWithFlickrPhoto:(FlickrPhoto *)flickrPhoto {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _flickrPhoto = flickrPhoto;
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadDataModel];
    
    photoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height)
                                                  style:UITableViewStylePlain];
    photoTableView.delegate = self;
    photoTableView.dataSource = self;
    
    // Quita separador
    [photoTableView setSeparatorColor:[UIColor clearColor]];
    [photoTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Registro celda
    [photoTableView registerClass:[JMFPhotoCell class] forCellReuseIdentifier:kPhotoCellIdentify];
    
    // Añade la tabla a la vista del controlador
    [self.view addSubview:photoTableView];

	
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Delagados Tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return modelo.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    JMFPhotoCell *photoCell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:kPhotoCellIdentify];
    if (cell) {
        //
        //        // Si si es par
        //        if ((indexPath.row % 2)==0) {
        photoCell = (JMFPhotoCell *) cell;
        photoCell.titulo.text = [modelo objectAtIndex:indexPath.row];
        
        photoCell.foto.image = [UIImage imageNamed:@"famous-face-dementia-617x416.jpg"];
        //            cell = celda;
        //        }
        
        
        if(self.flickrPhoto.largeImage)
        {
            photoCell.foto.image = self.flickrPhoto.largeImage;
        }
        else
        {
            photoCell.foto.image = self.flickrPhoto.thumbnail;
            [Flickr loadImageForPhoto:self.flickrPhoto thumbnail:NO completionBlock:^(UIImage *photoImage, NSError *error) {
                
                if(!error)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        photoCell.foto.image = self.flickrPhoto.largeImage;
                    });
                }
                
            }];
        }
        
        photoCell.titulo.text = self.flickrPhoto.title;
        
    }
    
    //    cell.textLabel.text = [modelo objectAtIndex:indexPath.row];
    
    return photoCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    float altura;
    //
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    altura = cell.frame.size.height;
    //
    //
    //    if ([cell isKindOfClass:[JMFCityCell class]]) {
    //        JMFCityCell *celda = (JMFCityCell *)cell;
    //        altura = celda.contenedor.frame.size.height;
    //        
    //    }
    
    return 200.f;
}


#pragma mark - carga de modelo
- (void)loadDataModel{

//    FlickrPhoto *flickrPhoto = [self.delegate getFlickrPhoto];
    
    modelo = @[@"Madrid",
               @"Granada",
               @"Sevilla",
               @"Cuenca"];
}

@end
