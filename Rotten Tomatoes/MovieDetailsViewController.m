//
//  MovieDetailsViewController.m
//  
//
//  Created by Michael Hines on 10/20/15.
//
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *detailsSubView;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.movie);
    [self.posterImageView setImageWithURL: [self fullSizedImageUrl]];
    self.titleLabel.text = self.movie[@"title"];
    self.detailsLabel.text = self.movie[@"synopsis"];
    [self autoSizeLabel];
}

- (void)autoSizeLabel {
    [self.detailsLabel sizeToFit];
    CGFloat subviewHeight = self.titleLabel.bounds.size.height + self.detailsLabel.bounds.size.height + 20;
    CGRect existingFrame = self.detailsSubView.frame;
    self.detailsSubView.frame = CGRectMake(existingFrame.origin.x, existingFrame.origin.y, existingFrame.size.width, subviewHeight + 1000);
    
    CGFloat width = self.scrollView.bounds.size.width;
    CGFloat height = self.detailsSubView.frame.origin.y + subviewHeight;
    self.scrollView.contentSize = CGSizeMake(width, height);
}

- (NSURL *)fullSizedImageUrl {
    NSString *originalUrlString = self.movie[@"posters"][@"original"];
    NSRange hostRange = [originalUrlString rangeOfString:@".*cloudfront.net/"
                                           options:NSRegularExpressionSearch];
    NSString *contentUrlString = [originalUrlString stringByReplacingCharactersInRange:hostRange
                                                    withString:@"https://content6.flixster.com/"];
    return [NSURL URLWithString:contentUrlString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
