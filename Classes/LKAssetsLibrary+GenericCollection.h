//
//  ALAssetsLibrary+Generic.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/11/02.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsLibrary.h"

typedef void(^LKAssetsLibraryGenericCollectionCompletion)(LKAssetsCollection* assetsCollection);

@interface LKAssetsLibrary (GenericCollection)

// return YES=accepted request / NO=busy
- (BOOL)loadGenericAssetsCollectionWithAssetsGroupURL:(NSURL*)url groupingType:(LKAssetsCollectionGenericGroupingType)groupingType completion:(LKAssetsLibraryGenericCollectionCompletion)completion;

@end
