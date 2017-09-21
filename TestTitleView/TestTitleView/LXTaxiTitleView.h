//
//  LXTaxiTitleView.h
//  LXYC
//
//  Created by 王中尧 on 2017/8/12.
//  Copyright © 2017年 lexingtianxia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Frame.h"
#define MS_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define MS_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface LXTaxiTitleView : UIView

/**
 *  初始化一个 titleView
 *
 *  titlesArr   标题数组
 *  titleFont   标题字号
 */
+ (instancetype)setupTaxiTitleViewWithFrame:(CGRect)frame titlesArr:(NSArray *)titlesArr titleFont:(UIFont *)titleFont;

@end
