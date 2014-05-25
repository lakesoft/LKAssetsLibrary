//
//  PhotoAlbumManager.m
//  ViewingFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>

#import "LKAssetsGroupManager.h"
#import "LKAssetsGroup.h"

NSString* const LKAssetsGroupManagerDidSetupNotification = @"LKAssetsGroupManagerDidSetupNotification";

@interface LKAssetsGroupManager()
@property (strong, nonatomic) ALAssetsLibrary* assetsLibrary;
@property (strong, nonatomic) NSMutableArray* originalAssetsGroups;
@property (strong, nonatomic) NSArray* filteredAssetsGroups;
@property (assign, nonatomic) NSUInteger typeFilter;
@end

@implementation LKAssetsGroupManager

#pragma mark -
#pragma mark Privates
- (void)_sortAssetsGroup
{
    NSMutableArray* groups = @[].mutableCopy;
    for (LKAssetsGroup* assetsGroup in self.originalAssetsGroups) {
        if (assetsGroup.type != ALAssetsGroupPhotoStream) {
            [groups addObject:assetsGroup];
        }
    }
    [self.originalAssetsGroups removeObjectsInArray:groups];
    [self.originalAssetsGroups addObjectsFromArray:groups];
}

- (void)_applyTypeFilter
{
    if (self.typeFilter) {
        NSMutableArray* groups = @[].mutableCopy;
        for (LKAssetsGroup* assetsGroup in self.originalAssetsGroups) {
            if (self.typeFilter & assetsGroup.type) {
                [groups addObject:assetsGroup];
            }
        }
        self.filteredAssetsGroups = groups;
    } else {
        self.filteredAssetsGroups = nil;
    }
}

- (void)_updateAssetsGroups
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (LKAssetsGroup* assetsGroup in self.assetsGroups) {
            [assetsGroup reload];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSNotificationCenter.defaultCenter postNotificationName:LKAssetsGroupManagerDidSetupNotification object:self];
        });
    });
}


- (void)_setupGroupsWithAssetsFilter:(ALAssetsFilter*)assetsFilter
{
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    self.originalAssetsGroups = @[].mutableCopy;

    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:^(ALAssetsGroup* group, BOOL* stop) {
                                          if (group) {
                                              [group setAssetsFilter:assetsFilter];
                                              [self.originalAssetsGroups addObject:[LKAssetsGroup assetsGroupFrom:group]];
                                          } else {
                                              [self _sortAssetsGroup];
                                              [self _applyTypeFilter];
                                              [self _updateAssetsGroups];
                                          }
                                      }
                                    failureBlock:^(NSError* error) {
                                        NSLog(@"[ERROR] %@", error);
                                    }];

}

#pragma mark -
#pragma mark Basics

#pragma mark -
#pragma mark Properties
- (NSInteger)numberOfAssetsGroups
{
    if (self.filteredAssetsGroups) {
        return self.filteredAssetsGroups.count;
    }
    return self.originalAssetsGroups.count;
}

#pragma mark -
#pragma makr API (AUthorization)
+ (BOOL)isAuthorizationStatusDenied
{
    return ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied);

}


#pragma mark - API
+ (instancetype)assetsGroupManager
{
    return [self assetsGroupManagerWithAssetFilter:ALAssetsFilter.allAssets];
}

+ (instancetype)assetsGroupManagerWithAssetFilter:(ALAssetsFilter*)assetsFilter;
{
    LKAssetsGroupManager* assetsGroupManager = LKAssetsGroupManager.new;
    [assetsGroupManager _setupGroupsWithAssetsFilter:assetsFilter];
    return assetsGroupManager;
}

- (LKAssetsGroup*)assetsGroupAtIndex:(NSInteger)index
{
    if (self.filteredAssetsGroups) {
        return self.filteredAssetsGroups[index];
    }
    return self.originalAssetsGroups[index];
}

- (void)applyTypeFilter:(ALAssetsGroupType)typeFilter
{
    _typeFilter = typeFilter;
    [self _applyTypeFilter];
}

- (void)clearTypeFilter
{
    [self applyTypeFilter:0];
}

- (NSArray*)assetsGroups
{
    return self.filteredAssetsGroups ? self.filteredAssetsGroups : self.originalAssetsGroups;
}

@end
