//
//  PhotoListViewController.m
//  TopPlaces
//
//  Created by Kaiqi on 11/24/15.
//  Copyright © 2015 self.edu. All rights reserved.
//

#import "PhotoListViewController.h"
#import "ImageViewController.h"
#import "FlickrFetcher.h"
#import "AFNetworking.h"

@implementation PhotoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *photosInPlaceurl = [FlickrFetcher URLforPhotosInPlace:self.placesid  maxResults:50];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:photosInPlaceurl.absoluteString parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        NSLog(@"download complete");
        self.photos = responseObject[@"photos"][@"photo"];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * __nullable operation, NSError * __nonnull error) {
        NSLog(@"error, %@", error);
    }];
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
    cell.textLabel.text = self.photos[indexPath.row][@"title"];
    cell.detailTextLabel.text = self.photos[indexPath.row][@"description"];
    return cell;
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender {
    NSUInteger selectedRow = self.tableView.indexPathForSelectedRow.row;
    NSString *urlStr = self.photos[selectedRow][@"imageURL"];
    ImageViewController *imageVC = segue.destinationViewController;
    imageVC.imageURL = [NSURL URLWithString:urlStr];
}


//+ (NSURL *)URLforPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format;
//{
//    return [NSURL URLWithString:[self urlStringForPhoto:photo format:format]];
//}

@end
