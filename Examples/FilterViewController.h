//
//  FilterViewController.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/21.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKAssetsLibrary.h"

#define FilterViewControllerDidChangeAssetsCollectionNotification   @"FilterViewControllerDidChangeAssetsCollectionNotification"

@interface FilterViewController : UIViewController
@property (nonatomic, weak) LKAssetsGroup* assetsGroup;
@end
