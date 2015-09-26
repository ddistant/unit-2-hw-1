//
//  DetailsTableViewController.m
//  TalkinToTheNet
//
//  Created by Daniel Distant on 9/24/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "DetailsTableViewController.h"
#import "DetailsTableViewCell.h"

@interface DetailsTableViewController ()

@property (nonatomic) NSMutableArray *searchResults;

@end

@implementation DetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.searchResults.count == 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Search Error"
                                                                       message:@"No search results found!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)doneButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Details Cell Identifier" forIndexPath:indexPath];
    
    return cell;
}


@end
