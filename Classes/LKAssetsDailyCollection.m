//
//  LKAssetsDayGroup.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsDailyCollection.h"

@implementation LKAssetsDailyCollection

#pragma mark - Properties
- (NSDate *)date
{
    NSDateFormatter* df = NSDateFormatter.new;
    df.dateFormat = @"yyyyMMdd";
    return [df dateFromString:[NSString stringWithFormat:@"%zd", self.dateTimeInteger]];
}


@end
