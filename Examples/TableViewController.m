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
@property (strong, nonatomic) LKAssetsGroupManager* assetsGroupManager;
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
    
    self.assetsGroupManager = [LKAssetsGroupManager assetsGroupManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroupManager.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];

    LKAssetsGroup* assetsGroup = self.assetsGroupManager.assetsGroups[indexPath.row];
    
    cell.imageView.image = assetsGroup.posterImage;
    cell.textLabel.text = assetsGroup.description;
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    FilterViewController* vc = segue.destinationViewController;
    vc.assetsGroup = self.assetsGroupManager.assetsGroups[indexPath.row];
}

@end
