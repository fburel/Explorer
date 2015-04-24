//
//  CitiesRepository.m
//  Explorer
//
//  Created by florian BUREL on 24/04/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

#import "CitiesRepository.h"
#import "AppDelegate.h"

#define ENTITY_NAME     @"City"

@implementation CitiesRepository

- (NSManagedObjectContext *) managedObjectContext
{
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}

- (NSArray *)allCities
{
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:ENTITY_NAME];
    
    NSSortDescriptor * nameSortDescriptor;
    nameSortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name"
                                                    ascending:YES];
    request.sortDescriptors = @[nameSortDescriptor];
    
    NSArray * results;
    results = [[self managedObjectContext] executeFetchRequest:request
                                                         error:nil];
    return results;
}

- (City *)addCurrentCity
{
    NSManagedObjectContext * context = [self managedObjectContext];
    City * city = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME
                                                inManagedObjectContext:context];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //TODO : Remplacer par la geoloc
        city.name = @"Budapest";
        city.latitude = @47.498333; 
        city.longitude = @19.040833;
        
        [[self managedObjectContext] save:nil];
        
    });
    
    
    
    
    return city;
}

- (void)deleteCity:(City *)city
{
    [[self managedObjectContext] deleteObject:city];
}

@end
