//
//  TabBarController.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/21.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "TabBarController.h"
#import "CollectionViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s| %@", __PRETTY_FUNCTION__, sender);
}


@end
