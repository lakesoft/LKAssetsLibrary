//
//  CollectionViewController.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "CollectionViewController.h"
#import "LKAssetsLibrary.h"
#import "AssetCell.h"
#import "AssetHeaderView.h"
#import "PhotoViewController.h"
#import "FilterViewController.h"

@interface CollectionViewController()
@property (nonatomic, strong) LKAssetsCollection* assetsCollection;
@end

@implementation CollectionViewController

- (void)_didChangeCollection:(NSNotification*)notification
{
    if (notification.object) {
        self.assetsCollection = notification.object;
    }
    [self.collectionView reloadData];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.collectionView.alpha = 1.0;
                     }];
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
    self.collectionView.alpha = 0.0;
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_didChangeCollection:)
                                               name:FilterViewControllerDidChangeAssetsCollectionNotification
                                             object:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.assetsCollection.entries.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    LKAssetsCollectionEntry* entry = self.assetsCollection.entries[section];
    return entry.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AssetCell* cell = (AssetCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCell"
                                                                           forIndexPath:indexPath];
    LKAssetsCollectionEntry* entry = self.assetsCollection.entries[indexPath.section];
    LKAsset* asset = entry.assets[indexPath.row];
    cell.imageView.image = asset.thumbnail;
    return cell;
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        AssetHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AssetHeaderView" forIndexPath:indexPath];
        LKAssetsCollectionEntry* entry = self.assetsCollection.entries[indexPath.section];
        view.title.text = entry.description;
        reusableView = view;
    }
    return reusableView;
}

#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    NSIndexPath* indexPath = [self.collectionView indexPathForCell:sender];
//    NSLog(@"selected: %lx", indexPath.row);
//    PhotoViewController* vc = segue.destinationViewController;
//    vc.subGroup = self.assetsGroup.collections[indexPath.section];
//    vc.photoIndex = indexPath.row;
//}

@end
