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

@interface FilterViewController()
@property (nonatomic, strong) LKAssetsCollection* assetsCollection;
@property (nonatomic, strong) LKAssetsCollectionFilter* filter;
@property (nonatomic, strong) LKAssetsCollectionSorter* sorter;
@property (nonatomic, assign) LKAssetsCollectionGroupingType groupingType;
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
        self.groupingType = LKAssetsCollectionGroupingTypeAll;
    }
    
    LKAssetsCollectionGrouping* grouping = [LKAssetsCollectionGrouping assetsCollectionGroupingWithType:self.groupingType];
    
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
    NSLog(@"dealloc");
    [self.assetsGroup unloadAssets];
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
            self.filter = [LKAssetsCollectionFilter assetsCollectorFilterWithType:LKAssetsCollectionFilterTypeJPEG];
            break;
        case 2:
            // Screen
            self.filter = [LKAssetsCollectionFilter assetsCollectorFilterWithType:LKAssetsCollectionFilterTypeScreenShot];
            break;
        case 3:
            // video
            self.filter = [LKAssetsCollectionFilter assetsCollectorFilterWithType:LKAssetsCollectionFilterTypeVideo];
            break;
        case 0:
        default:
            // All
            self.filter = [LKAssetsCollectionFilter assetsCollectorFilterWithType:LKAssetsCollectionFilterTypeAll];
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
            self.groupingType = LKAssetsCollectionGroupingTypeYearly;
            break;
        case 2:
            self.groupingType = LKAssetsCollectionGroupingTypeMonthly;
            break;
        case 3:
            self.groupingType = LKAssetsCollectionGroupingTypeDaily;
            break;
        case 4:
            self.groupingType = LKAssetsCollectionGroupingTypeHourly;
            break;
        case 0:
        default:
            // All
            self.groupingType = LKAssetsCollectionGroupingTypeAll;
            break;
    }
    [self _setupAssetsCollection];
    [NSNotificationCenter.defaultCenter postNotificationName:FilterViewControllerDidChangeAssetsCollectionNotification
                                                      object:self.assetsCollection];
}
- (IBAction)changedSorter:(UISegmentedControl*)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.sorter = [LKAssetsCollectionSorter assetsCollectorSorterWithType:LKAssetsCollectionSorterTypeAscending];
    } else {
        self.sorter = [LKAssetsCollectionSorter assetsCollectorSorterWithType:LKAssetsCollectionSorterTypeDescending];
        self.sorter.shouldSortAssetsInEntry = YES;
    }
    self.assetsCollection.sorter = self.sorter;
    [NSNotificationCenter.defaultCenter postNotificationName:FilterViewControllerDidChangeAssetsCollectionNotification
                                                      object:self.assetsCollection];
}

@end
