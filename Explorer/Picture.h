//
//  Picture.h
//  Explorer
//
//  Created by florian BUREL on 23/04/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Picture : NSObject

@property (strong, nonatomic/*, readwrite*/) NSURL * url;
@property (strong, nonatomic/*, readwrite*/) NSString * title;

@end
