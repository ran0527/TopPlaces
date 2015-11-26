//
//  TopPlacesViewController.m
//  TopPlaces
//
//  Created by Kaiqi on 11/24/15.
//  Copyright © 2015 self.edu. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "FlickrFetcher.h"
#import "AFNetworking.h"
#import "PhotoListViewController.h"

@implementation TopPlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [FlickrFetcher URLforTopPlaces];
//    NSDictionary *response = [NSDictionary dictionaryWithContentsOfURL:url];
//    NSLog(@"response: %@", response);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url.absoluteString
                                      parameters:nil
                                         success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
//                                                    NSLog(@"responseObject: %@", responseObject);
                                                    self.places = responseObject[@"places"][@"place"];
                                             [self.tableView reloadData];
                                                }
                                         failure:^(AFHTTPRequestOperation * __nullable operation, NSError * __nonnull error) {
                                                }];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeCell"];
    cell.textLabel.text = [self.places objectAtIndex:indexPath.row][@"_content"];
    return cell;
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender {
    NSUInteger selectedRow = self.tableView.indexPathForSelectedRow.row;
    NSString *placesid = self.places[selectedRow][@"place_id"];
    PhotoListViewController *photoListVC = segue.destinationViewController;
    photoListVC.placesid = placesid;
}

@end
