//
//  MoviesTableViewCell.h
//  Rotten Tomatoes
//
//  Created by Michael Hines on 10/20/15.
//  Copyright © 2015 Michael Hines. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageCell;

@end
