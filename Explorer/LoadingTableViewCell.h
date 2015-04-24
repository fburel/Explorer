//
//  LoadingTableViewCell.h
//  Explorer
//
//  Created by florian BUREL on 24/04/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
