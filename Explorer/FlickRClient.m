//
//  FlickRClient.m
//  Explorer
//
//  Created by florian BUREL on 23/04/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

#import "FlickRClient.h"
#import "Picture.h"

/**
 Recherche de photos par geolocation
 @params = api_key ,latitude , longitude.
 */
#define FLICKR_GEO_SEARCH_METHODE @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&lat=%g&lon=%g&format=json&nojsoncallback=1"

/**
 Recherche de photos par geolocation
 @params = farm, server, id, secret.
 */
#define PICTURE_URL_FORMAT      @"https://farm%@.staticflickr.com/%@/%@_%@.jpg"

#define API_KEY   @"4f1a68f35e2d20826c4f7fb8f4312f31"

#define APP_SECRET @"85379488f97e4403"

@implementation FlickRClient


- (void)fetchPicturesFromLocation:(FlickRClientLocation)location completion:(FlickRClientCompletion)block
{
    
    dispatch_queue_t globalHighPriority = dispatch_get_global_queue(2, 0);
    
    dispatch_async(globalHighPriority, ^{
        
        /* async code */
        NSArray * pictures = [self picturesFromLocation:location];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /* code callback */
             block(pictures);
            
        });
        
    });
    
    
    
    
  
    
   
}

- (id)jsonResponseForUrl:(NSString *)urlString
{
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary * jsonResponse = data ? [NSJSONSerialization JSONObjectWithData:data
                                                                         options:0
                                                                           error:NULL] : nil;
    return jsonResponse;
}


- (NSURL *) urlForPictureWithFarm:(id)farm secret:(id)secret server:(id)server id:(id)pId
{
    NSString * str = [NSString stringWithFormat:PICTURE_URL_FORMAT, farm, server, pId, secret];
    
    return [NSURL URLWithString:str];
}

- (NSArray *) picturesFromJsonObjects:(NSArray *)jsonPictures
{
    NSMutableArray * pictures = [NSMutableArray new];
    
    for (NSDictionary * item in jsonPictures)
    {
        Picture * p = [Picture new];
        
        p.title = item[@"title"];
        p.url = [self urlForPictureWithFarm:item[@"farm"]
                                     secret:item[@"secret"]
                                     server:item[@"server"]
                                         id:item[@"id"]];
        
        [pictures addObject:p];
    }
    
    return  pictures;
}


- (NSArray *)picturesFromLocation:(FlickRClientLocation)location
{
    NSString * urlString = [NSString stringWithFormat:FLICKR_GEO_SEARCH_METHODE, API_KEY, location.latitude, location.longitude];
    
    NSDictionary *jsonResponse = [self jsonResponseForUrl:urlString];
    
    NSArray * photoItems = jsonResponse[@"photos"][@"photo"];
    
    NSArray * pictures = [self picturesFromJsonObjects:photoItems];
    
    return pictures;
    
}

@end
