//
//  FBCaroussel.m
//  Caroussel
//
//  Created by florian BUREL on 22/04/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

#import "FBCaroussel.h"

#define PAGE_VIEW_TAG       42

@interface FBCaroussel ()

@property (nonatomic) BOOL isConfigured;

@property (nonatomic) int currentPageIndex;

@property (strong, nonatomic) UILabel * noContentLabel;

@property (strong, nonatomic) UILabel * legendLabel;

@end


@implementation FBCaroussel

- (void)layoutSubviews
{
    if(!self.isConfigured)
    {
        [self configure];
        
        [self displayFirstPage];
        
        self.isConfigured = YES;
    }
   
}

// Ajoute les gestures recognizer
-(void) configure
{
    if([self.delegate respondsToSelector:@selector(caroussel:legendForPageAtIndex:)])
    {
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        [tap addTarget:self action:@selector(toggleLegend)];
        [self addGestureRecognizer:tap];
    }
    
    UISwipeGestureRecognizer * swipeR = [UISwipeGestureRecognizer new];
    swipeR.direction = UISwipeGestureRecognizerDirectionRight;
    [swipeR addTarget:self action:@selector(handleSwipe:)];
    [self addGestureRecognizer:swipeR];
    
    UISwipeGestureRecognizer * swipeL = [UISwipeGestureRecognizer new];
    swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
    [swipeL addTarget:self action:@selector(handleSwipe:)];
    [self addGestureRecognizer:swipeL];
}

// Affiche la 1ere page
- (void) displayFirstPage
{
    if([self.delegate numberOfPageInCaroussel:self] > 0)
    {
        [self setNoContentViewVisible:NO];
        [self displayPage:0 animated:NO];
    }
    else
    {
        [self setNoContentViewVisible:YES];
    }
}

// Affiche la page a la position donnée
- (void) displayPage:(int)pageIdx animated:(BOOL)animated
{
    
    NSTimeInterval duration = animated ? .3 : 0.0;
    
    float offset = self.bounds.size.width;
    if (pageIdx - self.currentPageIndex < 0)
    {
        offset *= -1;
    }
    
        
    UIView * oldView = [self viewWithTag:PAGE_VIEW_TAG];
    
    UIView * nextPage = [self.delegate carroussel:self pageAtIndex:pageIdx];
    
    nextPage.tag = PAGE_VIEW_TAG;
    
    nextPage.frame = self.bounds;
    
    nextPage.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    nextPage.center = CGPointMake(nextPage.center.x + offset, nextPage.center.y);
    
    [self addSubview:nextPage];
    
    
    
    
    [UIView animateWithDuration:duration
                     animations:^{
                         nextPage.center = CGPointMake(nextPage.center.x - offset, nextPage.center.y);
                          oldView.center = CGPointMake(oldView.center.x - offset, oldView.center.y);

                     } completion:^(BOOL finished) {
                         [oldView removeFromSuperview];
                     }];
    
    
    
    self.currentPageIndex = pageIdx;
}

// Reponds au swipe (change de page en fonction de la direction)
- (void) handleSwipe:(UISwipeGestureRecognizer *)sender
{
    if(sender.direction == UISwipeGestureRecognizerDirectionLeft && ![self isDisplayingLastPage])
    {
        [self displayPage:self.currentPageIndex + 1 animated:YES];
    }
    else if(sender.direction == UISwipeGestureRecognizerDirectionRight && self.currentPageIndex > 0)
    {
        [self displayPage:self.currentPageIndex - 1 animated:YES];
    }
    else
    {
        [self bounce:sender.direction];
    }
}

- (int) isDisplayingLastPage
{
    return self.currentPageIndex == [self.delegate numberOfPageInCaroussel:self] - 1;
}

- (void) bounce:(UISwipeGestureRecognizerDirection)direction
{
    UIView * oldView = [self viewWithTag:PAGE_VIEW_TAG];
    
    float offset = self.bounds.size.width / 10.;
    
    if (direction == UISwipeGestureRecognizerDirectionRight)
    {
        offset *= -1;
    }

    
    [UIView animateWithDuration:.1
                          delay:0
                        options:UIViewAnimationOptionAutoreverse
                     animations:^{
                         oldView.center = CGPointMake(oldView.center.x - offset, oldView.center.y);
                     } completion:^(BOOL finished) {
                         oldView.center = CGPointMake(oldView.center.x + offset, oldView.center.y);
                     }];
}

- (void) setNoContentViewVisible:(BOOL)visible
{
    if(visible)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.noContentLabel];
    }
    else
    {
        self.backgroundColor = [UIColor blackColor];
        [self.noContentLabel removeFromSuperview];
    }
}

- (UILabel *)noContentLabel
{
    if(!_noContentLabel)
    {
        _noContentLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _noContentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _noContentLabel.text = @"Sorry, nothing to display :'(";
        _noContentLabel.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.8];
        _noContentLabel.textAlignment = NSTextAlignmentCenter;
        _noContentLabel.font = [UIFont fontWithName:@"Verdana" size:28];
        _noContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _noContentLabel.numberOfLines = 0;
        
    }
    return _noContentLabel;
}


- (void) toggleLegend
{
    
    if(self.legendLabel == nil)
    {
        UILabel * label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8];
        label.font = [UIFont fontWithName:@"Verdana-bold" size:14];
        label.text = [self.delegate caroussel:self
                         legendForPageAtIndex:self.currentPageIndex];
        
        
        CGRect rect = [label.text boundingRectWithSize:self.bounds.size
                                               options:NSStringDrawingUsesDeviceMetrics
                                            attributes:@{
                                                         NSFontAttributeName : label.font
                                                         }
                                               context:NULL];
        rect.origin.x = 0;
        rect.origin.y = self.bounds.size.height - rect.size.height - 12;
        rect.size.width = self.bounds.size.width;
        rect.size.height += 12;
        label.frame = rect;
        
        [self addSubview:label];
        
        self.legendLabel = label;
    }
    else
    {
        [self.legendLabel removeFromSuperview];
        self.legendLabel = nil;
    }
    
    
}

@end
























