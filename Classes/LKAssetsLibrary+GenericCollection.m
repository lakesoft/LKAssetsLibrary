//
//  ALAssetsLibrary+Generic.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/11/02.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsLibrary+GenericCollection.h"
#import <objc/runtime.h>

@implementation LKAssetsLibrary (GenericCollection)

- (void)_assetsLibraryDidSetup:(NSNotification*)notification
{
    NSMutableDictionary* vars = objc_getAssociatedObject(self, @"genericVars");
    NSURL* groupURL = vars[@"groupURL"];
    
    LKAssetsGroup* assetsGroup = nil;

    if (groupURL) {
        for (LKAssetsGroup* group in self.assetsGroups) {
            if ([groupURL isEqual:group.url]) {
                assetsGroup = group;
            }
        }
    }

    if (assetsGroup == nil) {
        assetsGroup = self.assetsGroups.firstObject;
    }
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_assetsGroupDidReload:)
                                               name:LKAssetsGroupDidReloadNotification
                                             object:assetsGroup];
    
    [assetsGroup reloadAssets];
}

- (void)_assetsGroupDidReload:(NSNotification*)notification
{
    NSMutableDictionary* vars = objc_getAssociatedObject(self, @"genericVars");
    LKAssetsLibraryGenericCollectionCompletion completion = vars[@"completion"];
    LKAssetsCollectionGenericGroupingType groupingType = ((NSNumber*)vars[@"groupingType"]).integerValue;

    LKAssetsGroup* assetsGroup = notification.object;

    LKAssetsCollectionGenericGrouping* grouping = [LKAssetsCollectionGenericGrouping groupingWithType:groupingType];
    LKAssetsCollection* assetsCollection = [LKAssetsCollection assetsCollectionWithGroup:assetsGroup grouping:grouping];

    completion(assetsCollection);
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
    objc_removeAssociatedObjects(self);
}

- (BOOL)loadGenericAssetsCollectionWithAssetsGroupURL:(NSURL*)groupURL groupingType:(LKAssetsCollectionGenericGroupingType)groupingType completion:(LKAssetsLibraryGenericCollectionCompletion)completion
{
    if (objc_getAssociatedObject(self, @"genericVars")) {
        // Sorry, busy...
        return NO;
    }
    
    NSMutableDictionary* vars = @{}.mutableCopy;
    vars[@"completion"] = [completion copy];
    vars[@"groupingType"] = @(groupingType);

    if (groupURL) {
        vars[@"groupURL"] = groupURL;
    }
    objc_setAssociatedObject(self, @"genericVars", vars, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_assetsLibraryDidSetup:)
                                               name:LKAssetsLibraryDidSetupNotification
                                             object:self];

    [self reload];
    return YES;
}

@end
