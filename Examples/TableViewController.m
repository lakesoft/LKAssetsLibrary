//
//  TableViewController.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "TableViewController.h"
#import "LKAssetsLibrary.h"
#import "FilterViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController


#pragma mark - Privates
- (void)_assetsGroupManagerDidSetup:(NSNotification*)notification
{
    [self.tableView reloadData];
}

#pragma mark - Basics
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_assetsGroupManagerDidSetup:)
                                                 name:LKAssetsGroupManagerDidSetupNotification
                                               object:nil];
    
//    [LKAssetsGroupManager.sharedManager applyTypeFilter:ALAssetsGroupSavedPhotos];
    [LKAssetsGroupManager sharedManager];   // load albums and photos

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfAssetsGroups: %lx", LKAssetsGroupManager.sharedManager.numberOfAssetsGroups);
    return LKAssetsGroupManager.sharedManager.numberOfAssetsGroups;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];

    LKAssetsGroup* group = [LKAssetsGroupManager.sharedManager assetsGroupAtIndex:indexPath.row];
    
    cell.imageView.image = group.posterImage;
    cell.textLabel.text = group.name;
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    NSLog(@"selected: %lx", indexPath.row);
    FilterViewController* vc = segue.destinationViewController;
    vc.assetsGroup = [LKAssetsGroupManager.sharedManager assetsGroupAtIndex:indexPath.row];
}

@end
