//
//  PicturesViewController.m
//  Explorer
//
//  Created by florian BUREL on 23/04/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

#import "PicturesViewController.h"
#import "FBCaroussel.h"
#import "Picture.h"
#import "FlickRClient.h"

@interface PicturesViewController ()
<FBCarousselDelegate>

@property (weak, nonatomic) IBOutlet FBCaroussel *caroussel;


/// Contient la liste des Pictures récupérées de FlickR
@property (strong, nonatomic) NSArray * pictures;

/// Stocke les NSData des objets Pictures téléchargés
@property (strong, nonatomic) NSMutableDictionary * cacheImages;

@end

@implementation PicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FlickRClient * client = [FlickRClient new];
    
    FlickRClientLocation budapest;
    budapest.latitude = 47.498333;
    budapest.longitude = 19.040833;
    
//    self.pictures = [client picturesFromLocation:budapest];
    
    [client fetchPicturesFromLocation:budapest
                           completion:^(NSArray *pictures) {
                               
                               self.pictures = pictures;
                               
                               [self.caroussel displayFirstPage];
                               
                           }];
    
    self.caroussel.delegate = self;
    
    
}


- (IBAction)share:(id)sender
{
    Picture * picture = self.pictures[self.caroussel.currentPageIndex];
    
    // Creer une array avec TOUT ce que vous souhaitez partager
    NSArray * shareItem = @[picture.title,
                            picture.url
                            ];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc]initWithActivityItems:shareItem applicationActivities:nil];
    
    [self presentViewController:avc
                       animated:YES
                     completion:nil];
    
    
    
}

- (UIImageView *)newLoadingImageView
{
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:nil];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    spinner.center = imageView.center;
    spinner.hidesWhenStopped = YES;
    spinner.tag = 666;
    spinner.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    
    [spinner startAnimating];
    
    [imageView addSubview:spinner];
    return imageView;
}

- (UIView *)carroussel:(id)sender pageAtIndex:(int)position
{

    Picture * picture = self.pictures[position];
    
    NSData * data = self.cacheImages[picture.url];
    
    if(data == nil) // Pas encore téléchargée
    {
        UIImageView *imageView = [self newLoadingImageView];
        
        dispatch_queue_t globalHighPriority = dispatch_get_global_queue(2, 0);
        
        dispatch_async(globalHighPriority, ^{
            
            NSData * imageData = [NSData dataWithContentsOfURL:picture.url];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.cacheImages[picture.url] = imageData;
                
                imageView.image = [UIImage imageWithData:imageData];
                
                [[imageView viewWithTag:666] removeFromSuperview];
                
            });
            
        });
        
        return imageView;
    }
    else // image déjà téléchargée
    {
        UIImage * emile = [UIImage imageWithData:data];
        
        UIImageView * view = [[UIImageView alloc]initWithImage:emile];
        
        view.contentMode = UIViewContentModeScaleAspectFit;
        
        return view;

    }
    
}

- (int)numberOfPageInCaroussel:(id)sender {
    return (int) self.pictures.count;
}


- (NSMutableDictionary *)cacheImages
{
    if(!_cacheImages)
    {
        _cacheImages = [NSMutableDictionary new];
    }
    return _cacheImages;
}

@end
