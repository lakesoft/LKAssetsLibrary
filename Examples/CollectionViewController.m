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

@implementation CollectionViewController

- (void)_didApplySubFilter:(NSNotification*)notification
{
    [self.collectionView reloadData];
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
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_didApplySubFilter:)
                                               name:LKAssetsGroupDidSetCategoryNotification
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
    return self.assetsGroup.collections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    LKAssetsCollection* collection = self.assetsGroup.collections[section];
    return collection.numberOfAssets;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AssetCell* cell = (AssetCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCell"
                                                                           forIndexPath:indexPath];
    LKAssetsCollection* collection = self.assetsGroup.collections[indexPath.section];
    LKAsset* asset = [collection assetAtIndex:indexPath.row];
    cell.imageView.image = asset.thumbnail;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        AssetHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AssetHeaderView" forIndexPath:indexPath];
        LKAssetsCollection* collection = self.assetsGroup.collections[indexPath.section];
        view.title.text = collection.description;
        reusableView = view;
    }
    return reusableView;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:sender];
    NSLog(@"selected: %lx", indexPath.row);
    PhotoViewController* vc = segue.destinationViewController;
    vc.subGroup = self.assetsGroup.collections[indexPath.section];
    vc.photoIndex = indexPath.row;
}

@end
