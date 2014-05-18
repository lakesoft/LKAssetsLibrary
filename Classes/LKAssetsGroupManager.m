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

- (void)_updateAssetsGroups
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (LKAssetsGroup* assetsGroup in self.assetsGroups) {
//            NSLog(@"%@: %d", assetsGroup.name, assetsGroup.type);
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
                                              LKAssetsGroup* assetsGroup = [LKAssetsGroup assetsGroupFrom:group];
                                              [self.assetsGroups addObject:assetsGroup];
                                          } else {
                                              [self _sortAssetsGroup];
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
    return self.assetsGroups.count;
}

#pragma mark -
#pragma makr API (AUthorization)
+ (BOOL)isAuthorizationStatusDenied
{
    return ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied);

}


#pragma mark -
#pragma mark APIs

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
    if (index < self.numberOfAssetsGroups) {
        return self.assetsGroups[index];
    }
    return nil;
}

@end
