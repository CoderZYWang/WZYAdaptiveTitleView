//
//  ViewController.m
//  TestTitleView
//
//  Created by 王中尧 on 2017/8/12.
//  Copyright © 2017年 lexingtianxia. All rights reserved.
//



#import "ViewController.h"

#import "LXTaxiTitleView.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
#define FONTSYSTEM(s) [UIFont fontWithName:@"PingFang SC" size:s]
#else
#define FONTSYSTEM(s) [UIFont fontWithName:@"Heiti SC" size:s]
#endif

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LXTaxiTitleView *titleView = [LXTaxiTitleView setupTaxiTitleViewWithFrame:CGRectMake(10, 200, MS_SCREEN_WIDTH - 20, 40) titlesArr:@[@"附近地点", @"商城", @"景点", @"学校", @"公交站点", @"电影院", @"政府机构以及社会团体"] titleFont:FONTSYSTEM(14)];
//    NSLog(@"titleView --- %@ --- %@", titleView.class, titleView);
    [self.view addSubview:titleView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
