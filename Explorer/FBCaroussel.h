//
//  FBCaroussel.h
//  Caroussel
//
//  Created by florian BUREL on 22/04/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FBCarousselDelegate <NSObject>

@required

- (UIView *) carroussel:(id)sender pageAtIndex:(int)position;

- (int) numberOfPageInCaroussel:(id)sender;

@optional

- (NSString *) caroussel:(id)sender legendForPageAtIndex:(int)position;

@end



@interface FBCaroussel : UIView

@property (readonly, nonatomic) int currentPageIndex;


@property (/*readwrite, */ nonatomic, weak) id<FBCarousselDelegate> delegate;


- (void) displayFirstPage;


@end
