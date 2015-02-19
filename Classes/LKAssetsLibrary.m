//
//  PhotoAlbumManager.m
//  ViewingFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>

#import "LKAssetsLibrary.h"
#import "LKAssetsGroup.h"

NSString* const LKAssetsLibraryDidSetupNotification = @"LKAssetsLibraryDidSetupNotification";
NSString* const LKAssetsLibraryDidInsertGroupsNotification = @"LKAssetsLibraryDidInsertGroupsNotification";
NSString* const LKAssetsLibraryDidUpdateGroupsNotification = @"LKAssetsLibraryDidUpdateGroupsNotification";
NSString* const LKAssetsLibraryDidDeleteGroupsNotification = @"LKAssetsLibraryDidDeleteGroupsNotification";
NSString* const LKAssetsLibraryGroupsKey = @"LKAssetsLibraryGroupsKey";

@interface LKAssetsLibrary()
@property (strong, nonatomic) ALAssetsLibrary* assetsLibrary;
@property (strong, nonatomic) NSMutableArray* mutableAssetsGroups;
@property (assign, nonatomic) NSUInteger assetsGroupType;
@property (strong, nonatomic) ALAssetsFilter* assetsFilter;
@end

@implementation LKAssetsLibrary

#pragma mark -
#pragma mark Privates
- (void)_sortAssetsGroup
{
    if (self.sortComparator) {
        [self.mutableAssetsGroups sortUsingComparator:self.sortComparator];
    }
}

- (void)_applyAssetsGroupType
{
    if (self.assetsGroupType) {
        NSMutableArray* groups = @[].mutableCopy;
        for (LKAssetsGroup* assetsGroup in self.mutableAssetsGroups) {
            if (self.assetsGroupType & assetsGroup.type) {
                [groups addObject:assetsGroup];
            }
        }
        self.mutableAssetsGroups = groups;
    }
}

- (void)_reloadGroups
{
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    self.mutableAssetsGroups = @[].mutableCopy;

    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:^(ALAssetsGroup* group, BOOL* stop) {
                                          if (group) {
                                              [group setAssetsFilter:self.assetsFilter];
                                              LKAssetsGroup* assetsGroup = [self.assetsGroupClass assetsGroupFrom:group];
                                              [self.mutableAssetsGroups addObject:assetsGroup];
                                          } else {
                                              [self _sortAssetsGroup];
                                              [self _applyAssetsGroupType];
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [NSNotificationCenter.defaultCenter postNotificationName:LKAssetsLibraryDidSetupNotification object:self];
                                              });
                                          }
                                      }
                                    failureBlock:^(NSError* error) {
                                        NSLog(@"%s|%@", __PRETTY_FUNCTION__, error);
                                    }];

}

- (NSIndexSet*)_indexesOfGroupsWithURLs:(NSArray*)urls {
    return [self.mutableAssetsGroups indexesOfObjectsPassingTest:^BOOL(LKAssetsGroup* group, NSUInteger idx, BOOL *stop) {
        return [urls containsObject:group.url];
    }];
}

- (void)_assetsLibrarychanged:(NSNotification*)notification
{
    NSDictionary * userInfo = notification.userInfo;
    if (userInfo) {
        [self _processInsertedAssetGroupsWithURLS:userInfo[ALAssetLibraryInsertedAssetGroupsKey]];
        [self _processUpdatedAssetGroupsWithURLS:userInfo[ALAssetLibraryUpdatedAssetGroupsKey]];
        [self _processDeletedAssetGroupsWithURLS:userInfo[ALAssetLibraryDeletedAssetGroupsKey]];
        
    } else {
        [self _reloadGroups];
    }
}

- (void)_finishProcessingChangesWithNotificationName:(NSString*)notificationName groups:(NSArray*)groups
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSNotificationCenter.defaultCenter postNotificationName:notificationName
                                                          object:self
                                                        userInfo:@{LKAssetsLibraryGroupsKey:groups}];
    });
}

- (void)_processInsertedAssetGroupsWithURLS:(NSArray*)urls
{
    if (urls.count == 0) {
        return;
    }

    NSMutableArray* insertedGroups = @[].mutableCopy;
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:^(ALAssetsGroup* group, BOOL* stop) {
                                          if (group) {
                                              NSURL* url = [group valueForProperty:ALAssetsGroupPropertyURL];
                                              if ([urls containsObject:url]) {
                                                  [group setAssetsFilter:self.assetsFilter];
                                                  LKAssetsGroup* assetsGroup = [self.assetsGroupClass assetsGroupFrom:group];
;
                                                  if (assetsGroup.type & self.assetsGroupType) {
                                                      [self.mutableAssetsGroups addObject:assetsGroup];
                                                      [insertedGroups addObject:assetsGroup];
                                                  }
                                              }
                                          } else {
                                              [self _sortAssetsGroup];
                                              [self _finishProcessingChangesWithNotificationName:LKAssetsLibraryDidInsertGroupsNotification
                                                                                          groups:insertedGroups];
                                          }
                                      }
                                    failureBlock:^(NSError* error) {
                                        NSLog(@"%s|%@", __PRETTY_FUNCTION__, error);
                                    }];
}

- (void)_processUpdatedAssetGroupsWithURLS:(NSArray*)urls
{
    if (urls.count == 0) {
        return;
    }
    
    NSIndexSet * indexSet = [self _indexesOfGroupsWithURLs:urls];
    NSArray* updatedGroups = [self.mutableAssetsGroups objectsAtIndexes:indexSet];
    
    [self _finishProcessingChangesWithNotificationName:LKAssetsLibraryDidUpdateGroupsNotification
                                                groups:updatedGroups];
}

- (void)_processDeletedAssetGroupsWithURLS:(NSArray*)urls
{
    if (urls.count == 0) {
        return;
    }
    
    NSIndexSet * indexSet = [self _indexesOfGroupsWithURLs:urls];
    NSArray* deletedGroups = [self.mutableAssetsGroups objectsAtIndexes:indexSet];
    
    [self.mutableAssetsGroups removeObjectsAtIndexes:indexSet];

    [self _finishProcessingChangesWithNotificationName:LKAssetsLibraryDidInsertGroupsNotification
                                                groups:deletedGroups];
}

#pragma mark -
#pragma mark Basics
- (id)initWithAssetsGroupType:(ALAssetsGroupType)assetsGroupType assetsFilter:(ALAssetsFilter*)assetsFilter
{
    self = [super init];
    if (self) {
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(_assetsLibrarychanged:)
                                                   name:ALAssetsLibraryChangedNotification
                                                 object:nil];
        self.assetsGroupClass = LKAssetsGroup.class;
        self.assetsFilter = assetsFilter;
        self.assetsGroupType = assetsGroupType;
        self.sortComparator = ^NSComparisonResult(LKAssetsGroup* group1, LKAssetsGroup* group2) {
            return [group1 compare:group2];
        };
    }
    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}


#pragma mark -
#pragma makr API (AUthorization)
+ (BOOL)isAuthorizationStatusDenied
{
    return ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied);

}

- (void)reload
{
    [self _reloadGroups];
}

#pragma mark - API
+ (instancetype)assetsLibrary
{
    return [self assetsLibraryWithAssetsGroupType:ALAssetsGroupAll assetsFilter:ALAssetsFilter.allAssets];
}

+ (instancetype)assetsLibraryWithAssetsGroupType:(ALAssetsGroupType)assetsGroupType assetsFilter:(ALAssetsFilter*)assetsFilter
{
    LKAssetsLibrary* assetsLibrary = [[LKAssetsLibrary alloc] initWithAssetsGroupType:assetsGroupType
                                                                                        assetsFilter:assetsFilter];
    return assetsLibrary;
}

- (NSArray*)assetsGroups
{
    return self.mutableAssetsGroups;
}

@end
