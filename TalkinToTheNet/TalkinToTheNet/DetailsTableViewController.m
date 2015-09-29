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



@end

@implementation DetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];

}

-(void) setup {
    
    //'no search results' alert
    
    self.searchResultsTV = [[NSMutableArray alloc] init];
    
    if (self.searchResultsTV.count == 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Search Error"
                                                                       message:@"No search results found!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    //custom cells
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 12.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailsTableViewCell"];
    
}

- (IBAction)doneButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultsTV.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsTableViewCell" forIndexPath:indexPath];
    
    return cell;
}


@end
