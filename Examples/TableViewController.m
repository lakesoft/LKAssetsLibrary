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
@property (strong, nonatomic) LKAssetsLibrary* assetsLibrary;
@end

@implementation TableViewController


#pragma mark - Privates
- (void)_assetsLibraryDidSetup:(NSNotification*)notification
{
    [self.tableView reloadData];
}

- (void)_assetsLibraryDidInsertGroup:(NSNotification*)notification
{
    NSArray* groups = notification.userInfo[LKAssetsLibraryGroupsKey];
    NSLog(@"%s|inserted: %@", __PRETTY_FUNCTION__, groups);
    [self.tableView reloadData];
}

- (void)_assetsLibraryDidUpdateGroup:(NSNotification*)notification
{
    NSArray* groups = notification.userInfo[LKAssetsLibraryGroupsKey];
    NSLog(@"%s|updated: %@", __PRETTY_FUNCTION__, groups);
    [self.tableView reloadData];
}

- (void)_assetsLibraryDidDeleteGroup:(NSNotification*)notification
{
    NSArray* groups = notification.userInfo[LKAssetsLibraryGroupsKey];
    NSLog(@"%s|deleted: %@", __PRETTY_FUNCTION__, groups);
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
                                             selector:@selector(_assetsLibraryDidSetup:)
                                                 name:LKAssetsLibraryDidSetupNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_assetsLibraryDidInsertGroup:)
                                                 name:LKAssetsLibraryDidInsertGroupsNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_assetsLibraryDidUpdateGroup:)
                                                 name:LKAssetsLibraryDidUpdateGroupsNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_assetsLibraryDidDeleteGroup:)
                                                 name:LKAssetsLibraryDidDeleteGroupsNotification
                                               object:nil];

    
    self.assetsLibrary = [LKAssetsLibrary assetsLibrary];
//    self.assetsLibrary = [LKAssetsLibrary assetsLibraryWithAssetsGroupType:ALAssetsGroupSavedPhotos assetsFilter:ALAssetsFilter.allPhotos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsLibrary.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];

    LKAssetsGroup* assetsGroup = self.assetsLibrary.assetsGroups[indexPath.row];
    
    cell.imageView.image = assetsGroup.posterImage;
    cell.textLabel.text = assetsGroup.description;
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    FilterViewController* vc = segue.destinationViewController;
    vc.assetsGroup = self.assetsLibrary.assetsGroups[indexPath.row];
}

@end
