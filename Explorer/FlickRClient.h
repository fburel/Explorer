//
//  FlickRClient.h
//  Explorer
//
//  Created by florian BUREL on 23/04/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct{
    
    double latitude;
    double longitude;
    
} FlickRClientLocation;

// Block de callback pour fetchPicturesFromLocation:completion:
typedef void(^FlickRClientCompletion)(NSArray * pictures);

@interface FlickRClient : NSObject

- (NSArray *) picturesFromLocation:(FlickRClientLocation)location;

- (void) fetchPicturesFromLocation:(FlickRClientLocation)location completion:(FlickRClientCompletion)block;

@end
