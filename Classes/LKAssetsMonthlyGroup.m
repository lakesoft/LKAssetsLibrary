//
//  LKAssetsMonthlyGroup.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/21.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsMonthlyGroup.h"

@implementation LKAssetsMonthlyGroup

#pragma mark - Properties
- (NSDate *)date
{
    NSDateFormatter* df = NSDateFormatter.new;
    df.dateFormat = @"yyyyMM";
    return [df dateFromString:[NSString stringWithFormat:@"%zd", self.dateTimeInteger]];
}

@end
