//
//  DetailsTableViewController.m
//  TalkinToTheNet
//
//  Created by Daniel Distant on 9/24/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "DetailsTableViewController.h"
#import "DetailsTableViewCell.h"
#import "APIManager.h"
#import "InstagramPost.h"

@interface DetailsTableViewController ()

@end

@implementation DetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self fetchInstagramData];
}

-(void) setup {
    
    //'no search results' alert
    
    self.searchResults = [[NSMutableArray alloc] init];
    
    //custom cells
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 12.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailsTableViewCell"];
    
    //pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pulledToRefresh:) forControlEvents:UIControlEventValueChanged];
    
}

- (void) fetchInstagramData {
    
    NSString *urlString = [NSString stringWithFormat: @"https://api.instagram.com/v1/tags/%@/media/recent?client_id=ac0ee52ebb154199bfabfb15b498c067", self.searchTerm];
    
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:encodedString];
    
    [APIManager GETRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSArray *results = json[@"data"];
            
            self.searchResults = [[NSMutableArray alloc] init];
            
            for (NSDictionary *result in results) {
                InstagramPost *post = [[InstagramPost alloc] initWithJSON:result];
                [self.searchResults addObject:post];
            }
            
            if (self.searchResults.count == 0) {
                [self createAlertWithTitle:@"Search Error" andMessage:@"No pictures found!"];
            }
            [self.tableView reloadData];
        }
    }];

}

-(void)pulledToRefresh:(UIRefreshControl *)sender {
    [self fetchInstagramData];
    [sender endRefreshing];
}

- (void) createAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstagramCellIdentifier" forIndexPath:indexPath];
    
    InstagramPost *post = self.searchResults[indexPath.row];
    cell.textLabel.text = post.username;
    cell.detailTextLabel.text = post.caption;
    NSURL *imageURL = [NSURL URLWithString:post.imageURLString];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    cell.imageView.image = [UIImage imageWithData:imageData];
    
    return cell;
}




@end
