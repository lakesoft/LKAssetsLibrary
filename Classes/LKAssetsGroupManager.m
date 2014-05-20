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

NSString* const LKAssetsGroupManagerDidSetup = @"LKAssetsGroupManagerDidSetup";

@interface LKAssetsGroupManager()
@property (strong, nonatomic) ALAssetsLibrary* assetsLibrary;
@property (strong, nonatomic) NSMutableArray* assetsGroups;
@property (strong, nonatomic) NSArray* filteredAssetsGroups;
@property (assign, nonatomic) NSUInteger typeFilter;
@end

@implementation LKAssetsGroupManager

#pragma mark -
#pragma mark Privates
- (void)_sortAssetsGroup
{
    NSMutableArray* groups = @[].mutableCopy;
    for (LKAssetsGroup* assetsGroup in self.assetsGroups) {
        if (assetsGroup.type != ALAssetsGroupPhotoStream) {
            [groups addObject:assetsGroup];
        }
    }
    [self.assetsGroups removeObjectsInArray:groups];
    [self.assetsGroups addObjectsFromArray:groups];
}

- (void)_applyTypeFilter
{
    if (self.typeFilter) {
        NSMutableArray* groups = @[].mutableCopy;
        for (LKAssetsGroup* assetsGroup in self.assetsGroups) {
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
        NSArray* groups = self.filteredAssetsGroups ? self.filteredAssetsGroups : self.assetsGroups;
        for (LKAssetsGroup* assetsGroup in groups) {
            [assetsGroup reload];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSNotificationCenter.defaultCenter postNotificationName:LKAssetsGroupManagerDidSetup object:self];
        });
    });
}

- (void)_setup
{
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    self.assetsGroups = @[].mutableCopy;

    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:^(ALAssetsGroup* group, BOOL* stop) {
                                          if (group) {
                                              LKAssetsGroup* assetsGroup = [LKAssetsGroup assetsGroupFrom:group groupFilter:LKAssetsGroupFilterAllAssets];
                                              [self.assetsGroups addObject:assetsGroup];
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
- (id)init
{
    self = super.init;

    if (self) {
        [self _setup];
    }
    return self;
}

#pragma mark -
#pragma mark Properties
- (NSInteger)numberOfAssetsGroups
{
    if (self.filteredAssetsGroups) {
        return self.filteredAssetsGroups.count;
    }
    return self.assetsGroups.count;
}

#pragma mark -
#pragma makr API (AUthorization)
+ (BOOL)isAuthorizationStatusDenied
{
    return ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied);

}


#pragma mark - API

static __strong LKAssetsGroupManager* _sharedManager = nil;

+ (LKAssetsGroupManager*)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = self.new;
    });
    return _sharedManager;
}

- (LKAssetsGroup*)assetsGroupAtIndex:(NSInteger)index
{
    if (self.filteredAssetsGroups) {
        return self.filteredAssetsGroups[index];
    }
    return self.assetsGroups[index];
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

@end
