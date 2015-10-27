//
//  ViewController.m
//  Rotten Tomatoes
//
//  Created by Michael Hines on 10/20/15.
//  Copyright © 2015 Michael Hines. All rights reserved.
//

#import "MoviesViewController.h"
#import "MoviesTableViewCell.h"
#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"

#define movieURL @"https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
#define networkErrorHeight 23
#define pseudoNetworkDelay 1

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *networkErrorLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Movies";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(fetchMoviesWithDelay) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [SVProgressHUD show];
    [self fetchMoviesWithDelay];
}

- (void)showNetworkError:(BOOL)show {
    if (show) {
        [self.networkErrorLabel setHidden:NO];
        self.networkErrorLabel.frame = CGRectMake(self.networkErrorLabel.frame.origin.x,
                                                  self.networkErrorLabel.frame.origin.y,
                                                  self.networkErrorLabel.frame.size.width,
                                                  networkErrorHeight);
    } else {
        [self.networkErrorLabel setHidden:YES];
        self.networkErrorLabel.frame = CGRectMake(self.networkErrorLabel.frame.origin.x,
                                                  self.networkErrorLabel.frame.origin.y,
                                                  self.networkErrorLabel.frame.size.width,
                                                  0);
    }
}

- (void) fetchMoviesWithDelay {
    [self showNetworkError:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(pseudoNetworkDelay * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        [self fetchMovies];
    });
}

- (void) fetchMovies {
    NSURL *url = [NSURL URLWithString:movieURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                [self fetchCompletedWithData:data andError:error];
                                            }];
    [task resume];
}

- (void)fetchCompletedWithData:(NSData *)data andError:(NSError *)error {
    if (!error) {
        NSError *jsonError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:&jsonError];
        self.movies = responseDictionary[@"movies"];
        [self.tableView reloadData];
    } else {
        [self showNetworkError:YES];
    }
    
    [self.refreshControl endRefreshing];
    [SVProgressHUD dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieDetailsViewController *detailsView = [MovieDetailsViewController new];
    detailsView.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:detailsView animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoviesTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    NSURL *url = [NSURL URLWithString:self.movies[indexPath.row][@"posters"][@"thumbnail"]];
    [cell.imageCell setImageWithURL:url];
    cell.titleLabel.text = self.movies[indexPath.row][@"title"];
    cell.synopsisLabel.text = self.movies[indexPath.row][@"synopsis"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
