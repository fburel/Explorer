//
//  CitiesRepository.h
//  Explorer
//
//  Created by florian BUREL on 24/04/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface CitiesRepository : NSObject

- (NSArray *) allCities;

- (City *) addCurrentCity;

- (void) deleteCity:(City *)city;


@end
