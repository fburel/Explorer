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
#import "PicturesViewController.h"

@interface ViewController ()
<UITableViewDataSource>

@property (strong,nonatomic) CitiesRepository * repository;

@property (nonatomic, strong) NSArray * cities;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (IBAction)addCity:(id)sender {
    
    [self.repository addCurrentCity];
    
    self.cities = [self.repository allCities];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.repository = [CitiesRepository new];
    
    self.cities = [self.repository allCities];
    
    self.tableView.dataSource = self;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"CITY_SELECTED"])
    {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        
        City * city = self.cities[indexPath.row];
        
        PicturesViewController * pvc = segue.destinationViewController;
        
        [pvc setLongitude:city.longitude.doubleValue
                 latitude:city.latitude.doubleValue];
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    City * city = self.cities[indexPath.row];
    
    UITableViewCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"CITY_CELL"
                                           forIndexPath:indexPath];
    cell.textLabel.text = city.name;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        City * city = self.cities[indexPath.row];
        [self.repository deleteCity:city];
        self.cities = [self.repository allCities];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
@end














