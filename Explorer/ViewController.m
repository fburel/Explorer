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
#import "LoadingTableViewCell.h"

@interface ViewController ()
<UITableViewDataSource>

@property (strong,nonatomic) CitiesRepository * repository;

@property (nonatomic, strong) NSArray * cities;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (IBAction)addCity:(id)sender {
    
    City * city = [self.repository addCurrentCity];
    
    self.cities = [self.repository allCities];
    
    [self.tableView reloadData];
    
    [city addObserver:self
           forKeyPath:@"name"
              options:0
              context:NULL];
    
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
    
    if(city.name == nil)
    {
        LoadingTableViewCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"LOADING_CELL"
                                forIndexPath:indexPath];
        cell.messageLabel.text = NSLocalizedString(@"Wait Please...", nil);
        [cell.spinner startAnimating];
        return cell;
    }
    else
    {
        UITableViewCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"CITY_CELL"
                                forIndexPath:indexPath];
        cell.textLabel.text = city.name;
        
        return cell;
    }
    
    
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

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([object isKindOfClass:[City class]])
    {
//        City * city = (City *)object;
        
        [self.tableView reloadData];
        
    }
    
    [object removeObserver:self forKeyPath:keyPath];
    
}

@end














