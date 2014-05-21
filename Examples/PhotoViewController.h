//
//  PhotoViewController.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKAssetsLibrary.h"

@interface PhotoViewController : UICollectionViewController

@property (nonatomic, weak) LKAssetsCollection* subGroup;
@property (nonatomic, assign) NSInteger photoIndex;

@end
