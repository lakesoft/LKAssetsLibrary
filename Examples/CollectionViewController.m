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

@interface CollectionViewController ()
@property (nonatomic, strong) LKAssetsGroup* assetsGroup;
@end

@implementation CollectionViewController

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
    self.assetsGroup = [LKAssetsGroupManager.sharedManager assetsGroupAtIndex:self.groupIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.assetsGroup.dayAssets.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    LKAssetsDayGroup* dayGroup = self.assetsGroup.dayAssets[section];
    return dayGroup.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AssetCell* cell = (AssetCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCell"
                                                                           forIndexPath:indexPath];
    LKAssetsDayGroup* dayGroup = self.assetsGroup.dayAssets[indexPath.section];
    LKAsset* asset = dayGroup.assets[indexPath.row];
    cell.imageView.image = asset.thumbnail;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        AssetHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AssetHeaderView" forIndexPath:indexPath];
        LKAssetsDayGroup* dayGroup = self.assetsGroup.dayAssets[indexPath.section];
        view.title.text = dayGroup.description;
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
    vc.dayGroup = self.assetsGroup.dayAssets[indexPath.section];
    vc.photoIndex = indexPath.row;
}

@end
