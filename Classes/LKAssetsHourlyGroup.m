//
//  LKAssetsHourlyGroup.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/21.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsHourlyGroup.h"

@implementation LKAssetsHourlyGroup

#pragma mark - Properties
- (NSDate *)date
{
    NSDateFormatter* df = NSDateFormatter.new;
    df.dateFormat = @"yyyyMMddHH";
    return [df dateFromString:[NSString stringWithFormat:@"%zd", self.dateTimeInteger]];
}

@end
