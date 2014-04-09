//
//  JMFCollectionViewController.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/04/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "JMFFlickrPhotosCollectionViewController.h"
#import "JMFPhotoCollectionViewCell.h"
#import "JMFFlickrPhotosHeaderView.h"
#import "Flickr.h"
#import "FlickrPhoto.h"

#import "JMFPhotoTableViewController.h"

//#define kCellIdentifier @"CELL_COLLECTION_PHOTO"
#define kCellIdentifier @"CELL_COLLECTION_PHOTO_FLICKR"

@interface JMFFlickrPhotosCollectionViewController () {
    
    // Accesible en toda la clase
//    @property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
    UICollectionView *collectionViewPhotos;
    FlickrPhoto *flickrPhoto;
}

// Nueva version para Collection
@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *shareButton;
@property(nonatomic, weak) IBOutlet UITextField *textField;
- (IBAction)shareButtonTapped:(id)sender;

// Flick
@property(nonatomic, strong) NSMutableDictionary *searchResults;
@property(nonatomic, strong) NSMutableArray *searches;
@property(nonatomic, strong) Flickr *flickr;

@property (nonatomic,strong) NSArray *model;

@end

@implementation JMFFlickrPhotosCollectionViewController


#pragma mark - Init methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    [self loadModel];
    
    
    /*
     * Creación, registro y configuración de Collections y establecer delegados.
    */
    collectionViewPhotos = [self createCollectionView:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height)];
    collectionViewPhotos.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    collectionViewPhotos.delegate = self;
    collectionViewPhotos.dataSource = self;
    
    self.searchTextField.delegate = self;
    
    [self.view addSubview:collectionViewPhotos];
    
    // Cabecera de la sección
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)collectionViewPhotos.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
    
    
    /*
     * Fondo corcho
     */
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    /*
    UIImage *navBarImage = [[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(27, 27, 27, 27)];
    
    [self.toolbar setBackgroundImage:navBarImage forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    UIImage *shareButtonImage = [[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *textFieldImage = [[UIImage imageNamed:@"search_field.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.textField setBackground:textFieldImage];
    */
    
    
    /*
     * Flick inIcialización
     */
    
    self.searches = [@[] mutableCopy];
    self.searchResults = [@{} mutableCopy];
    self.flickr = [[Flickr alloc] init];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/* Devuelve una vista para el encabezado o pie de página de cada sección de la UICollectionView. La variable “kind” es un NSString que determina qué vista (encabezado o pie de página) que la clase está pidiendo.
 *
 *  Quita la cola de la vista de encabezado para cada sección y establecer el texto de búsqueda para esa celda. Esto le dice a la vista de colección que encabezado se muestra para cada sección. 
*/
 - (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
     JMFFlickrPhotosHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JMFFlickrPhotoHeaderView" forIndexPath:indexPath];
     NSString *searchTerm = self.searches[indexPath.section];
     [headerView setSearchText:searchTerm];
     return headerView;
 }


#pragma mark - Delegates UICollectionView methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *searchTerm = self.searches[indexPath.section];
    flickrPhoto = self.searchResults[searchTerm][indexPath.row];
//    tableFlickrPhotoVC.delegate = self;
    JMFPhotoTableViewController *tableFlickrPhotoVC = [[JMFPhotoTableViewController alloc] initWithFlickrPhoto:flickrPhoto];
    
//    [self.delegate setFlickrPhoto:flickrPhoto];

    [self.navigationController pushViewController:tableFlickrPhotoVC animated:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


#pragma mark – Delegates UICollectionViewDelegateFlowLayout methods

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//     return CGSizeMake(206.f, 167.f);
//    
//    // ...anulado
    NSString *searchTerm = self.searches[indexPath.section]; FlickrPhoto *photo =
    self.searchResults[searchTerm][indexPath.row];
    // 2
//    CGSize retval = photo.thumbnail.size.width &gt; 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
    retval.height += 35;
    retval.width += 35;
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}


/**
#pragma mark - Delegados CollectionView

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JMFCollectionViewCellPhoto *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    cell.imagePhoto.image = [UIImage imageNamed:@"Mar Atardecer.jpg"];
    cell.labelPhoto = [self.model objectAtIndex:indexPath.row];
    
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(206.f, 167.f);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.model.count;
}
*/




#pragma mark - Data Source UICollectionView methods
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    //
    //    return self.model.count;
    //
    //    //...anulado
    
    NSString *searchTerm = self.searches[section];
    return [self.searchResults[searchTerm] count];
}


// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    //    return 1;
    //
    //    // ...anulado
    //
    return [self.searches count];
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    /*
     UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell " forIndexPath:indexPath];
     cell.backgroundColor = [UIColor whiteColor];
     */
    
    JMFPhotoCollectionViewCell *cell = [collectionViewPhotos dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    NSString *searchTerm = self.searches[indexPath.section];
    cell.photo = self.searchResults[searchTerm][indexPath.row];
    
    //    cell.imagePhoto.image  = self.searchResults[searchTerm][indexPath.row];
    
    //    cell.imagePhoto.image = [UIImage imageNamed:@"Mar Atardecer.jpg"];
    //    cell.labelPhoto = [self.model objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - Delegates UITextFieldDelegate methods

/*
 Cuando el usuario pulsa la tecla enter en el teclado, este método será llamado (esto porque anteriormente configuraste el controlador de vista como el delegado del campo de texto). 
 */
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    // 1 Utiliza la práctica clase  de Flickr que le proporcioné para buscar  en Flickr las fotos que coinciden con el término de búsqueda de manera asincrónica. Cuando la búsqueda finaliza, el bloque de terminación será llamada con una referencia al término buscado, el resultado es un conjunto de objetos de FlickrPhoto, y un error (si hay uno).
    
    [self.flickr searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
 
//        if(results &amp;&amp; [results count] &gt; 0) {
        if(results && [results count] > 0) {
            
            // 2 Comprueba si has buscado este término antes. Si no, el término se añade al inicio del arreglo de búsquedas y los resultados son escondidos en el diccionario searchResults, donde la clave es el término de búsqueda.
            if(![self.searches containsObject:searchTerm]) {
                NSLog(@"Found %d photos matching %@", [results count],searchTerm);
                [self.searches insertObject:searchTerm atIndex:0];
                self.searchResults[searchTerm] = results; }
            
            // 3 En esta etapa, tu tienes nuevos datos y la necesidad de actualizar la interfaz de usuario. Aquí la vista de colección tiene que volver a cargarse para reflejar los nuevos datos. Sin embargo, aún no se ha implementado una vista de colección, así que esto es sólo un marcador de posición comentado por ahora.
            dispatch_async(dispatch_get_main_queue(), ^{
                [collectionViewPhotos reloadData];
//                [self.collectionView reloadData];
            });
        } else { // 4 Por último, se registra cualquier error en la consola. Obviamente, en una aplicación de producción tu podrias mostrar estos errores al usuario.
            NSLog(@"Error searching Flickr: %@", error.localizedDescription);
        } }];
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Delegates JMFPhotoTableViewControllerDelegate methods
-(FlickrPhoto *) getFlickrPhoto {
    
    return flickrPhoto;
}


#pragma mark - Self methods

/**
 * Creación y registro de Collections y establecer delegados
 */
-(UICollectionView *)createCollectionView:(CGRect)rect{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 8.f;
    flowLayout.minimumLineSpacing = 8;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    //    [collectionView registerNib:[UINib nibWithNibName:@"CellPhoto" bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    [collectionView registerNib:[UINib nibWithNibName:@"CellPhotoChincheta" bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    
    //    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"FlickrCell"];
    //    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"FlickrCell"];
    
    return collectionView;
}




//#pragma mark - Modelo
//
//-(void) loadModel {
//    self.model = @[@"FOTO A",
//                   @"FOTO B",
//                   @"FOTO C",
//                   @"FOTO D",
//                   @"FOTO E",
//                   @"FOTO F",
//                   @"FOTO G"];
//}


//#pragma mark - Métodos vista
//
//- (IBAction)buttonListado:(id)sender {
//}
//
//-(IBAction)shareButtonTapped:(id)sender {
//    // TODO
//}


@end