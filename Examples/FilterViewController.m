//
//  FilterViewController.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/21.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "FilterViewController.h"
#import "CollectionViewController.h"
#import "LKAssetsLibrary.h"
#import "LKAssetsCollectionDateGrouping.h"
#import "LKAssetsCollectionDateSorter.h"
#import "LKAssetsCollectionGenericFilter.h"

@interface FilterViewController()
@property (nonatomic, strong) LKAssetsCollection* assetsCollection;
@property (nonatomic, strong) LKAssetsCollectionGenericFilter* filter;
@property (nonatomic, strong) LKAssetsCollectionDateSorter* sorter;
@property (nonatomic, assign) LKAssetsCollectionDateGroupingType groupingType;
@end

@implementation FilterViewController

- (void)_assetsGroupDidReload:(NSNotification*)notification
{
    [self _setupAssetsCollection];
    [NSNotificationCenter.defaultCenter postNotificationName:FilterViewControllerDidChangeAssetsCollectionNotification
                                                      object:self.assetsCollection];
}

- (void)_setupAssetsCollection
{
    if (self.groupingType == 0) {
        self.groupingType = LKAssetsCollectionDateGroupingTypeAll;
    }
    
    LKAssetsCollectionDateGrouping* grouping = [LKAssetsCollectionDateGrouping groupingWithType:self.groupingType];
    
    self.assetsCollection = [LKAssetsCollection assetsCollectionWithGroup:self.assetsGroup grouping:grouping];
    self.assetsCollection.filter = self.filter;
    self.assetsCollection.sorter = self.sorter;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_assetsGroupDidReload:)
                                                 name:LKAssetsGroupDidReloadNotification
                                               object:nil];
    [self.assetsGroup reloadAssets];
}

- (void)dealloc
{
    [self.assetsGroup unloadAssets];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (IBAction)changedSegments:(UISegmentedControl*)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 1:
            // JPEG
            self.filter = [LKAssetsCollectionGenericFilter filterWithType:LKAssetsCollectionGenericFilterTypeJPEG];
            break;
        case 2:
            // Screen
            self.filter = [LKAssetsCollectionGenericFilter filterWithType:LKAssetsCollectionGenericFilterTypeScreenShot];
            break;
        case 3:
            // video
            self.filter = [LKAssetsCollectionGenericFilter filterWithType:LKAssetsCollectionGenericFilterTypeVideo];
            break;
        case 0:
        default:
            // All
            self.filter = [LKAssetsCollectionGenericFilter filterWithType:LKAssetsCollectionGenericFilterTypeAll];
            break;
    }
    self.filter.shouldOmitEmptyEntry = YES;
    self.assetsCollection.filter = self.filter;
    [NSNotificationCenter.defaultCenter postNotificationName:FilterViewControllerDidChangeAssetsCollectionNotification
                                                      object:nil];
}

- (IBAction)changedCollection:(UISegmentedControl*)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 1:
            self.groupingType = LKAssetsCollectionDateGroupingTypeYearly;
            break;
        case 2:
            self.groupingType = LKAssetsCollectionDateGroupingTypeMonthly;
            break;
        case 3:
            self.groupingType = LKAssetsCollectionDateGroupingTypeWeekly;
            break;
        case 4:
            self.groupingType = LKAssetsCollectionDateGroupingTypeDaily;
            break;
        case 5:
            self.groupingType = LKAssetsCollectionDateGroupingTypeHourly;
            break;
        case 0:
        default:
            // All
            self.groupingType = LKAssetsCollectionDateGroupingTypeAll;
            break;
    }
    [self _setupAssetsCollection];
    [NSNotificationCenter.defaultCenter postNotificationName:FilterViewControllerDidChangeAssetsCollectionNotification
                                                      object:self.assetsCollection];
}
- (IBAction)changedSorter:(UISegmentedControl*)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.sorter = [LKAssetsCollectionDateSorter sorterAscending:YES];
    } else {
        self.sorter = [LKAssetsCollectionDateSorter sorterAscending:NO];
        self.sorter.shouldSortAssetsInEntry = YES;
    }
    self.assetsCollection.sorter = self.sorter;
    [NSNotificationCenter.defaultCenter postNotificationName:FilterViewControllerDidChangeAssetsCollectionNotification
                                                      object:self.assetsCollection];
}

@end
