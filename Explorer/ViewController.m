//
//  ViewController.m
//  Explorer
//
//  Created by florian BUREL on 23/04/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

#import "ViewController.h"
#import "CitiesRepository.h"
#import "City.h"

@interface ViewController ()

@property (strong,nonatomic) CitiesRepository * repository;

@property (nonatomic, strong) NSArray * cities;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (IBAction)addCity:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.repository = [CitiesRepository new];
    
    self.cities = [self.repository allCities];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end














