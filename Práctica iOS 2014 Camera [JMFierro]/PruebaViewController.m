//
//  PruebaViewController.m
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import "PruebaViewController.h"

@interface PruebaViewController ()

@end

@implementation PruebaViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)useCamera:(id)sender {
    NSLog(@"hola");
}
@end
